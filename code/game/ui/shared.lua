-- ~/code/game/ui/shared.lua

local RenderElementModule = require("code.engine.render.element")

local SaveFilesModule = require("code.engine.saves.files")

local SAVES_CONSTANTS = require("code.engine.saves.constants")

local string = require("code.engine.helpers.string")
local table = require("code.engine.helpers.table")

local BoxesObjectModule = require("code.game.boxes.object")

local SHOP_CONSTANTS = require("code.game.shop.constants")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UIButtonObjectModule = require("code.game.ui.objects.button")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local UILayoutData = require("code.data.ui.layout")
local CONSTANTS = require("code.game.ui.constants")

local SharedData = require("code.data.ui.scenes.shared")
local BoxesData = require("code.data.boxes")

local Module = {}
Module._updateFunctions = {}

local function _getHighestTierAcrossSaves()
	local highestTier = 0

	for slot = 1, SAVES_CONSTANTS.MAX_SAVE_SLOTS do
		local save = SaveFilesModule:ReadFile(slot)

		if save and save.stats then
			local tier = save.stats.highestBoxTier or 0

			if tier > highestTier then
				highestTier = tier
			end
		end
	end

	return highestTier
end

function Module:CreateElement(elementData, scene)
	if not elementData then return end
	if not scene then return end

	local data = {}

	for key, value in pairs(elementData) do
		data[key] = value
	end

	local element = RenderElementModule.new(data)

	table.insert(scene._elements, element)

	return element
end

function Module:SetupHighestTierBoxes(scene)
    local highestTier = _getHighestTierAcrossSaves()
    if highestTier <= 0 then return end

    for type, data in pairs(UILayoutData.shared.backgroundBoxes) do
        local box = BoxesData[type]

        if not box then goto continue end
        if not box.tier then goto continue end
        if box.tier > highestTier then goto continue end

        local boxElement = RenderElementModule.new({
            name = "backgroundBox" .. type,

            spritePath = UILayoutData.shared.backgroundBoxesPathPrefix
                .. "box"
                .. box.tier
                .. ".png",

            anchorX = 0,
            anchorY = 0,

            x = data.x,
            y = data.y,

            zIndex = CONSTANTS.Z_WORLD + box.tier
        })

        table.insert(scene._elements, boxElement)

        ::continue::
    end
end

function Module:SetupSettingsButton(scene)
	if not scene then return end

	local settingsButtonHitbox = self:CreateElement(
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

	local discordButtonHitbox = self:CreateElement(
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
	self:CreateElement(
		SharedData.sidebarBackground,
		scene
	)
end

function Module:SetupShopBackButton(scene)
	local shopBackButtonHitbox = self:CreateElement(
		SharedData.shopBackButtonHitbox,
		scene
	)

	local shopBackButtonLabel = self:CreateElement(
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
					UISceneHandlerModule:Switch("game")
				end
			})
		end
	})

	table.insert(scene._objects, shopBackButton)
end

function Module:SetupBackToMenuButton(scene)
	local backToMenuButtonHitbox = self:CreateElement(
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
					SaveFilesModule:UnloadFile(SaveFilesModule.loadedFile)
					BoxesObjectModule:ClearBoxes()

					UISceneHandlerModule:Switch("saveFiles")
				end
			})
		end
	})

	table.insert(scene._objects, backToMenuButton)
end

function Module:SetupCurrencyLabels(scene)
	local creditsLabel = self:CreateElement(
		SharedData.creditsLabel,
		scene
	)

	self._updateFunctions.creditsLabelUpdateFunction = function()
		if not creditsLabel then return end
		if not SaveFilesModule.loadedFile then return end

		local credits = SaveFilesModule.loadedFile.currencies.credits
		creditsLabel.text = string.formatNumber(credits) .. " C$"
	end
end

function Module:SetupSessionPlaytimeLabel(scene)
	local sessionPlaytimeLabel = self:CreateElement(
		SharedData.sessionPlaytimeLabel,
		scene
	)

	self._updateFunctions.sessionPlaytimeLabelUpdateFunction = function()
		if not sessionPlaytimeLabel then return end
		if not SaveFilesModule.loadedFile then return end

		sessionPlaytimeLabel.text = string.formatTime(
				SaveFilesModule.loadedFile.stats.playtime
				- SaveFilesModule.loadedFile.stats.playtimeAtSessionStart
			)
	end
end

function Module:SetupBackground(scene)
	local sceneData = require(
		"code.data.ui.scenes." .. scene.name
	)

	self:CreateElement(
		sceneData.background,
		scene
	)
end

function Module:Update()
	for _, updateFunction in pairs(self._updateFunctions) do
		updateFunction()
	end
end

function Module:CleanUpdates()
	self._updateFunctions = {}
end

return Module