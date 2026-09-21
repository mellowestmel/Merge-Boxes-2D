local SavesFilesModule = require("code.engine.saves.files")

local string = require("code.engine.helpers.string")


local BoxesObjectModule = require("code.game.boxes.object")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UIButtonObjectModule = require("code.game.ui.objects.button")
local UIObjectHelperModule = require("code.game.ui.helpers.object")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local UILayoutData = require("code.data.ui.layout")

local COMMON_VALUES = require("code.data.ui.commonValues")
local CONSTANTS = require("code.data.constants")

local SharedData = require("code.data.ui.scenes.shared")
local BoxesData = require("code.data.boxes")

local Module = {}
Module._updateFunctions = {}

local function _getHighestTierAcrossSaves()
	local highestTier = 0

	for slot = 1, CONSTANTS.SAVES.MAX_SAVE_SLOTS do
		local save = SavesFilesModule:ReadFile(slot)

		if save and save.stats then
			local tier = save.tracking.highestBoxTier or 0

			if tier > highestTier then
				highestTier = tier
			end
		end
	end

	return highestTier
end

function Module:SetupHighestTierBoxes(scene)
	local highestTier = _getHighestTierAcrossSaves()
	if highestTier <= 0 then return end

	for type, data in pairs(UILayoutData.shared.backgroundBoxes) do
		local box = BoxesData[type]

		if not box then goto continue end
		if not box.tier then goto continue end
		if box.tier > highestTier then goto continue end

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

		::continue::
	end
end

function Module:SetupSettingsButton(scene)
	if not scene then return end

	local settingsButtonHitbox = UIObjectHelperModule.CreateElement(
		SharedData.settingsButtonHitbox,
		scene
	)

	local settingsButton = UIButtonObjectModule.new({
		elements = {settingsButtonHitbox},
		hitboxElement = settingsButtonHitbox,

		mouseButton = 1,

		onClick = function()
			ScreenTransitionModule:Transition({
				callback = function()
					UISceneHandlerModule:Switch("settings")
				end
			})
		end
	})

	table.insert(scene._objects, settingsButton)

	if scene._hideableElements then
		table.insert(scene._hideableElements, settingsButtonHitbox)
	end
end

function Module:SetupDiscordButton(scene)
	if not scene then return end

	local discordButtonHitbox = UIObjectHelperModule.CreateElement(
		SharedData.discordButtonHitbox,
		scene
	)

	local discordButton = UIButtonObjectModule.new({
		elements = {discordButtonHitbox},
		hitboxElement = discordButtonHitbox,

		mouseButton = 1,

		onClick = function()
			love.system.openURL("https://www.discord.gg/pQShPG8XPf")
		end
	})

	table.insert(scene._objects, discordButton)

	if scene._hideableElements then
		table.insert(scene._hideableElements, discordButtonHitbox)
	end
end

function Module:SetupSidebarBackground(scene)
	UIObjectHelperModule.CreateElement(
		SharedData.sidebarBackground,
		scene
	)
end

function Module:SetupShopBackButton(scene)
	local shopBackButtonHitbox = UIObjectHelperModule.CreateElement(
		SharedData.shopBackButtonHitbox,
		scene
	)

	local shopBackButtonLabel = UIObjectHelperModule.CreateElement(
		SharedData.shopBackButtonLabel,
		scene
	)

	local shopBackButton = UIButtonObjectModule.new({
		elements = {
			shopBackButtonHitbox,
			shopBackButtonLabel
		},

		hitboxElement = shopBackButtonHitbox,

		mouseButton = 1,

		onClick = function()
			ScreenTransitionModule:Transition({
				callback = function()
					UISceneHandlerModule:Switch("boxRanch")
				end
			})
		end
	})

	table.insert(scene._objects, shopBackButton)
end

function Module:SetupBackToMenuButton(scene)
	local backToMenuButtonHitbox = UIObjectHelperModule.CreateElement(
		SharedData.backToMenuButtonHitbox,
		scene
	)

	local backToMenuButton = UIButtonObjectModule.new({
		elements = {backToMenuButtonHitbox},
		hitboxElement = backToMenuButtonHitbox,

		mouseButton = 1,

		onClick = function()
			ScreenTransitionModule:Transition({
				callback = function()
					SavesFilesModule:UnloadFile(SavesFilesModule.loadedFile)
					BoxesObjectModule:ClearBoxes()

					UISceneHandlerModule:Switch("saveFiles")
				end
			})
		end
	})

	table.insert(scene._objects, backToMenuButton)
end

function Module:SetupCurrencyLabels(scene)
	local creditsLabel = UIObjectHelperModule.CreateElement(
		SharedData.creditsLabel,
		scene
	)

	self._updateFunctions.creditsLabelUpdateFunction = function()
		if not creditsLabel then return end
		if not SavesFilesModule.loadedFile then return end

		local credits = SavesFilesModule:Get("currencies.credits")
		creditsLabel.text = string.formatNumber(credits) .. " C$"
	end
end

function Module:SetupSessionPlaytimeLabel(scene)
	local sessionPlaytimeLabel = UIObjectHelperModule.CreateElement(
		SharedData.sessionPlaytimeLabel,
		scene
	)

	self._updateFunctions.sessionPlaytimeLabelUpdateFunction = function()
		if not sessionPlaytimeLabel then return end
		if not SavesFilesModule.loadedFile then return end

		sessionPlaytimeLabel.text = string.formatTime(
			SavesFilesModule:Get("tracking.playtime")
				- SavesFilesModule.playtimeAtSessionStart
		)
	end
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

function Module:Update()
	for _, updateFunction in pairs(self._updateFunctions) do
		updateFunction()
	end
end

function Module:Clean()
	self._updateFunctions = {}
end

return Module