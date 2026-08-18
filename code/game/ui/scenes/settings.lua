-- ~/code/game/ui/scenes/settings.lua

local RenderElementModule = require("code.engine.render.element")

local SaveFilesModule = require("code.engine.saves.files")
local SettingsModule = require("code.engine.saves.settings")

local SAVES_CONSTANTS = require("code.engine.saves.constants")

local table = require("code.engine.helpers.table")

local MusicHandlerModule = require("code.game.musicHandler")

local BoxesObjectModule = require("code.game.box.object")

local CONSTANTS = require("code.game.ui.constants")
local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")

local UIButtonObjectModule = require("code.game.ui.objects.button")
local UILayoutHelperModule = require("code.game.ui.helpers.layout")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local SceneData = require("code.data.ui.scenes.settings")

local ENUM_SETTING_OPTIONS = {
    colorblindMode = SAVES_CONSTANTS.COLORBLIND_MODES,
    language = SAVES_CONSTANTS.COLORBLIND_MODES
}

local Module = {}
Module._elements = {}
Module._objects = {}

Module.name = "settings"

local currentCategoryIndex = 1
local currentCategoryLabel

local settingNameLabels = {}
local settingValueControls = {}
local categories = {}

-- Copies a table and applies new values.
local function copyWithOverrides(base, overrides)
    local result = {}

    for key, value in pairs(base) do
        result[key] = value
    end

    for key, value in pairs(overrides or {}) do
        result[key] = value
    end

    return result
end

-- Removes objects and their references from a list.
local function removeAndPrune(items, list)
    for _, item in pairs(items) do
        item:Remove()

        for index, existing in pairs(list) do
            if existing == item then
                list[index] = nil
            end
        end
    end
end

-- Removes all scene elements and objects.
function Module:Clean()
    for _, element in pairs(self._elements) do
        element:Remove()
    end

    for _, object in pairs(self._objects) do
        object:Remove()
    end

    self._elements = {}
    self._objects = {}
    settingNameLabels = {}
    settingValueControls = {}

    UISharedFunctions:CleanUpdates()
end

local function setupBackground(self)
    local background = RenderElementModule.new(SceneData.background)
    table.insert(self._elements, background)
end

local function setupCancelButton(self)
    local cancelButtonHitbox = RenderElementModule.new(SceneData.cancelButtonHitbox)
    table.insert(self._elements, cancelButtonHitbox)

    local cancelButton = UIButtonObjectModule.new({
        elements = { cancelButtonHitbox },
        hitboxElement = cancelButtonHitbox,

        mouseButton = 1,
        onClick = function()
            ScreenTransitionModule:Transition({
                callback = function()
                    UISceneHandlerModule:Switch(UISceneHandlerModule.lastScene.name)
                end
            })
        end
    })

    table.insert(self._objects, cancelButton)
end

local function capitalizeFirstLetter(text)
    return text:sub(1, 1):upper() .. text:sub(2)
end

local function updateCategoryLabel()
    if currentCategoryLabel then
        currentCategoryLabel.text = capitalizeFirstLetter(categories[currentCategoryIndex] or "")
    end
end

-- Gets the schema for the current category.
local function getCurrentCategorySchema()
    local currentCategory = categories[currentCategoryIndex]

    for _, category in ipairs(SAVES_CONSTANTS.SETTINGS_SCHEMA) do
        if category.key == currentCategory then
            return category
        end
    end
end

local function clearSettingNameLabels(self)
    removeAndPrune(settingNameLabels, self._elements)
    settingNameLabels = {}
end

local function clearSettingValueControls(self)
    for _, control in pairs(settingValueControls) do
        removeAndPrune(control.elements, self._elements)
        removeAndPrune(control.objects, self._objects)
    end

    settingValueControls = {}
end

-- Loads a sprite into the cache.
local function preloadSprite(spritePath)
    if RenderElementModule.imageCache[spritePath] then return end

    local temp = RenderElementModule.new({ type = "sprite", spritePath = spritePath })
    temp:Remove()
end

local function booleanToggleImage(value)
    return RenderElementModule.imageCache[value and CONSTANTS.BOOLEAN_TOGGLE_ON_BUTTON_PATH or CONSTANTS.BOOLEAN_TOGGLE_OFF_BUTTON_PATH]
end

local function toggleBooleanSetting(category, settingKey)
    local newValue = not SettingsModule.loadedFile[category][settingKey]
    SettingsModule.loadedFile[category][settingKey] = newValue

    if SettingsModule.save then SettingsModule:Save() end

    return newValue
end

local function setupBooleanSettingControl(self, category, setting, rowY)
    preloadSprite(CONSTANTS.BOOLEAN_TOGGLE_OFF_BUTTON_PATH)
    preloadSprite(CONSTANTS.BOOLEAN_TOGGLE_ON_BUTTON_PATH)

    local currentValue = SettingsModule.loadedFile[category][setting.key]
    local toggleData = copyWithOverrides(SceneData.booleanSettingToggleHitbox, {
        y = rowY,
        type = "sprite",
        spritePath = currentValue and CONSTANTS.BOOLEAN_TOGGLE_ON_BUTTON_PATH or CONSTANTS.BOOLEAN_TOGGLE_OFF_BUTTON_PATH
    })

    local toggleHitbox = RenderElementModule.new(toggleData)
    table.insert(self._elements, toggleHitbox)

    local toggleButton = UIButtonObjectModule.new({
        elements = { toggleHitbox },
        hitboxElement = toggleHitbox,

        mouseButton = 1,
        onClick = function()
            -- Toggle the value and update the sprite.
            toggleHitbox.drawable = booleanToggleImage(toggleBooleanSetting(category, setting.key))
        end
    })

    table.insert(self._objects, toggleButton)
    table.insert(settingValueControls, {
        elements = { toggleHitbox },
        objects = { toggleButton }
    })
end

-- NUMBER / ENUM SETTINGS
local function clampNumberSetting(value, range)
    if not range then return value end
    if value < range.min then return range.min end
    if value > range.max then return range.max end
    return value
end

local function adjustNumericSetting(category, settingKey, direction)
    local range = SAVES_CONSTANTS.NUMBER_SETTING_RANGES[settingKey]
    local currentValue = SettingsModule.loadedFile[category][settingKey]
    local newValue = clampNumberSetting(currentValue + direction * CONSTANTS.NUMBER_SETTING_CHANGE_INCREMENT, range)

    SettingsModule.loadedFile[category][settingKey] = newValue
    if SettingsModule.save then SettingsModule:Save() end

    return newValue
end

local function cycleEnumSetting(category, settingKey, direction)
    local options = ENUM_SETTING_OPTIONS[settingKey]
    local currentValue = SettingsModule.loadedFile[category][settingKey]

    local currentIndex = 1
    for index, option in ipairs(options) do
        if option == currentValue then
            currentIndex = index
            break
        end
    end

    -- Wraps around when reaching either end.
    local newIndex = ((currentIndex - 1 + direction) % #options) + 1
    local newValue = options[newIndex]

    SettingsModule.loadedFile[category][settingKey] = newValue
    if SettingsModule.save then SettingsModule:Save() end

    return newValue
end

local function formatPercent(value)
    return math.floor(value * 100 + 0.5) .. "%"
end

-- Creates the buttons and value label for a stepper setting.
local function setupStepperControl(self, category, setting, rowY, decreaseSprite, increaseSprite, adjustValue, formatValue)
    local decreaseHitbox = RenderElementModule.new(
        copyWithOverrides(SceneData.decreaseSettingHitbox, { y = rowY, spritePath = decreaseSprite })
    )
    local increaseHitbox = RenderElementModule.new(
        copyWithOverrides(SceneData.increaseSettingHitbox, { y = rowY, spritePath = increaseSprite })
    )
    local valueLabel = RenderElementModule.new(
        copyWithOverrides(SceneData.settingValueLabel, { y = rowY })
    )

    table.insert(self._elements, decreaseHitbox)
    table.insert(self._elements, increaseHitbox)
    table.insert(self._elements, valueLabel)

    valueLabel.text = formatValue(SettingsModule.loadedFile[category][setting.key])

    local function step(direction)
        return function()
            valueLabel.text = formatValue(adjustValue(category, setting.key, direction))
        end
    end

    local decreaseButton = UIButtonObjectModule.new({
        elements = { decreaseHitbox }, hitboxElement = decreaseHitbox, mouseButton = 1, onClick = step(-1)
    })
    local increaseButton = UIButtonObjectModule.new({
        elements = { increaseHitbox }, hitboxElement = increaseHitbox, mouseButton = 1, onClick = step(1)
    })

    table.insert(self._objects, decreaseButton)
    table.insert(self._objects, increaseButton)
    table.insert(settingValueControls, {
        elements = { decreaseHitbox, increaseHitbox, valueLabel },
        objects = { decreaseButton, increaseButton }
    })
end

-- Creates a numeric setting control.
local function setupNumericSettingControl(self, category, setting, rowY)
    setupStepperControl(
        self,

        category,
        setting,

        rowY,

        CONSTANTS.NUMBER_DECREASE_BUTTON_PATH,
        CONSTANTS.NUMBER_INCREASE_BUTTON_PATH,

        adjustNumericSetting,
        formatPercent
    )
end

-- Creates an enum setting control.
local function setupEnumSettingControl(self, category, setting, rowY)
    setupStepperControl(
        self,

        category,
        setting,

        rowY,

        CONSTANTS.ENUM_DECREASE_BUTTON_PATH,
        CONSTANTS.ENUM_INCREASE_BUTTON_PATH,

        cycleEnumSetting,
        capitalizeFirstLetter
    )
end

-- Creates the right control based on the setting type.
local function setupSettingValueControl(self, category, setting, rowY)
    local valueType = type(SettingsModule.loadedFile[category][setting.key])

    if valueType == "boolean" then
        setupBooleanSettingControl(self, category, setting, rowY)
    elseif valueType == "number" then
        setupNumericSettingControl(self, category, setting, rowY)
    elseif valueType == "string" then
        setupEnumSettingControl(self, category, setting, rowY)
    end
end

-- Rebuilds the setting labels and controls for the current category.
local function setupSettingNameLabels(self)
    clearSettingNameLabels(self)
    clearSettingValueControls(self)

    local categorySchema = getCurrentCategorySchema()
    if not categorySchema then return end

    for index, setting in ipairs(categorySchema.settings) do
        local rowY = UILayoutHelperModule.GetVerticalStackY(
            SceneData.settingNameLabel.y or 0,
            index,
            CONSTANTS.BUTTON_HORIZONTAL_GAP
        )

        local label = RenderElementModule.new(
            copyWithOverrides(SceneData.settingNameLabel, { y = rowY })
        )
        label.text = setting.name

        table.insert(settingNameLabels, label)
        table.insert(self._elements, label)

        setupSettingValueControl(self, categorySchema.key, setting, rowY)
    end
end

-- Changes the current category.
local function scrollCategory(self, increment)
    currentCategoryIndex = ((currentCategoryIndex - 1 + increment) % #categories) + 1

    updateCategoryLabel()
    setupSettingNameLabels(self)
end

local function setupCurrentCategoryLabel(self)
    currentCategoryLabel = RenderElementModule.new(SceneData.currentCategoryLabel)
    table.insert(self._elements, currentCategoryLabel)

    updateCategoryLabel()
end

local function setupScrollButtons(self)
    local scrollRightButtonHitbox = RenderElementModule.new(SceneData.scrollRightButtonHitbox)
    local scrollLeftButtonHitbox = RenderElementModule.new(SceneData.scrollLeftButtonHitbox)

    table.insert(self._elements, scrollRightButtonHitbox)
    table.insert(self._elements, scrollLeftButtonHitbox)

    local scrollRightButton = UIButtonObjectModule.new({
        elements = { scrollRightButtonHitbox },
        hitboxElement = scrollRightButtonHitbox,
        mouseButton = 1,
        onClick = function() scrollCategory(self, 1) end
    })

    local scrollLeftButton = UIButtonObjectModule.new({
        elements = { scrollLeftButtonHitbox },
        hitboxElement = scrollLeftButtonHitbox,
        mouseButton = 1,
        onClick = function() scrollCategory(self, -1) end
    })

    table.insert(self._objects, scrollRightButton)
    table.insert(self._objects, scrollLeftButton)
end

local function setupCategoryScrolling(self)
    setupCurrentCategoryLabel(self)
    setupScrollButtons(self)
    setupSettingNameLabels(self)
end

local function buildCategories()
    categories = {}

    for _, category in ipairs(SAVES_CONSTANTS.SETTINGS_SCHEMA) do
        if SettingsModule.loadedFile[category.key] then
            table.insert(categories, category.key)
        end
    end
end

function Module:Update()
    UISharedFunctions:Update()
end

function Module:Init()
    MusicHandlerModule:PlayTrack("settings")

    BoxesObjectModule.renderBoxes = false

    if SaveFilesModule.loadedFile then
        UISharedFunctions:SetupSessionPlaytimeLabel(self)
        UISharedFunctions:SetupCurrencyLabels(self)
    end

    currentCategoryIndex = 1

    buildCategories()

    setupCategoryScrolling(self)
    setupCancelButton(self)
    setupBackground(self)
end

return Module