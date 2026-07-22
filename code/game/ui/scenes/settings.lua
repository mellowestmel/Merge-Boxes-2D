-- ~/code/game/ui/scenes/settings.lua

--/// ENGINE \\\--
local RenderModule = require("code.engine.render")

--// SAVES \\--
local SaveFilesModule = require("code.engine.saves.files")
local SettingsModule = require("code.engine.saves.settings")

local SAVES_CONSTANTS = require("code.engine.saves.constants")

--// HELPERS \\--
local table = require("code.engine.helpers.table")

--/// GAME \\\--
local MusicHandlerModule = require("code.game.musicHandler")

--// BOX \\--
local BoxesObjectModule = require("code.game.box.object")

--// UI \\--
local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")

local UI_CONSTANTS = require("code.game.ui.constants")

--/ UI OBJECTS \--
local UIButtonObjectModule = require("code.game.ui.objects.button")

--// VFX \\--
local ScreenTransitionModule = require("code.game.vfx.screenTransition")

--/// DATA \\\--
local SceneData = require("code.data.ui.scenes.settings")

local ENUM_SETTING_OPTIONS = {
    colorblindMode = SAVES_CONSTANTS.COLORBLIND_MODES
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

-- SceneData entries are shared, static tables (one per hitbox/label type),
-- so we never mutate them directly. Each control gets its own shallow
-- copy with just the fields that differ per-row (y position, sprite, etc).
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

-- "items" are the elements/objects to tear down; "list" is whichever
-- scene-level table (self._elements or self._objects) they were
-- registered in. Since ids/order in "list" aren't stable across
-- rebuilds, removal is by identity rather than index.
local function removeAndPrune(items, list)
    for _, item in pairs(items) do
        item:remove()

        for index, existing in pairs(list) do
            if existing == item then
                list[index] = nil
            end
        end
    end
end

-- Not using removeAndPrune here: it prunes "list" while iterating
-- "items", which is unsafe in Lua when they're the same table. Since
-- everything gets reset to {} right after anyway, pruning is pointless.
function Module:clean()
    for _, element in pairs(self._elements) do
        element:remove()
    end

    for _, object in pairs(self._objects) do
        object:remove()
    end

    self._elements = {}
    self._objects = {}
    settingNameLabels = {}
    settingValueControls = {}

    UISharedFunctions:cleanUpdates()
end

local function setupBackground(self)
    local background = RenderModule:createElement(SceneData.background)
    table.insert(self._elements, background)
end

local function setupCancelButton(self)
    local cancelButtonHitbox = RenderModule:createElement(SceneData.cancelButtonHitbox)
    table.insert(self._elements, cancelButtonHitbox)

    local cancelButton = UIButtonObjectModule:createButton({
        elements = { cancelButtonHitbox },
        hitboxElement = cancelButtonHitbox,

        mouseButton = 1,
        onClick = function()
            ScreenTransitionModule:transition({
                callback = function()
                    UISceneHandlerModule:switch(UISceneHandlerModule.lastScene.name)
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

-- SETTINGS_SCHEMA (in saves/constants.lua) is the single source of
-- truth for both category/setting order and display names, pairs()
-- over the save file itself would give no ordering guarantee at all.
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

--/// BOOLEAN SETTINGS \\\--

-- Forces an image into RenderModule.imageCache without leaving a live
-- element behind, so both toggle sprites are ready before any toggle
-- is clicked (avoids a load stutter on first use of the "other" state).
local function preloadSprite(spritePath)
    if RenderModule.imageCache[spritePath] then return end

    local temp = RenderModule:createElement({ type = "sprite", spritePath = spritePath })
    temp:remove()
end

local function booleanToggleImage(value)
    return RenderModule.imageCache[value and UI_CONSTANTS.BOOLEAN_TOGGLE_ON_BUTTON_PATH or UI_CONSTANTS.BOOLEAN_TOGGLE_OFF_BUTTON_PATH]
end

local function toggleBooleanSetting(category, settingKey)
    local newValue = not SettingsModule.loadedFile[category][settingKey]
    SettingsModule.loadedFile[category][settingKey] = newValue

    if SettingsModule.save then SettingsModule:save() end

    return newValue
end

local function setupBooleanSettingControl(self, category, setting, rowY)
    preloadSprite(UI_CONSTANTS.BOOLEAN_TOGGLE_OFF_BUTTON_PATH)
    preloadSprite(UI_CONSTANTS.BOOLEAN_TOGGLE_ON_BUTTON_PATH)

    local currentValue = SettingsModule.loadedFile[category][setting.key]
    local toggleData = copyWithOverrides(SceneData.booleanSettingToggleHitbox, {
        y = rowY,
        type = "sprite",
        spritePath = currentValue and UI_CONSTANTS.BOOLEAN_TOGGLE_ON_BUTTON_PATH or UI_CONSTANTS.BOOLEAN_TOGGLE_OFF_BUTTON_PATH
    })

    local toggleHitbox = RenderModule:createElement(toggleData)
    table.insert(self._elements, toggleHitbox)

    local toggleButton = UIButtonObjectModule:createButton({
        elements = { toggleHitbox },
        hitboxElement = toggleHitbox,

        mouseButton = 1,
        onClick = function()
            -- toggleBooleanSetting flips + saves the value and returns
            -- it; we swap .drawable directly rather than recreating the
            -- element, since only the sprite (not position/scale/etc)
            -- needs to change.
            toggleHitbox.drawable = booleanToggleImage(toggleBooleanSetting(category, setting.key))
        end
    })

    table.insert(self._objects, toggleButton)
    table.insert(settingValueControls, {
        elements = { toggleHitbox },
        objects = { toggleButton }
    })
end

--/// STEPPER SETTINGS (NUMBER + ENUM) \\\--
local function clampNumberSetting(value, range)
    if not range then return value end
    if value < range.min then return range.min end
    if value > range.max then return range.max end
    return value
end

local function adjustNumericSetting(category, settingKey, direction)
    local range = SAVES_CONSTANTS.NUMBER_SETTING_RANGES[settingKey]
    local currentValue = SettingsModule.loadedFile[category][settingKey]
    local newValue = clampNumberSetting(currentValue + direction * UI_CONSTANTS.NUMBER_SETTING_CHANGE_INCREMENT, range)

    SettingsModule.loadedFile[category][settingKey] = newValue
    if SettingsModule.save then SettingsModule:save() end

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

    -- wraps around in either direction without a separate < 1 / > #options
    -- branch: shifting to a 0-based index makes Lua's % behave like a
    -- true modulo (always non-negative), then we shift back to 1-based.
    local newIndex = ((currentIndex - 1 + direction) % #options) + 1
    local newValue = options[newIndex]

    SettingsModule.loadedFile[category][settingKey] = newValue
    if SettingsModule.save then SettingsModule:save() end

    return newValue
end

local function formatPercent(value)
    return math.floor(value * 100 + 0.5) .. "%"
end

-- Numeric and enum settings are visually and behaviorally identical
-- two step buttons plus a value label, so both go through this one
-- control. Only the sprites, the mutation, and the display format
-- differ, which is why those are parameters rather than duplicated code.
local function setupStepperControl(self, category, setting, rowY, decreaseSprite, increaseSprite, adjustValue, formatValue)
    local decreaseHitbox = RenderModule:createElement(
        copyWithOverrides(SceneData.decreaseSettingHitbox, { y = rowY, spritePath = decreaseSprite })
    )
    local increaseHitbox = RenderModule:createElement(
        copyWithOverrides(SceneData.increaseSettingHitbox, { y = rowY, spritePath = increaseSprite })
    )
    local valueLabel = RenderModule:createElement(
        copyWithOverrides(SceneData.settingValueLabel, { y = rowY })
    )

    table.insert(self._elements, decreaseHitbox)
    table.insert(self._elements, increaseHitbox)
    table.insert(self._elements, valueLabel)

    valueLabel.text = formatValue(SettingsModule.loadedFile[category][setting.key])

    -- step(-1)/step(1) bake the direction into each button's onClick,
    -- so both buttons share the same apply-then-redraw-label logic.
    local function step(direction)
        return function()
            valueLabel.text = formatValue(adjustValue(category, setting.key, direction))
        end
    end

    local decreaseButton = UIButtonObjectModule:createButton({
        elements = { decreaseHitbox }, hitboxElement = decreaseHitbox, mouseButton = 1, onClick = step(-1)
    })
    local increaseButton = UIButtonObjectModule:createButton({
        elements = { increaseHitbox }, hitboxElement = increaseHitbox, mouseButton = 1, onClick = step(1)
    })

    table.insert(self._objects, decreaseButton)
    table.insert(self._objects, increaseButton)
    table.insert(settingValueControls, {
        elements = { decreaseHitbox, increaseHitbox, valueLabel },
        objects = { decreaseButton, increaseButton }
    })
end

local function setupNumericSettingControl(self, category, setting, rowY)
    setupStepperControl(self, category, setting, rowY, UI_CONSTANTS.NUMBER_DECREASE_BUTTON_PATH, UI_CONSTANTS.NUMBER_INCREASE_BUTTON_PATH, adjustNumericSetting, formatPercent)
end

local function setupEnumSettingControl(self, category, setting, rowY)
    setupStepperControl(self, category, setting, rowY, UI_CONSTANTS.ENUM_DECREASE_BUTTON_PATH, UI_CONSTANTS.ENUM_INCREASE_BUTTON_PATH, cycleEnumSetting, capitalizeFirstLetter)
end

-- The control type is inferred from the setting's current Lua value
-- type rather than something declared in the schema, booleans get a
-- toggle, numbers get a percentage stepper, strings get an enum stepper.
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

--/// CATEGORY + SCENE SETUP \\\--

-- Rebuilds every name label + value control for the current category.
-- Called on init and again on every scroll, since switching category
-- means a different settings list (different count, different types).
local function setupSettingNameLabels(self)
    clearSettingNameLabels(self)
    clearSettingValueControls(self)

    local categorySchema = getCurrentCategorySchema()
    if not categorySchema then return end

    for index, setting in ipairs(categorySchema.settings) do
        -- stacks rows below the label's base y, in schema order
        local rowY = (SceneData.settingNameLabel.y or 0) + (index - 1) * UI_CONSTANTS.BUTTON_HORIZONTAL_GAP

        local label = RenderModule:createElement(
            copyWithOverrides(SceneData.settingNameLabel, { y = rowY })
        )
        label.text = setting.name

        table.insert(settingNameLabels, label)
        table.insert(self._elements, label)

        setupSettingValueControl(self, categorySchema.key, setting, rowY)
    end
end

-- same 0-based wraparound as cycleEnumSetting, applied to category scrolling
local function scrollCategory(self, increment)
    currentCategoryIndex = ((currentCategoryIndex - 1 + increment) % #categories) + 1

    updateCategoryLabel()
    setupSettingNameLabels(self)
end

local function setupCurrentCategoryLabel(self)
    currentCategoryLabel = RenderModule:createElement(SceneData.currentCategoryLabel)
    table.insert(self._elements, currentCategoryLabel)

    updateCategoryLabel()
end

local function setupScrollButtons(self)
    local scrollRightButtonHitbox = RenderModule:createElement(SceneData.scrollRightButtonHitbox)
    local scrollLeftButtonHitbox = RenderModule:createElement(SceneData.scrollLeftButtonHitbox)

    table.insert(self._elements, scrollRightButtonHitbox)
    table.insert(self._elements, scrollLeftButtonHitbox)

    local scrollRightButton = UIButtonObjectModule:createButton({
        elements = { scrollRightButtonHitbox },
        hitboxElement = scrollRightButtonHitbox,
        mouseButton = 1,
        onClick = function() scrollCategory(self, 1) end
    })

    local scrollLeftButton = UIButtonObjectModule:createButton({
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

function Module:update()
    UISharedFunctions:update()
end

function Module:init()
    MusicHandlerModule:playTrack("settings")

    BoxesObjectModule.renderBoxes = false

    if SaveFilesModule.loadedFile then
        UISharedFunctions:setupSessionPlaytimeLabel(self)
        UISharedFunctions:setupCurrencyLabels(self)
    end

    currentCategoryIndex = 1

    buildCategories()

    setupCategoryScrolling(self)
    setupCancelButton(self)
    setupBackground(self)
end

return Module