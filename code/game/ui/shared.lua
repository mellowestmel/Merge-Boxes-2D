-- ~/code/game/ui/shared.lua

local RenderModule = require("code.engine.render")

local SaveFilesModule = require("code.engine.saves.files")

local SAVES_CONSTANTS = require("code.engine.saves.constants")

local string = require("code.engine.helpers.string")
local table = require("code.engine.helpers.table")

local BoxesObjectModule = require("code.game.box.object")

local SHOP_CONSTANTS = require("code.game.shop.constants")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UIButtonObjectModule = require("code.game.ui.objects.button")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local UILayoutData = require("code.data.ui.layout")
local CONSTANTS = require("code.game.ui.constants")

local SharedData = require("code.data.ui.scenes.shared")

local Module = {}
Module._updateFunctions = {}

local function getHighestTierAcrossSaves()
    local highestTier = 0

    for slot = 1, SAVES_CONSTANTS.MAX_SAVE_SLOTS do
        local save = SaveFilesModule:readFile(slot)

        if save and save.stats then
            local tier = save.stats.highestBoxTier or 0

            if tier > highestTier then
                highestTier = tier
            end
        end
    end

    return highestTier
end

function Module:setupHighestTierBoxes(scene)
    local highestTier = getHighestTierAcrossSaves()

    if highestTier <= 0 then
        return
    end

    local boxes = UILayoutData.shared.backgroundBoxes
    for tier, data in ipairs(boxes) do
        if tier and tier <= highestTier then
            local element = RenderModule:createElement({
                spritePath = UILayoutData.shared.backgroundBoxesPathPrefix .. "box" .. tier .. ".png",

                anchorX = 0,
                anchorY = 0,

                x = data.x,
                y = data.y,

                zIndex = CONSTANTS.Z_WORLD + tier
            })

            table.insert(scene._elements, element)
        end
    end
end

function Module:setupSettingsButton(scene)
    if not scene then return end

    local settingsButtonHitbox = RenderModule:createElement(SharedData.settingsButtonHitbox)

    local settingsButton = UIButtonObjectModule:createButton({
        elements = {settingsButtonHitbox},
        hitboxElement = settingsButtonHitbox,

        mouseButton = 1,

        onClick = function()
            ScreenTransitionModule:transition({
                callback = function()
                    UISceneHandlerModule:switch("settings")
                end
            })
        end
    })

    table.insert(scene._elements, settingsButtonHitbox)
    table.insert(scene._objects, settingsButton)
end

function Module:setupDiscordButton(scene)
    local discordButtonHitbox = RenderModule:createElement(SharedData.discordButtonHitbox)
    table.insert(scene._elements, discordButtonHitbox)

    local discordButton = UIButtonObjectModule:createButton({
        elements = {
            discordButtonHitbox
        },
        hitboxElement = discordButtonHitbox,

        mouseButton = 1,

        onClick = function()
            love.system.openURL("https://www.discord.gg/pQShPG8XPf")
        end
    })

    table.insert(scene._objects, discordButton)
end

function Module:setupSidebarBackground(scene)
    local sidebarBackground = RenderModule:createElement(SharedData.sidebarBackground)
    table.insert(scene._elements, sidebarBackground)
end

function Module:setupShopBackButton(scene)
    local shopBackButtonHitbox = RenderModule:createElement(SharedData.shopBackButtonHitbox)
    local shopBackButtonLabel = RenderModule:createElement(SharedData.shopBackButtonLabel)

    local shopBackButton = UIButtonObjectModule:createButton({
        elements = {shopBackButtonHitbox, shopBackButtonLabel},
        hitboxElement = shopBackButtonHitbox,

        mouseButton = 1,

        onClick = function()
            ScreenTransitionModule:transition({
                callback = function()
                    UISceneHandlerModule:switch("game")
                end
            })
        end
    })

    table.insert(scene._elements, shopBackButtonHitbox)
    table.insert(scene._elements, shopBackButtonLabel)
    table.insert(scene._objects, shopBackButton)
end

function Module:setupBackToMenuButton(scene)
    local backToMenuButtonHitbox = RenderModule:createElement(SharedData.backToMenuButtonHitbox)
    table.insert(scene._elements, backToMenuButtonHitbox)

    local backToMenuButton = UIButtonObjectModule:createButton({
        elements = {
            backToMenuButtonHitbox,
        },

        hitboxElement = backToMenuButtonHitbox,

        mouseButton = 1,
        onClick = function()
            ScreenTransitionModule:transition({
                callback = function()
                    SaveFilesModule:unloadFile(SaveFilesModule.loadedFile)
                    BoxesObjectModule:clearBoxes()

                    UISceneHandlerModule:switch("saveFiles")
                end
            })
        end
    })

    table.insert(scene._objects, backToMenuButton)
end

function Module:setupCurrencyLabels(scene)
    local creditsLabel = RenderModule:createElement(SharedData.creditsLabel)

    self._updateFunctions.creditsLabelUpdateFunction = function()
        if not creditsLabel then return end

        local credits = SaveFilesModule.loadedFile.currencies.credits
        creditsLabel.text = string.formatNumber(credits) .. " C$"
    end

    table.insert(scene._elements, creditsLabel)

    local holyCatnipLabel = RenderModule:createElement(SharedData.holyCatnipLabel)

    self._updateFunctions.holyCatnipLabelUpdateFunction = function()
        if not holyCatnipLabel then return end

        local holyCatnip = SaveFilesModule.loadedFile.currencies.holyCatnip
        local highestBoxTier = SaveFilesModule.loadedFile.stats.highestBoxTier

        holyCatnipLabel.text = string.formatNumber(holyCatnip) .. " Holy Catnip"
        holyCatnipLabel.render = (highestBoxTier >= SHOP_CONSTANTS.SHOPS.CATNIP_SHOP.UNLOCK_REQUIREMENT)
    end

    table.insert(scene._elements, holyCatnipLabel)
end

function Module:setupSessionPlaytimeLabel(scene)
    local sessionPlaytimeLabel = RenderModule:createElement(SharedData.sessionPlaytimeLabel)

    self._updateFunctions.sessionPlaytimeLabelUpdateFunction = function()
        if not sessionPlaytimeLabel then return end

        sessionPlaytimeLabel.text =
        "Session Time: " .. string.formatTime(
            SaveFilesModule.loadedFile.stats.playtime
            -
            SaveFilesModule.loadedFile.stats.playtimeAtSessionStart
        )

    end

    table.insert(scene._elements, sessionPlaytimeLabel)
end

function Module:setupDialogueBox(scene)
    local dialogueBox = RenderModule:createElement(SharedData.dialogueBox)
    table.insert(scene._elements, dialogueBox)
end

function Module:update()
    for _, updateFunction in pairs(self._updateFunctions) do
        updateFunction()
    end
end

function Module:cleanUpdates()
    self._updateFunctions = {}
end

return Module