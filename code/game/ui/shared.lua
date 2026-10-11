local SavesFilesModule = require("code.engine.saves.files")
local SoundHandlerModule = require("code.engine.soundHandler")

local BoxesObjectModule = require("code.game.boxes.object")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UIObjectHelperModule = require("code.game.ui.helpers.object")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local UILayoutData = require("code.data.ui.layout")

local COMMON_VALUES = require("code.data.ui.commonValues")
local CONSTANTS = require("code.data.constants")

local SharedData = require("code.data.ui.scenes.shared")
local BoxesData = require("code.data.boxes")

local DISCORD_URL = "https://www.discord.gg/pQShPG8XPf"

local Module = {}
Module._updateFunctions = {}

local function _getHighestTierAcrossSaves()
	local highestTier = 0

	for slot = 1, CONSTANTS.SAVES.MAX_SAVE_SLOTS do
		local save = SavesFilesModule:ReadFile(slot)

		if save and save.stats then
			highestTier = math.max(highestTier, save.tracking.highestBoxTier or 0)
		end
	end

	return highestTier
end

-- Creates a label and keeps its text updated while a save is loaded.
local function _setupUpdatingLabel(scene, updateKey, labelData, getText)
	local label = UIObjectHelperModule.CreateElement(labelData, scene)

	Module._updateFunctions[updateKey] = function()
		if not SavesFilesModule.loadedFile then return end

		label.text = getText()
	end
end

-- Plays a one-shot UI sound.
function Module:PlaySound(soundPath)
	SoundHandlerModule.new({ soundPath = soundPath }):Play(true)
end

function Module:PlayNotAllowedSound()
	self:PlaySound("assets/sounds/ui/notallowed.wav")
end

function Module:SetupHighestTierBoxes(scene)
	local highestTier = _getHighestTierAcrossSaves()
	if highestTier <= 0 then return end

	for type, data in pairs(UILayoutData.shared.backgroundBoxes) do
		local box = BoxesData[type]

		if box and box.tier and box.tier <= highestTier then
			UIObjectHelperModule.CreateElement({
				name = type .. "BackgroundBox",

				spritePath = UILayoutData.shared.backgroundBoxesPathPrefix
					.. "box"
					.. box.tier
					.. ".png",

				x = data.x,
				y = data.y,

				zIndex = COMMON_VALUES.Z_WORLD + data.zIndex,

				shaders = data.shaders
			}, scene)
		end
	end
end

function Module:SetupSettingsButton(scene)
	UIObjectHelperModule.CreateElementButton(
		scene,
		SharedData.settingsButtonHitbox,
		nil,
		function()
			UISceneHandlerModule:TransitionTo("settings")
		end
	)
end

function Module:SetupDiscordButton(scene)
	UIObjectHelperModule.CreateElementButton(
		scene,
		SharedData.discordButtonHitbox,
		nil,
		function()
			love.system.openURL(DISCORD_URL)
		end
	)
end

function Module:SetupSidebarBackground(scene)
	UIObjectHelperModule.CreateElement(
		SharedData.sidebarBackground,
		scene
	)
end

function Module:SetupShopBackButton(scene)
	UIObjectHelperModule.CreateElementButton(
		scene,
		SharedData.shopBackButtonHitbox,
		SharedData.shopBackButtonLabel,
		function()
			UISceneHandlerModule:TransitionTo("boxRanch")
		end
	)
end

function Module:SetupBackToMenuButton(scene)
	UIObjectHelperModule.CreateElementButton(
		scene,
		SharedData.backToMenuButtonHitbox,
		nil,
		function()
			ScreenTransitionModule:Transition({
				callback = function()
					SavesFilesModule:UnloadFile(SavesFilesModule.loadedFile)
					BoxesObjectModule:ClearBoxes()

					UISceneHandlerModule:Switch("saveFiles")
				end
			})
		end
	)
end

function Module:SetupCurrencyLabels(scene)
	_setupUpdatingLabel(
		scene,
		"creditsLabelUpdateFunction",
		SharedData.creditsLabel,
		function()
			return string.formatNumber(SavesFilesModule:Get("currencies.credits")) .. " C$"
		end
	)
end

function Module:SetupSessionPlaytimeLabel(scene)
	_setupUpdatingLabel(
		scene,
		"sessionPlaytimeLabelUpdateFunction",
		SharedData.sessionPlaytimeLabel,
		function()
			return string.formatTime(
				SavesFilesModule:Get("tracking.playtime")
					- SavesFilesModule.playtimeAtSessionStart
			)
		end
	)
end

function Module:SetupBackground(scene)
	local sceneData = require(
		"code.data.ui.scenes." .. scene.name
	)

	UIObjectHelperModule.CreateElement(
		sceneData.background,
		scene
	)
end

-- Everything the shop-style scenes (upgrade shop, black market, ...) have in common.
function Module:SetupShopScene(scene)
	self:SetupSidebarBackground(scene)
	self:SetupBackground(scene)

	self:SetupBackToMenuButton(scene)
	self:SetupSettingsButton(scene)

	self:SetupSessionPlaytimeLabel(scene)
	self:SetupCurrencyLabels(scene)

	self:SetupShopBackButton(scene)
end

function Module:Update(deltaTime)
	for _, updateFunction in pairs(self._updateFunctions) do
		updateFunction(deltaTime)
	end
end

function Module:Clean()
	self._updateFunctions = {}
end

return Module