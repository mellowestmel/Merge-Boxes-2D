-- ~/code/game/ui/shared.lua

local RenderElementModule = require("code.engine.render.element")

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

function Module:SetupHighestTierBoxes(scene)
    local highestTier = getHighestTierAcrossSaves()

    if highestTier <= 0 then
        return
    end

    local boxes = UILayoutData.shared.backgroundBoxes
    for tier, data in ipairs(boxes) do
        if tier and tier <= highestTier then
            local element = RenderElementModule.new({
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

function Module:SetupSettingsButton(scene)
    if not scene then return end

    local settingsButtonHitbox = RenderElementModule.new(SharedData.settingsButtonHitbox)
    table.insert(scene._elements, settingsButtonHitbox)

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
    local discordButtonHitbox = RenderElementModule.new(SharedData.discordButtonHitbox)
    table.insert(scene._elements, discordButtonHitbox)

    local discordButton = UIButtonObjectModule.new({
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

    if scene._hideableElements then
        table.insert(scene._hideableElements, discordButtonHitbox)
    end
end

function Module:SetupSidebarBackground(scene)
    local sidebarBackground = RenderElementModule.new(SharedData.sidebarBackground)
    table.insert(scene._elements, sidebarBackground)
end

function Module:SetupShopBackButton(scene)
    local shopBackButtonHitbox = RenderElementModule.new(SharedData.shopBackButtonHitbox)
    local shopBackButtonLabel = RenderElementModule.new(SharedData.shopBackButtonLabel)

    local shopBackButton = UIButtonObjectModule.new({
        elements = {shopBackButtonHitbox, shopBackButtonLabel},
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

    table.insert(scene._elements, shopBackButtonHitbox)
    table.insert(scene._elements, shopBackButtonLabel)
    table.insert(scene._objects, shopBackButton)
end

function Module:SetupBackToMenuButton(scene)
    local backToMenuButtonHitbox = RenderElementModule.new(SharedData.backToMenuButtonHitbox)
    table.insert(scene._elements, backToMenuButtonHitbox)

    local backToMenuButton = UIButtonObjectModule.new({
        elements = {
            backToMenuButtonHitbox,
        },

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
    local creditsLabel = RenderElementModule.new(SharedData.creditsLabel)

    self._updateFunctions.creditsLabelUpdateFunction = function()
        if not creditsLabel then return end

        local credits = SaveFilesModule.loadedFile.currencies.credits
        creditsLabel.text = string.formatNumber(credits) .. " C$"
    end

    table.insert(scene._elements, creditsLabel)

    local holyCatnipLabel = RenderElementModule.new(SharedData.holyCatnipLabel)

    self._updateFunctions.holyCatnipLabelUpdateFunction = function()
        if not holyCatnipLabel then return end

        local holyCatnip = SaveFilesModule.loadedFile.currencies.holyCatnip
        local highestBoxTier = SaveFilesModule.loadedFile.stats.highestBoxTier

        holyCatnipLabel.text = string.formatNumber(holyCatnip) .. " Holy Catnip"
        holyCatnipLabel.render = (highestBoxTier >= SHOP_CONSTANTS.SHOPS.CATNIP_SHOP.UNLOCK_REQUIREMENT)
    end

    table.insert(scene._elements, holyCatnipLabel)
end

function Module:SetupSessionPlaytimeLabel(scene)
    local sessionPlaytimeLabel = RenderElementModule.new(SharedData.sessionPlaytimeLabel)

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

function Module:SetupDialogueBox(scene)
    local dialogueBox = RenderElementModule.new(SharedData.dialogueBox)
    table.insert(scene._elements, dialogueBox)
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