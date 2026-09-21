-- ~/code/game/ui/scenes/settings.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")

local SavesFilesModule = require("code.engine.saves.files")
local SettingsModule = require("code.engine.saves.settings")

local CONSTANTS = require("code.data.constants")

local MusicHandlerModule = require("code.game.musicHandler")
local BoxesObjectModule = require("code.game.boxes.object")

local COMMON_VALUES = require("code.data.ui.commonValues")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")
local UIObjectHelperModule = require("code.game.ui.helpers.object")
local UILayoutHelperModule = require("code.game.ui.helpers.layout")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local SceneData = require("code.data.ui.scenes.settings")

local ENUM_SETTING_OPTIONS = {
	colorblindMode = CONSTANTS.SAVES.COLORBLIND_MODES
}

local Module = {}

Module._elements = {}
Module._objects = {}

Module.name = "settings"

local currentCategoryIndex = 1
local currentCategoryLabel = nil

local settingNameLabels = {}
local settingValueControls = {}
local categories = {}

-- Resets category/selection state shared by Clean and Init.
local function _resetSelectionState()
	currentCategoryIndex = 1
	currentCategoryLabel = nil

	settingNameLabels = {}
	settingValueControls = {}
end

function Module:Clean()
	UIObjectHelperModule.CleanScene(self)

	_resetSelectionState()
	categories = {}

	UISharedFunctions:Clean()

	BoxesObjectModule.renderBoxes = true
end

-- Copies a table and applies new values.
local function _copyWithOverrides(base, overrides)
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

-- Creates the background.
local function _setupBackground(self)
	UIObjectHelperModule.CreateElement(
		SceneData.background,
		self
	)
end

-- Creates a single-hitbox button and registers it for cleanup. Most
-- buttons in this scene are just "one hitbox, one click handler", so
-- this covers the cancel/toggle/stepper/scroll buttons below.
local function _setupHitboxButton(self, hitbox, onClick)
	return UIObjectHelperModule.CreateButton(
		self,
		{hitbox},
		hitbox,
		onClick
	)
end

-- Creates the cancel button.
local function _setupCancelButton(self)
	local cancelButtonHitbox = UIObjectHelperModule.CreateElement(
		SceneData.cancelButtonHitbox,
		self
	)

	_setupHitboxButton(self, cancelButtonHitbox, function()
		ScreenTransitionModule:Transition({
			callback = function()
				UISceneHandlerModule:Switch(
					UISceneHandlerModule.lastScene.name
				)
			end
		})
	end)
end

-- Capitalizes the first letter.
local function _capitalizeFirstLetter(text)
	return text:sub(1, 1):upper() .. text:sub(2)
end

-- Updates the current category label.
local function _updateCategoryLabel()
	if not currentCategoryLabel then
		return
	end

	currentCategoryLabel.text =
		_capitalizeFirstLetter(
			categories[currentCategoryIndex] or ""
		)
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

-- Removes all setting name labels.
local function _clearSettingNameLabels(self)
	_removeAndPrune(settingNameLabels, self._elements)
	settingNameLabels = {}
end

-- Removes all setting value controls.
local function _clearSettingValueControls(self)
	for index = #settingValueControls, 1, -1 do
		local control = settingValueControls[index]

		_removeAndPrune(control.elements, self._elements)
		_removeAndPrune(control.objects, self._objects)

		table.remove(settingValueControls, index)
	end

	settingValueControls = {}
end

-- Persists a setting change, saving and firing the changed signal.
-- Shared by every setting type below, since they all end the same way.
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

	return newValue
end

-- Toggles a boolean setting.
local function _toggleBooleanSetting(category, settingKey)
	local oldValue = SettingsModule.loadedFile[category][settingKey]

	return _commitSettingChange(category, settingKey, oldValue, not oldValue)
end

-- Creates a boolean setting control.
local function _setupBooleanSettingControl(self, category, setting, rowY)
	local currentValue = SettingsModule.loadedFile[category][setting.key]

	local togglePath = currentValue
		and COMMON_VALUES.BOOLEAN_TOGGLE_ON_BUTTON_PATH
		or COMMON_VALUES.BOOLEAN_TOGGLE_OFF_BUTTON_PATH

	local toggleHitbox = UIObjectHelperModule.CreateElement(
		_copyWithOverrides(SceneData.booleanSettingToggleHitbox, {
			y = rowY,
			type = "sprite",
			spritePath = togglePath
		}),
		self
	)

	local toggleButton = _setupHitboxButton(self, toggleHitbox, function()
		local value = _toggleBooleanSetting(category, setting.key)

		toggleHitbox:ChangeSprite(
			value
				and COMMON_VALUES.BOOLEAN_TOGGLE_ON_BUTTON_PATH
				or COMMON_VALUES.BOOLEAN_TOGGLE_OFF_BUTTON_PATH
		)
	end)

	table.insert(settingValueControls, {
		elements = {toggleHitbox},
		objects = {toggleButton}
	})
end

-- Clamps a number setting to its allowed range.
local function _clampNumberSetting(value, range)
	if not range then
		return value
	end

	if value < range.min then
		return range.min
	end

	if value > range.max then
		return range.max
	end

	return value
end

-- Changes a numeric setting.
local function _adjustNumericSetting(category, settingKey, direction)
	local range = CONSTANTS.SAVES.NUMBER_SETTING_RANGES[settingKey]
	local oldValue = SettingsModule.loadedFile[category][settingKey]

	local newValue = _clampNumberSetting(
		oldValue + direction * CONSTANTS.UI.SETTINGS.NUMBER_SETTING_CHANGE_INCREMENT,
		range
	)

	return _commitSettingChange(category, settingKey, oldValue, newValue)
end

-- Changes an enum setting.
local function _cycleEnumSetting(category, settingKey, direction)
	local options = ENUM_SETTING_OPTIONS[settingKey]

	if not options or #options == 0 then
		return
	end

	local oldValue = SettingsModule.loadedFile[category][settingKey]
	local currentIndex = 1

	for index, option in pairs(options) do
		if option == oldValue then
			currentIndex = index
			break
		end
	end

	local newIndex = ((currentIndex - 1 + direction) % #options) + 1
	local newValue = options[newIndex]

	return _commitSettingChange(category, settingKey, oldValue, newValue)
end

-- Formats a value as a percentage.
local function _formatPercent(value)
	return math.floor(value * 100 + .5) .. "%"
end

-- Creates the buttons and value label for a stepper setting.
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
	local decreaseHitbox = UIObjectHelperModule.CreateElement(
		_copyWithOverrides(
			SceneData.decreaseSettingHitbox,
			{
				y = rowY,
				spritePath = decreaseSprite
			}
		),
		self
	)

	local increaseHitbox = UIObjectHelperModule.CreateElement(
		_copyWithOverrides(
			SceneData.increaseSettingHitbox,
			{
				y = rowY,
				spritePath = increaseSprite
			}
		),
		self
	)

	local valueLabel = UIObjectHelperModule.CreateElement(
		_copyWithOverrides(
			SceneData.settingValueLabel,
			{
				y = rowY
			}
		),
		self
	)

	valueLabel.text = formatValue(
		SettingsModule.loadedFile[category][setting.key]
	)

	local function _step(direction)
		return function()
			valueLabel.text = formatValue(
				adjustValue(
					category,
					setting.key,
					direction
				)
			)
		end
	end

	local decreaseButton = _setupHitboxButton(self, decreaseHitbox, _step(-1))
	local increaseButton = _setupHitboxButton(self, increaseHitbox, _step(1))

	table.insert(settingValueControls, {
		elements = {
			decreaseHitbox,
			increaseHitbox,
			valueLabel
		},

		objects = {
			decreaseButton,
			increaseButton
		}
	})
end

-- Creates a numeric setting control.
local function _setupNumericSettingControl(self, category, setting, rowY)
	_setupStepperControl(
		self,
		category,
		setting,
		rowY,

		COMMON_VALUES.NUMBER_DECREASE_BUTTON_PATH,
		COMMON_VALUES.NUMBER_INCREASE_BUTTON_PATH,

		_adjustNumericSetting,
		_formatPercent
	)
end

-- Creates an enum setting control.
local function _setupEnumSettingControl(self, category, setting, rowY)
	_setupStepperControl(
		self,
		category,
		setting,
		rowY,

		COMMON_VALUES.ENUM_DECREASE_BUTTON_PATH,
		COMMON_VALUES.ENUM_INCREASE_BUTTON_PATH,

		_cycleEnumSetting,
		_capitalizeFirstLetter
	)
end

-- Creates the right control based on the setting type.
local function _setupSettingValueControl(self, category, setting, rowY)
	local valueType =
		type(SettingsModule.loadedFile[category][setting.key])

	if valueType == "boolean" then
		_setupBooleanSettingControl(
			self,
			category,
			setting,
			rowY
		)

	elseif valueType == "number" then
		_setupNumericSettingControl(
			self,
			category,
			setting,
			rowY
		)

	elseif valueType == "string" then
		_setupEnumSettingControl(
			self,
			category,
			setting,
			rowY
		)
	end
end

-- Rebuilds the setting labels and controls for the current category.
local function _setupSettingNameLabels(self)
	_clearSettingNameLabels(self)
	_clearSettingValueControls(self)

	local categorySchema = _getCurrentCategorySchema()

	if not categorySchema then
		return
	end

	for index, setting in pairs(categorySchema.settings) do
		local rowY = UILayoutHelperModule.GetVerticalStackY(
			SceneData.settingNameLabel.y or 0,
			index,
			COMMON_VALUES.BUTTON_HORIZONTAL_GAP - COMMON_VALUES.MEDIUM_PADDING
		)

		local label = UIObjectHelperModule.CreateElement(
			_copyWithOverrides(
				SceneData.settingNameLabel,
				{
					y = rowY
				}
			),
			self
		)

		label.text = setting.name

		table.insert(settingNameLabels, label)

		_setupSettingValueControl(
			self,
			categorySchema.key,
			setting,
			rowY
		)
	end
end

-- Changes the current category.
local function _scrollCategory(self, increment)
	if #categories == 0 then
		return
	end

	currentCategoryIndex =
		((currentCategoryIndex - 1 + increment) % #categories) + 1

	_updateCategoryLabel()
	_setupSettingNameLabels(self)
end

-- Creates the current category label.
local function _setupCurrentCategoryLabel(self)
	currentCategoryLabel =
		UIObjectHelperModule.CreateElement(
			SceneData.currentCategoryLabel,
			self
		)

	_updateCategoryLabel()
end

-- Creates the category scroll buttons.
local function _setupScrollButtons(self)
	local scrollRightButtonHitbox =
		UIObjectHelperModule.CreateElement(
			SceneData.scrollRightButtonHitbox,
			self
		)

	local scrollLeftButtonHitbox =
		UIObjectHelperModule.CreateElement(
			SceneData.scrollLeftButtonHitbox,
			self
		)

	_setupHitboxButton(self, scrollRightButtonHitbox, function()
		_scrollCategory(self, 1)
	end)

	_setupHitboxButton(self, scrollLeftButtonHitbox, function()
		_scrollCategory(self, -1)
	end)
end

-- Creates the category scrolling UI.
local function _setupCategoryScrolling(self)
	_setupCurrentCategoryLabel(self)
	_setupScrollButtons(self)
	_setupSettingNameLabels(self)
end

-- Builds the list of available categories.
local function _buildCategories()
	categories = {}

	for _, category in pairs(CONSTANTS.SAVES.SETTINGS_SCHEMA) do
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

	_resetSelectionState()
	_buildCategories()

	_setupBackground(self)
	_setupCategoryScrolling(self)
	_setupCancelButton(self)

	if SavesFilesModule.loadedFile then
		UISharedFunctions:SetupSessionPlaytimeLabel(self)
		UISharedFunctions:SetupCurrencyLabels(self)
	end
end

return Module