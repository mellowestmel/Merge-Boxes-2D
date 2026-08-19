-- ~/code/game/ui/scenes/settings.lua

local RenderElementModule = require("code.engine.render.element")

local SignalHandlerModule = require("code.engine.events.signalHandler")

local SaveFilesModule = require("code.engine.saves.files")
local SettingsModule = require("code.engine.saves.settings")

local SAVES_CONSTANTS = require("code.engine.saves.constants")

local table = require("code.engine.helpers.table")

local MusicHandlerModule = require("code.game.musicHandler")
local BoxesObjectModule = require("code.game.boxes.object")

local CONSTANTS = require("code.game.ui.constants")
local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")

local UIButtonObjectModule = require("code.game.ui.objects.button")
local UILayoutHelperModule = require("code.game.ui.helpers.layout")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local SceneData = require("code.data.ui.scenes.settings")

local ENUM_SETTING_OPTIONS = {
	colorblindMode = SAVES_CONSTANTS.COLORBLIND_MODES,
	language = SAVES_CONSTANTS.LANGUAGES
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

function Module:Clean()
	for _, element in pairs(self._elements) do
		if element then
			element:Remove()
		end
	end

	for _, object in pairs(self._objects) do
		if object then
			object:Remove()
		end
	end

	self._elements = {}
	self._objects = {}

	currentCategoryIndex = 1
	currentCategoryLabel = nil

	settingNameLabels = {}
	settingValueControls = {}
	categories = {}

	UISharedFunctions:CleanUpdates()

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

		if item then
			item:Remove()

			for listIndex = #list, 1, -1 do
				if list[listIndex] == item then
					table.remove(list, listIndex)
					break
				end
			end
		end

		table.remove(items, itemIndex)
	end
end

-- Creates the background.
local function _setupBackground(self)
	UISharedFunctions:CreateElement(
		SceneData.background,
		self
	)
end

-- Creates the cancel button.
local function _setupCancelButton(self)
	local cancelButtonHitbox = UISharedFunctions:CreateElement(
		SceneData.cancelButtonHitbox,
		self
	)

	local cancelButton = UIButtonObjectModule.new({
		elements = {cancelButtonHitbox},
		hitboxElement = cancelButtonHitbox,

		mouseButton = 1,

		onClick = function()
			ScreenTransitionModule:Transition({
				callback = function()
					UISceneHandlerModule:Switch(
						UISceneHandlerModule.lastScene.name
					)
				end
			})
		end
	})

	table.insert(self._objects, cancelButton)
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

	for _, category in pairs(SAVES_CONSTANTS.SETTINGS_SCHEMA) do
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

		if control then
			_removeAndPrune(control.elements or {}, self._elements)
			_removeAndPrune(control.objects or {}, self._objects)
		end

		table.remove(settingValueControls, index)
	end

	settingValueControls = {}
end

-- Loads a sprite into the cache.
local function _preloadSprite(spritePath)
	if RenderElementModule.imageCache[spritePath] then
		return
	end

	local temp = RenderElementModule.new({
		type = "sprite",
		spritePath = spritePath
	})

	temp:Remove()
end

-- Gets the image for a boolean toggle.
local function _booleanToggleImage(value)
	return RenderElementModule.imageCache[
		value
			and CONSTANTS.BOOLEAN_TOGGLE_ON_BUTTON_PATH
			or CONSTANTS.BOOLEAN_TOGGLE_OFF_BUTTON_PATH
	]
end

-- Toggles a boolean setting.
local function _toggleBooleanSetting(category, settingKey)
	local oldValue =
		SettingsModule.loadedFile[category][settingKey]

	local newValue = not oldValue

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

-- Creates a boolean setting control.
local function _setupBooleanSettingControl(self, category, setting, rowY)
	_preloadSprite(CONSTANTS.BOOLEAN_TOGGLE_OFF_BUTTON_PATH)
	_preloadSprite(CONSTANTS.BOOLEAN_TOGGLE_ON_BUTTON_PATH)

	local currentValue =
		SettingsModule.loadedFile[category][setting.key]

	local toggleData = _copyWithOverrides(
		SceneData.booleanSettingToggleHitbox,
		{
			y = rowY,

			type = "sprite",

			spritePath = currentValue
				and CONSTANTS.BOOLEAN_TOGGLE_ON_BUTTON_PATH
				or CONSTANTS.BOOLEAN_TOGGLE_OFF_BUTTON_PATH
		}
	)

	local toggleHitbox = UISharedFunctions:CreateElement(
		toggleData,
		self
	)

	local toggleButton = UIButtonObjectModule.new({
		elements = {toggleHitbox},

		hitboxElement = toggleHitbox,

		mouseButton = 1,

		onClick = function()
			toggleHitbox.drawable = _booleanToggleImage(
				_toggleBooleanSetting(
					category,
					setting.key
				)
			)
		end
	})

	table.insert(self._objects, toggleButton)

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
	local range = SAVES_CONSTANTS.NUMBER_SETTING_RANGES[settingKey]

	local oldValue =
		SettingsModule.loadedFile[category][settingKey]

	local newValue = _clampNumberSetting(
		oldValue +
		direction *
		CONSTANTS.NUMBER_SETTING_CHANGE_INCREMENT,
		range
	)

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

-- Changes an enum setting.
local function _cycleEnumSetting(category, settingKey, direction)
	local options = ENUM_SETTING_OPTIONS[settingKey]

	if not options or #options == 0 then
		return
	end

	local oldValue =
		SettingsModule.loadedFile[category][settingKey]

	local currentIndex = 1

	for index, option in pairs(options) do
		if option == oldValue then
			currentIndex = index
			break
		end
	end

	local newIndex =
		((currentIndex - 1 + direction) % #options) + 1

	local newValue = options[newIndex]

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

-- Formats a value as a percentage.
local function _formatPercent(value)
	return math.floor(value * 100 + 0.5) .. "%"
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
	local decreaseHitbox = UISharedFunctions:CreateElement(
		_copyWithOverrides(
			SceneData.decreaseSettingHitbox,
			{
				y = rowY,
				spritePath = decreaseSprite
			}
		),
		self
	)

	local increaseHitbox = UISharedFunctions:CreateElement(
		_copyWithOverrides(
			SceneData.increaseSettingHitbox,
			{
				y = rowY,
				spritePath = increaseSprite
			}
		),
		self
	)

	local valueLabel = UISharedFunctions:CreateElement(
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

	local decreaseButton = UIButtonObjectModule.new({
		elements = {decreaseHitbox},

		hitboxElement = decreaseHitbox,

		mouseButton = 1,

		onClick = _step(-1)
	})

	local increaseButton = UIButtonObjectModule.new({
		elements = {increaseHitbox},

		hitboxElement = increaseHitbox,

		mouseButton = 1,

		onClick = _step(1)
	})

	table.insert(self._objects, decreaseButton)
	table.insert(self._objects, increaseButton)

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

		CONSTANTS.NUMBER_DECREASE_BUTTON_PATH,
		CONSTANTS.NUMBER_INCREASE_BUTTON_PATH,

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

		CONSTANTS.ENUM_DECREASE_BUTTON_PATH,
		CONSTANTS.ENUM_INCREASE_BUTTON_PATH,

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
			CONSTANTS.BUTTON_HORIZONTAL_GAP
		)

		local label = UISharedFunctions:CreateElement(
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
		UISharedFunctions:CreateElement(
			SceneData.currentCategoryLabel,
			self
		)

	_updateCategoryLabel()
end

-- Creates the category scroll buttons.
local function _setupScrollButtons(self)
	local scrollRightButtonHitbox =
		UISharedFunctions:CreateElement(
			SceneData.scrollRightButtonHitbox,
			self
		)

	local scrollLeftButtonHitbox =
		UISharedFunctions:CreateElement(
			SceneData.scrollLeftButtonHitbox,
			self
		)

	local scrollRightButton = UIButtonObjectModule.new({
		elements = {scrollRightButtonHitbox},

		hitboxElement = scrollRightButtonHitbox,

		mouseButton = 1,

		onClick = function()
			_scrollCategory(self, 1)
		end
	})

	local scrollLeftButton = UIButtonObjectModule.new({
		elements = {scrollLeftButtonHitbox},

		hitboxElement = scrollLeftButtonHitbox,

		mouseButton = 1,

		onClick = function()
			_scrollCategory(self, -1)
		end
	})

	table.insert(self._objects, scrollRightButton)
	table.insert(self._objects, scrollLeftButton)
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

	for _, category in pairs(SAVES_CONSTANTS.SETTINGS_SCHEMA) do
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

	currentCategoryIndex = 1
	currentCategoryLabel = nil

	settingNameLabels = {}
	settingValueControls = {}

	_buildCategories()

	_setupBackground(self)
	_setupCategoryScrolling(self)
	_setupCancelButton(self)

	if SaveFilesModule.loadedFile then
		UISharedFunctions:SetupSessionPlaytimeLabel(self)
		UISharedFunctions:SetupCurrencyLabels(self)
	end
end

return Module