-- ~/code/game/ui/scenes/saveFiles.lua

local SavesFilesModule = require("code.engine.saves.files")

local MusicHandlerModule = require("code.game.musicHandler")

local BoxesObjectModule = require("code.game.boxes.object")

local CONSTANTS = require("code.data.constants")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")
local UIObjectHelperModule = require("code.game.ui.helpers.object")
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
    UIObjectHelperModule.CleanScene(self)

    self._resetButtons = {}
    self._boxes = {}

    UISharedFunctions:Clean()
end

local function _startGame(slot)
    UISceneHandlerModule:Switch("boxRanch", slot)
end

local function _setupSavePlaytime(self, backgroundElement, save)
    local playtime = (save.stats and save.tracking.playtime) or 0
    local templateSavePlaytime = UIObjectHelperModule.CreateElement(
        SceneData.templateSavePlaytime,
        self
    )

    templateSavePlaytime.text = string.formatTime(playtime)
    templateSavePlaytime.x = backgroundElement.x
end

local function _setupSaveHighestTier(self, backgroundElement, save)
    local highestTier = (save.stats and save.tracking.highestBoxTier) or 0

    local templateSaveHighestTier = UIObjectHelperModule.CreateElement(
        SceneData.templateSaveHighestTier,
        self
    )

    templateSaveHighestTier.text = "Highest Tier: " .. highestTier
    templateSaveHighestTier.x = backgroundElement.x
end

local function _setupSaveFileBoxPreview(self, backgroundElement, save)
    local highestTier = (save.stats and save.tracking.highestBoxTier) or 0
    local boxData = BoxesObjectModule.GetBoxDataByTier(highestTier)

    local boxElement = BoxesObjectModule.newElement(boxData)

    boxElement.x = backgroundElement.x
    boxElement.y = SceneData.templateSaveFileBoxPreview.y

    boxElement.scaleX = SceneData.templateSaveFileBoxPreview.scaleX
    boxElement.scaleY = SceneData.templateSaveFileBoxPreview.scaleY

    boxElement:SetZIndex(SceneData.templateSaveFileBoxPreview.zIndex)

    table.insert(self._elements, boxElement)
end

local function _setupSaveFileLoadButton(self, backgroundElement, slot)
    local saveFileLoadButtonHitbox = UIObjectHelperModule.CreateElement(
        SceneData.templateSaveFileLoadButtonHitbox,
        self
    )

    local saveFileLoadButtonLabel = UIObjectHelperModule.CreateElement(
        SceneData.templateSaveFileLoadButtonLabel,
        self
    )

    saveFileLoadButtonHitbox.x = backgroundElement.x
    saveFileLoadButtonLabel.x = backgroundElement.x

    UIObjectHelperModule.CreateButton(
        self,
        {
            saveFileLoadButtonHitbox,
            saveFileLoadButtonLabel
        },
        saveFileLoadButtonHitbox,
        function()
            ScreenTransitionModule:Transition({
                callback = function()
                    _startGame(slot)
                end
            })
        end
    )
end

local function _setupSaveFileResetButton(self, backgroundElement, slot)
    local saveFileResetButtonHitbox = UIObjectHelperModule.CreateElement(
        SceneData.templateSaveFileResetButtonHitbox,
        self
    )

    local saveFileResetButtonLabel = UIObjectHelperModule.CreateElement(
        SceneData.templateSaveFileResetButtonLabel,
        self
    )

    saveFileResetButtonHitbox.x = backgroundElement.x
    saveFileResetButtonLabel.x = backgroundElement.x

    local saveFileResetButton

    saveFileResetButton = UIObjectHelperModule.CreateButton(
        self,
        {
            saveFileResetButtonHitbox,
            saveFileResetButtonLabel
        },
        saveFileResetButtonHitbox,
        function()
            if saveFileResetButton.deleting then
                return
            end

            if (love.timer.getTime() - saveFileResetButton.lastConfirm)
                >= CONSTANTS.UI.SAVES.RESET_BUTTON_WARN_TIME_OUT
            then
                saveFileResetButtonLabel.text = "Are you sure?"
                saveFileResetButton.lastConfirm = love.timer.getTime()

                return
            end

            saveFileResetButton.deleting = true
            saveFileResetButtonLabel.text = "Bye bye!"

            ScreenTransitionModule:Transition({
                callback = function()
                    SavesFilesModule:DeleteFile(slot)
                    UISceneHandlerModule:Switch("saveFiles")
                end,

                duration = 1.2
            })
        end
    )

    saveFileResetButton.lastConfirm = -math.huge
    saveFileResetButton.deleting = false

    table.insert(self._resetButtons, saveFileResetButton)
end

local function _setupSaveFileButtons(self, backgroundElement, slot)
    _setupSaveFileResetButton(self, backgroundElement, slot)
    _setupSaveFileLoadButton(self, backgroundElement, slot)
end

local function _setupSaveFileBackgrounds(self)
    local saves = SavesFilesModule:GetFiles()
    local maxSlots = CONSTANTS.SAVES.MAX_SAVE_SLOTS

    local slotBackgrounds = {}

    for _ = 1, maxSlots do
        local templateSaveFileBackground = UIObjectHelperModule.CreateElement(
            SceneData.templateSaveFileBackground,
            self
        )

        table.insert(slotBackgrounds, templateSaveFileBackground)
    end

    local buttonWidth = slotBackgrounds[1].drawable:getWidth()
    local totalWidth = (maxSlots * buttonWidth) + (maxSlots - 1)
    local startX =
        (RESOLUTION_WIDTH - totalWidth) / 2 + (buttonWidth / 2)

    UILayoutHelperModule.StackHorizontally(
        slotBackgrounds,
        startX,
        buttonWidth + 1
    )

    for index = 1, maxSlots do
        local save = saves[index]
        local templateSaveFileBackground = slotBackgrounds[index]

        local templateSaveFileLabel = UIObjectHelperModule.CreateElement(
            SceneData.templateSaveFileLabel,
            self
        )

        templateSaveFileLabel.x = templateSaveFileBackground.x
        templateSaveFileLabel.text = "Slot " .. tostring(index)

        if save then
            _setupSaveFileButtons(
                self,
                templateSaveFileBackground,
                index
            )

            _setupSaveFileBoxPreview(
                self,
                templateSaveFileBackground,
                save
            )

            _setupSaveHighestTier(
                self,
                templateSaveFileBackground,
                save
            )

            _setupSavePlaytime(
                self,
                templateSaveFileBackground,
                save
            )
        else
            local templateSaveFilePlusIcon = UIObjectHelperModule.CreateElement(
                SceneData.templateSaveFilePlusIcon,
                self
            )

            templateSaveFilePlusIcon.x = templateSaveFileBackground.x

            UIObjectHelperModule.CreateButton(
                self,
                {
                    templateSaveFileBackground,
                    templateSaveFilePlusIcon
                },
                templateSaveFileBackground,
                function()
                    ScreenTransitionModule:Transition({
                        callback = function()
                            _startGame(index)
                        end,

                        duration = 1.2
                    })
                end
            )
        end
    end
end

local function _setupBackToMenuButton(self)
    local backToMenuButtonHitbox = UIObjectHelperModule.CreateElement(
        SceneData.backToMenuButtonHitbox,
        self
    )

    local backToMenuButtonLabel = UIObjectHelperModule.CreateElement(
        SceneData.backToMenuButtonLabel,
        self
    )

    UIObjectHelperModule.CreateButton(
        self,
        {
            backToMenuButtonHitbox,
            backToMenuButtonLabel
        },
        backToMenuButtonHitbox,
        function()
            ScreenTransitionModule:Transition({
                callback = function()
                    UISceneHandlerModule:Switch("mainMenu")
                end
            })
        end
    )
end

function Module:Update()
    for _, button in pairs(self._resetButtons) do
        if (love.timer.getTime() - button.lastConfirm)
            < CONSTANTS.UI.SAVES.RESET_BUTTON_WARN_TIME_OUT
        then
            goto continue
        end

        if button.deleting then
            goto continue
        end

        button.elements[1].text = SceneData.templateSaveFileResetButtonLabel.text
        button.elements[2].text = SceneData.templateSaveFileResetButtonLabel.text

        :: continue ::
    end
end

function Module:Init()
    UISharedFunctions:SetupHighestTierBoxes(self)
    UISharedFunctions:SetupSettingsButton(self)
    UISharedFunctions:SetupDiscordButton(self)

    UISharedFunctions:SetupBackground(self)

    MusicHandlerModule:PlayTrack("mainMenu")

    _setupSaveFileBackgrounds(self)
    _setupBackToMenuButton(self)
end

return Module