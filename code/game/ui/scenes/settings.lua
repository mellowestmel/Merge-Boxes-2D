-- ~/code/game/ui/scenes/settings.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")

local SavesFilesModule = require("code.engine.saves.files")
local SettingsModule = require("code.engine.saves.settings")

local CONSTANTS = require("code.data.constants")
local ColorblindData = require("code.data.colorblind")

local LocalizationHandlerModule = require("code.engine.localizationHandler")
local MusicHandlerModule = require("code.game.musicHandler")
local BoxesObjectModule = require("code.game.boxes.object")

local COMMON_VALUES = require("code.data.ui.commonValues")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")
local UIObjectHelperModule = require("code.game.ui.helpers.object")
local UILayoutHelperModule = require("code.game.ui.helpers.layout")
local UISceneBase = require("code.game.ui.helpers.scene")

local SceneData = require("code.data.ui.scenes.settings")

local Module = UISceneBase.new("settings")

local currentCategoryIndex = 1
local currentCategoryLabel = nil

-- Everything created for the current category's rows (labels, toggles, steppers).
-- Rebuilt whenever the category changes.
local rowElements = {}
local rowObjects = {}

local categories = {}

-- Resets category/selection state shared by Clean and Init.
local function _resetSelectionState()
    currentCategoryIndex = 1
    currentCategoryLabel = nil

    rowElements = {}
    rowObjects = {}
end

function Module:OnClean()
    _resetSelectionState()
    categories = {}

    BoxesObjectModule.renderBoxes = true
end

-- Removes objects and their references from a list.
local function _removeAndPrune(items, list)
    for itemIndex = #items, 1, -1 do
        local item = items[itemIndex]

        item:Remove()

        for listIndex = #list, 1, -1 do
            if list[listIndex] == item then
                table.remove(list, listIndex)
                break
            end
        end

        table.remove(items, itemIndex)
    end
end

-- Removes the current category's rows from the scene.
local function _clearRows(self)
    _removeAndPrune(rowElements, self._elements)
    _removeAndPrune(rowObjects, self._objects)
end

-- Gets all colorblind mode keys directly from the colorblind data.
local function _getColorblindModes()
    local modes = {}

    for key in pairs(ColorblindData) do
        table.insert(modes, key)
    end

    table.sort(modes)

    return modes
end

-- Enum settings: the options they cycle through and how a value is displayed.
-- Languages come from the loaded locale files and show their own name.
-- Colorblind modes come from the colorblind data and the locale files.
local ENUM_SETTINGS = {
    language = {
        getOptions = function()
            return LocalizationHandlerModule.GetLanguages()
        end,

        format = function(value)
            return LocalizationHandlerModule.GetLanguageName(value)
        end
    },

    colorblindMode = {
        getOptions = _getColorblindModes,

        format = function(value)
            return LocalizationHandlerModule.Get("settings.colorblindModes." .. value)
        end
    }
}

-- Updates the current category label.
local function _updateCategoryLabel()
    if not currentCategoryLabel then
        return
    end

    local categoryKey = categories[currentCategoryIndex]

    currentCategoryLabel.text = categoryKey
        and LocalizationHandlerModule.Get("settings.categories." .. categoryKey)
        or ""
end

-- Gets the schema for the current category.
local function _getCurrentCategorySchema()
    local currentCategory = categories[currentCategoryIndex]

    for _, category in pairs(CONSTANTS.SAVES.SETTINGS_SCHEMA) do
        if category.key == currentCategory then
            return category
        end
    end
end

-- Persists a setting change, saving and firing the changed signal.
local function _commitSettingChange(category, settingKey, oldValue, newValue)
    SettingsModule.loadedFile[category][settingKey] = newValue

    if SettingsModule.save then
        SettingsModule:Save()
    end

    SignalHandlerModule.Get("game.saves.settingchanged"):Fire(
        settingKey,
        newValue,
        oldValue
    )

    if settingKey == "language" then
        Module:Refresh()
    end

    return newValue
end

-- Toggles a boolean setting.
local function _toggleBooleanSetting(category, settingKey)
    local oldValue = SettingsModule.loadedFile[category][settingKey]

    return _commitSettingChange(category, settingKey, oldValue, not oldValue)
end

-- Changes a numeric setting, keeping it inside its allowed range.
local function _adjustNumericSetting(category, settingKey, direction)
    local range = CONSTANTS.SAVES.NUMBER_SETTING_RANGES[settingKey]
    local oldValue = SettingsModule.loadedFile[category][settingKey]

    local newValue = oldValue
        + direction * CONSTANTS.UI.SETTINGS.NUMBER_SETTING_CHANGE_INCREMENT

    if range then
        newValue = math.clamp(newValue, range.min, range.max)
    end

    return _commitSettingChange(category, settingKey, oldValue, newValue)
end

-- Changes an enum setting.
local function _cycleEnumSetting(category, settingKey, direction)
    local oldValue = SettingsModule.loadedFile[category][settingKey]
    local enum = ENUM_SETTINGS[settingKey]
    local options = enum and enum.getOptions()

    if not options or #options == 0 then
        return oldValue
    end

    local currentIndex = 1

    -- Use ipairs to preserve sequential array order
    for index, option in ipairs(options) do
        if option == oldValue then
            currentIndex = index
            break
        end
    end

    return _commitSettingChange(
        category,
        settingKey,
        oldValue,
        options[UILayoutHelperModule.WrapIndex(currentIndex, direction, #options)]
    )
end

-- Formats a value as a percentage.
local function _formatPercent(value)
    return math.floor(value * 100 + .5) .. "%"
end

local function _formatEnumValue(settingKey)
    local enum = ENUM_SETTINGS[settingKey]

    return enum and enum.format or tostring
end

local function _getTogglePath(value)
    return value
        and COMMON_VALUES.BOOLEAN_TOGGLE_ON_BUTTON_PATH
        or COMMON_VALUES.BOOLEAN_TOGGLE_OFF_BUTTON_PATH
end

-- Creates a boolean setting control.
local function _setupBooleanSettingControl(self, category, setting, rowY)
    local toggleButton, toggleHitbox

    toggleButton, toggleHitbox = UIObjectHelperModule.CreateElementButton(
        self,
        SceneData.booleanSettingToggleHitbox,
        nil,
        function()
            toggleHitbox:ChangeSprite(
                _getTogglePath(_toggleBooleanSetting(category, setting.key))
            )
        end,
        {
            y = rowY,
            type = "sprite",
            spritePath = _getTogglePath(SettingsModule.loadedFile[category][setting.key])
        }
    )

    table.insert(rowElements, toggleHitbox)
    table.insert(rowObjects, toggleButton)
end

-- Creates the buttons and value label for a stepper (numeric or enum) setting.
-- `adjustValue` changes the setting and returns the new value;
-- `formatValue` turns a value into the text shown between the buttons.
local function _setupStepperControl(
    self,
    category,
    setting,
    rowY,
    decreaseSprite,
    increaseSprite,
    adjustValue,
    formatValue
)
    local valueLabel

    local function _step(direction)
        return function()
            valueLabel.text = formatValue(
                adjustValue(category, setting.key, direction)
            )
        end
    end

    local decreaseButton, decreaseHitbox = UIObjectHelperModule.CreateElementButton(
        self,
        SceneData.decreaseSettingHitbox,
        nil,
        _step(-1),
        { y = rowY, spritePath = decreaseSprite }
    )

    local increaseButton, increaseHitbox = UIObjectHelperModule.CreateElementButton(
        self,
        SceneData.increaseSettingHitbox,
        nil,
        _step(1),
        { y = rowY, spritePath = increaseSprite }
    )

    valueLabel = UIObjectHelperModule.CreateElement(
        SceneData.settingValueLabel,
        self,
        { y = rowY }
    )

    valueLabel.text = formatValue(SettingsModule.loadedFile[category][setting.key])

    table.insert(rowElements, decreaseHitbox)
    table.insert(rowElements, increaseHitbox)
    table.insert(rowElements, valueLabel)

    table.insert(rowObjects, decreaseButton)
    table.insert(rowObjects, increaseButton)
end

-- Creates the right control based on the setting type.
local function _setupSettingValueControl(self, category, setting, rowY)
    local valueType = type(SettingsModule.loadedFile[category][setting.key])

    if valueType == "boolean" then
        _setupBooleanSettingControl(self, category, setting, rowY)

    elseif valueType == "number" then
        _setupStepperControl(
            self, category, setting, rowY,

            COMMON_VALUES.NUMBER_DECREASE_BUTTON_PATH,
            COMMON_VALUES.NUMBER_INCREASE_BUTTON_PATH,

            _adjustNumericSetting,
            _formatPercent
        )

    elseif valueType == "string" then
        _setupStepperControl(
            self, category, setting, rowY,

            COMMON_VALUES.ENUM_DECREASE_BUTTON_PATH,
            COMMON_VALUES.ENUM_INCREASE_BUTTON_PATH,

            _cycleEnumSetting,
            _formatEnumValue(setting.key)
        )
    end
end

-- Rebuilds the setting labels and controls for the current category.
local function _setupSettingRows(self)
    _clearRows(self)

    local categorySchema = _getCurrentCategorySchema()

    if not categorySchema then
        return
    end

    -- Use ipairs to preserve schema field order
    for index, setting in ipairs(categorySchema.fields) do
        local rowY = UILayoutHelperModule.GetVerticalStackY(
            SceneData.settingNameLabel.y or 0,
            index,
            COMMON_VALUES.BUTTON_HORIZONTAL_GAP - COMMON_VALUES.MEDIUM_PADDING
        )

        local label = UIObjectHelperModule.CreateElement(
            SceneData.settingNameLabel,
            self,
            { y = rowY }
        )

        label.text = LocalizationHandlerModule.Get("settings." .. setting.key)

        table.insert(rowElements, label)

        _setupSettingValueControl(self, categorySchema.key, setting, rowY)
    end
end

-- Changes the current category.
local function _scrollCategory(self, increment)
    if #categories == 0 then
        return
    end

    currentCategoryIndex = UILayoutHelperModule.WrapIndex(
        currentCategoryIndex,
        increment,
        #categories
    )

    _updateCategoryLabel()
    _setupSettingRows(self)
end

-- Creates the category label, its scroll buttons, and the first category's rows.
local function _setupCategoryScrolling(self)
    currentCategoryLabel = UIObjectHelperModule.CreateElement(
        SceneData.currentCategoryLabel,
        self
    )

    _updateCategoryLabel()

    UIObjectHelperModule.CreateElementButton(
        self,
        SceneData.scrollRightButtonHitbox,
        nil,
        function()
            _scrollCategory(self, 1)
        end
    )

    UIObjectHelperModule.CreateElementButton(
        self,
        SceneData.scrollLeftButtonHitbox,
        nil,
        function()
            _scrollCategory(self, -1)
        end
    )

    _setupSettingRows(self)
end

-- Builds the list of available categories.
local function _buildCategories()
    categories = {}

    for _, category in ipairs(CONSTANTS.SAVES.SETTINGS_SCHEMA) do
        if SettingsModule.loadedFile[category.key] then
            table.insert(categories, category.key)
        end
    end
end

local function _setupCancelButton(self)
    UIObjectHelperModule.CreateElementButton(
        self,
        SceneData.cancelButtonHitbox,
        nil,
        function()
            UISceneHandlerModule:TransitionTo(UISceneHandlerModule.lastScene.name)
        end
    )
end

-- Accepts an optional preserved category index to keep player position on refresh.
function Module:Init(preservedCategoryIndex)
    MusicHandlerModule:PlayTrack("settings")

    BoxesObjectModule.renderBoxes = false

    _resetSelectionState()

    if preservedCategoryIndex then
        currentCategoryIndex = preservedCategoryIndex
    end

    _buildCategories()

    UISharedFunctions:SetupBackground(self)
    _setupCategoryScrolling(self)
    _setupCancelButton(self)

    if SavesFilesModule.loadedFile then
        UISharedFunctions:SetupSessionPlaytimeLabel(self)
        UISharedFunctions:SetupCurrencyLabels(self)
    end
end

-- Refresh the scene after a language change, keeping the player on the category they were viewing.
function Module:Refresh()
    local categoryIndex = currentCategoryIndex

    self:Clean()
    self:Init(categoryIndex)
end

return Module