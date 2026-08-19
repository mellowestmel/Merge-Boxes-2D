-- ~/code/game/ui/scenes/saveFiles.lua

local RenderElementModule = require("code.engine.render.element")

local SAVES_CONSTANTS = require("code.engine.saves.constants")
local SaveFilesModule = require("code.engine.saves.files")

local string = require("code.engine.helpers.string")
local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

local MusicHandlerModule = require("code.game.musicHandler")

local BoxesObjectModule = require("code.game.box.object")

local CONSTANTS = require("code.game.ui.constants")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")

local UIButtonObjectModule = require("code.game.ui.objects.button")
local UILayoutHelperModule = require("code.game.ui.helpers.layout")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local SceneData = require("code.data.ui.scenes.saveFiles")

local Module = {}
Module._resetButtons = {}
Module._elements = {}
Module._objects = {}
Module._boxes = {}

Module.name = "saveFiles"

function Module:Clean()
    for _, element in pairs(self._elements) do
        element:Remove()
    end

    for _, button in pairs(self._objects) do
        button:Remove()
    end

    self._elements = {}
    self._objects = {}
    self._resetButtons = {}
    self._boxes = {}

    UISharedFunctions:CleanUpdates()
end

local function startGame(slot)
    UISceneHandlerModule:Switch("game", slot)
end

local function setupBackground(self)
    local background = RenderElementModule.new(SceneData.background)
    table.insert(self._elements, background)
end

local function setupSavePlaytime(self, backgroundElement, save)
    local templateSavePlaytime = RenderElementModule.new(SceneData.templateSavePlaytime)
    templateSavePlaytime.text = string.formatTime((save.stats and save.stats.playtime) or 0)
    templateSavePlaytime.x = backgroundElement.x

    table.insert(self._elements, templateSavePlaytime)
end

local function setupSaveHighestTier(self, backgroundElement, save)
    local highestTier = (save.stats and save.stats.highestBoxTier) or 0

    local templateSaveHighestTier = RenderElementModule.new(SceneData.templateSaveHighestTier)
    templateSaveHighestTier.text = "Highest Tier: " .. highestTier
    templateSaveHighestTier.x = backgroundElement.x

    table.insert(self._elements, templateSaveHighestTier)
end

local function setupSaveFileBoxPreview(self, backgroundElement, save)
    local highestTier = (save.stats and save.stats.highestBoxTier) or 0
    if highestTier <= 0 then return end

    local data = BoxesObjectModule:GetBoxDataByTier(highestTier)
    local templateSaveFileBoxPreview = BoxesObjectModule.new(data)

    if templateSaveFileBoxPreview then
        templateSaveFileBoxPreview.x = backgroundElement.x
        templateSaveFileBoxPreview.y = SceneData.templateSaveFileBoxPreview.y

        templateSaveFileBoxPreview.scaleX =
            SceneData.templateSaveFileBoxPreview.scaleX
        templateSaveFileBoxPreview.scaleY =
            SceneData.templateSaveFileBoxPreview.scaleY

        templateSaveFileBoxPreview.zIndex = SceneData.templateSaveFileBoxPreview.zIndex
        templateSaveFileBoxPreview.boxData = data

        table.insert(self._elements, templateSaveFileBoxPreview)
        table.insert(self._boxes, templateSaveFileBoxPreview)
    end
end

local function setupSaveFileLoadButton(self, backgroundElement, slot)
    local saveFileLoadButtonHitbox = RenderElementModule.new(SceneData.templateSaveFileLoadButtonHitbox)
    local saveFileLoadButtonLabel = RenderElementModule.new(SceneData.templateSaveFileLoadButtonLabel)

    table.insert(self._elements, saveFileLoadButtonHitbox)
    table.insert(self._elements, saveFileLoadButtonLabel)

    saveFileLoadButtonHitbox.x = backgroundElement.x
    saveFileLoadButtonLabel.x = backgroundElement.x

    local saveFileLoadButton = UIButtonObjectModule.new({
        elements = {
            saveFileLoadButtonHitbox,
            saveFileLoadButtonLabel
        },

        hitboxElement = saveFileLoadButtonHitbox,
        mouseButton = 1,

        onClick = function()
            ScreenTransitionModule:Transition({
                callback = function()
                    startGame(slot)
                end
            })
        end
    })

    table.insert(self._objects, saveFileLoadButton)
end

local function setupSaveFileResetButton(self, backgroundElement, slot)
    local saveFileResetButtonHitbox = RenderElementModule.new(SceneData.templateSaveFileResetButtonHitbox)
    local saveFileResetButtonLabel = RenderElementModule.new(SceneData.templateSaveFileResetButtonLabel)

    table.insert(self._elements, saveFileResetButtonHitbox)
    table.insert(self._elements, saveFileResetButtonLabel)

    saveFileResetButtonHitbox.x = backgroundElement.x
    saveFileResetButtonLabel.x = backgroundElement.x

    local saveFileResetButton
    saveFileResetButton = UIButtonObjectModule.new({
        elements = {
            saveFileResetButtonHitbox,
            saveFileResetButtonLabel
        },
        hitboxElement = saveFileResetButtonHitbox,
        cooldown = 0,
        mouseButton = 1,
        onClick = function()
            if not saveFileResetButton then return end
            if saveFileResetButton.deleting then return end

            if (love.timer.getTime() - saveFileResetButton.lastConfirm) >= CONSTANTS.RESET_BUTTON_WARN_TIME_OUT then
                saveFileResetButtonLabel.text = "Are you sure?"
                saveFileResetButton.lastConfirm = love.timer.getTime()
                return
            else
                saveFileResetButton.deleting = true
                saveFileResetButtonLabel.text = "Bye bye!"

                ScreenTransitionModule:Transition({
                    callback = function()
                        SaveFilesModule:DeleteFile(slot)
                        UISceneHandlerModule:Switch("saveFiles")
                    end,

                    duration = 1.2
                })
            end
        end
    })

    saveFileResetButton.lastConfirm = -math.huge
    saveFileResetButton.deleting = false

    table.insert(self._resetButtons, saveFileResetButton)
    table.insert(self._objects, saveFileResetButton)
end

local function setupSaveFileButtons(self, backgroundElement, slot)
    setupSaveFileResetButton(self, backgroundElement, slot)
    setupSaveFileLoadButton(self, backgroundElement, slot)
end

local function setupSaveFileBackgrounds(self)
    local saves = SaveFilesModule:GetFiles()
    local maxSlots = SAVES_CONSTANTS.MAX_SAVE_SLOTS

    local slotBackgrounds = {}
    for _ = 1, maxSlots do
        local templateSaveFileBackground = RenderElementModule.new(SceneData.templateSaveFileBackground)
        table.insert(self._elements, templateSaveFileBackground)
        table.insert(slotBackgrounds, templateSaveFileBackground)
    end

    local buttonWidth = slotBackgrounds[1].drawable:getWidth()
    local totalWidth = (maxSlots * buttonWidth) + (maxSlots - 1)
    local startX = (RESOLUTION_WIDTH - totalWidth) / 2 + (buttonWidth / 2)

    UILayoutHelperModule.StackHorizontally(slotBackgrounds, startX, buttonWidth + 1)

    for index = 1, maxSlots do
        local save = saves[index]
        local templateSaveFileBackground = slotBackgrounds[index]

        local templateSaveFileLabel = RenderElementModule.new(SceneData.templateSaveFileLabel)

        templateSaveFileLabel.x = templateSaveFileBackground.x
        templateSaveFileLabel.text = "Slot " .. tostring(index)

        table.insert(self._elements, templateSaveFileLabel)

        local fileExists = SaveFilesModule:ReadFile(index) ~= nil

        if fileExists then
            setupSaveFileButtons(self, templateSaveFileBackground, index)
            setupSaveFileBoxPreview(self, templateSaveFileBackground, save)
            setupSaveHighestTier(self, templateSaveFileBackground, save)
            setupSavePlaytime(self, templateSaveFileBackground, save)
        else
            local templateSaveFilePlusIcon = RenderElementModule.new(SceneData.templateSaveFilePlusIcon)
            templateSaveFilePlusIcon.x = templateSaveFileBackground.x
            table.insert(self._elements, templateSaveFilePlusIcon)

            local createSaveFileButton = UIButtonObjectModule.new({
                elements = {
                    templateSaveFileBackground,
                    templateSaveFilePlusIcon
                },

                hitboxElement = templateSaveFileBackground,
                mouseButton = 1,

                onClick = function()
                    ScreenTransitionModule:Transition({
                        callback = function()
                            startGame(index)
                        end,

                        duration = 1.2
                    })
                end
            })

            table.insert(self._objects, createSaveFileButton)
        end
    end
end

local function setupBackToMenuButton(self)
    local backToMenuButtonHitbox = RenderElementModule.new(SceneData.backToMenuButtonHitbox)
    local backToMenuButtonLabel = RenderElementModule.new(SceneData.backToMenuButtonLabel)

    table.insert(self._elements, backToMenuButtonHitbox)
    table.insert(self._elements, backToMenuButtonLabel)

    local backToMenuButton = UIButtonObjectModule.new({
        elements = {
            backToMenuButtonHitbox,
            backToMenuButtonLabel
        },

        hitboxElement = backToMenuButtonHitbox,
        mouseButton = 1,

        onClick = function()
            ScreenTransitionModule:Transition({
                callback = function()
                    UISceneHandlerModule:Switch("mainMenu")
                end
            })
        end
    })

    table.insert(self._objects, backToMenuButton)
end

function Module:Update(deltaTime)
    for _, box in pairs(self._boxes) do
        if not box.boxData then goto continue end
        if not box.boxData.onUpdateCosmetic then goto continue end

        box.boxData.onUpdateCosmetic(box, deltaTime)

        :: continue ::
    end

    for _, button in pairs(self._resetButtons) do
        if (love.timer.getTime() - button.lastConfirm) < CONSTANTS.RESET_BUTTON_WARN_TIME_OUT then goto continue end
        if button.deleting then goto continue end

        button.elements[1].text = SceneData.templateSaveFileResetButtonLabel.text
        button.elements[2].text = SceneData.templateSaveFileResetButtonLabel.text

        :: continue ::
    end
end

function Module:Init()
    UISharedFunctions:SetupHighestTierBoxes(self)
    UISharedFunctions:SetupSettingsButton(self)
    UISharedFunctions:SetupDiscordButton(self)

    MusicHandlerModule:PlayTrack("mainMenu")

    setupSaveFileBackgrounds(self)
    setupBackToMenuButton(self)
    setupBackground(self)
end

return Module