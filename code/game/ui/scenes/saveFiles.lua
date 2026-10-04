-- ~/code/game/ui/scenes/saveFiles.lua

local SavesFilesModule = require("code.engine.saves.files")

local LocalizationHandlerModule = require("code.engine.localizationHandler")
local MusicHandlerModule = require("code.game.musicHandler")

local BoxesObjectModule = require("code.game.boxes.object")

local CONSTANTS = require("code.data.constants")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")
local UIObjectHelperModule = require("code.game.ui.helpers.object")
local UILayoutHelperModule = require("code.game.ui.helpers.layout")
local UISceneBase = require("code.game.ui.helpers.scene")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local SceneData = require("code.data.ui.scenes.saveFiles")

local Module = UISceneBase.new("saveFiles")
Module._resetButtons = {}

local NEW_GAME_TRANSITION = { duration = 1.2 }

function Module:OnClean()
    self._resetButtons = {}
end

-- Creates a template element centered on a save slot's background.
local function _createSlotElement(self, elementData, backgroundElement)
    return UIObjectHelperModule.CreateElement(
        elementData,
        self,
        { x = backgroundElement.x }
    )
end

local function _setupSaveInfo(self, backgroundElement, save)
    local tracking = save.stats and save.tracking or {}

    _createSlotElement(
        self,
        SceneData.templateSaveHighestTier,
        backgroundElement
    ).text = LocalizationHandlerModule.Get(
        "saveFiles.highestTier",
        { tier = tracking.highestBoxTier or 0 }
    )

    _createSlotElement(
        self,
        SceneData.templateSavePlaytime,
        backgroundElement
    ).text = string.formatTime(tracking.playtime or 0)
end

local function _setupSaveFileBoxPreview(self, backgroundElement, save)
    local preview = SceneData.templateSaveFileBoxPreview
    local highestTier = (save.stats and save.tracking.highestBoxTier) or 0

    local boxElement = BoxesObjectModule.newElement(
        BoxesObjectModule.GetBoxDataByTier(highestTier)
    )

    boxElement.x = backgroundElement.x
    boxElement.y = preview.y

    boxElement.scaleX = preview.scaleX
    boxElement.scaleY = preview.scaleY

    boxElement:SetZIndex(preview.zIndex)

    table.insert(self._elements, boxElement)
end

local function _setupSaveFileLoadButton(self, backgroundElement, slot)
    UIObjectHelperModule.CreateElementButton(
        self,
        SceneData.templateSaveFileLoadButtonHitbox,
        SceneData.templateSaveFileLoadButtonLabel,
        function()
            UISceneHandlerModule:TransitionTo("boxRanch", nil, slot)
        end,
        { x = backgroundElement.x }
    )
end

local function _setupSaveFileResetButton(self, backgroundElement, slot)
    local resetButton, hitbox, label

    resetButton, hitbox, label = UIObjectHelperModule.CreateElementButton(
        self,
        SceneData.templateSaveFileResetButtonHitbox,
        SceneData.templateSaveFileResetButtonLabel,
        function()
            if resetButton.deleting then
                return
            end

            -- First click asks for confirmation, a second one in time deletes.
            if (love.timer.getTime() - resetButton.lastConfirm)
                >= CONSTANTS.UI.SAVES.RESET_BUTTON_WARN_TIME_OUT
            then
                label.text = LocalizationHandlerModule.Get("saveFiles.resetConfirm")
                resetButton.lastConfirm = love.timer.getTime()

                return
            end

            resetButton.deleting = true
            label.text = LocalizationHandlerModule.Get("saveFiles.resetDone")

            ScreenTransitionModule:Transition({
                callback = function()
                    SavesFilesModule:DeleteFile(slot)
                    UISceneHandlerModule:Switch("saveFiles")
                end,

                duration = 1.2
            })
        end,
        { x = backgroundElement.x }
    )

    resetButton.lastConfirm = -math.huge
    resetButton.deleting = false

    table.insert(self._resetButtons, resetButton)
end

local function _setupNewSaveButton(self, backgroundElement, slot)
    local plusIcon = _createSlotElement(
        self,
        SceneData.templateSaveFilePlusIcon,
        backgroundElement
    )

    UIObjectHelperModule.CreateButton(
        self,
        { backgroundElement, plusIcon },
        backgroundElement,
        function()
            UISceneHandlerModule:TransitionTo("boxRanch", NEW_GAME_TRANSITION, slot)
        end
    )
end

local function _setupSaveFileSlot(self, backgroundElement, slot, save)
    _createSlotElement(
        self,
        SceneData.templateSaveFileLabel,
        backgroundElement
    ).text = "Slot " .. tostring(slot)

    if not save then
        _setupNewSaveButton(self, backgroundElement, slot)
        return
    end

    _setupSaveFileResetButton(self, backgroundElement, slot)
    _setupSaveFileLoadButton(self, backgroundElement, slot)

    _setupSaveFileBoxPreview(self, backgroundElement, save)
    _setupSaveInfo(self, backgroundElement, save)
end

local function _setupSaveFiles(self)
    local saves = SavesFilesModule:GetFiles()
    local slotBackgrounds = {}

    for _ = 1, CONSTANTS.SAVES.MAX_SAVE_SLOTS do
        table.insert(
            slotBackgrounds,
            UIObjectHelperModule.CreateElement(
                SceneData.templateSaveFileBackground,
                self
            )
        )
    end

    UILayoutHelperModule:LayoutRow(slotBackgrounds, { spacing = 1 })

    for slot, backgroundElement in ipairs(slotBackgrounds) do
        _setupSaveFileSlot(self, backgroundElement, slot, saves[slot])
    end
end

local function _setupBackToMenuButton(self)
    UIObjectHelperModule.CreateElementButton(
        self,
        SceneData.backToMenuButtonHitbox,
        SceneData.backToMenuButtonLabel,
        function()
            UISceneHandlerModule:TransitionTo("mainMenu")
        end
    )
end

-- Puts the reset buttons back to their default text once the confirm window passes.
function Module:OnUpdate()
    for _, button in pairs(self._resetButtons) do
        local confirmExpired = (love.timer.getTime() - button.lastConfirm)
            >= CONSTANTS.UI.SAVES.RESET_BUTTON_WARN_TIME_OUT

        if confirmExpired and not button.deleting then
            local resetText = LocalizationHandlerModule.Get("saveFiles.resetFile")

            button.elements[1].text = resetText
            button.elements[2].text = resetText
        end
    end
end

function Module:Init()
    UISharedFunctions:SetupHighestTierBoxes(self)
    UISharedFunctions:SetupSettingsButton(self)
    UISharedFunctions:SetupDiscordButton(self)

    UISharedFunctions:SetupBackground(self)

    MusicHandlerModule:PlayTrack("mainMenu")

    _setupSaveFiles(self)
    _setupBackToMenuButton(self)
end

return Module