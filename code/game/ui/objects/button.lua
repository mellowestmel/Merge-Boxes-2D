-- ~/code/game/ui/objects/button.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")

local RenderUtilsModule = require("code.engine.render.utils")
local SoundHandlerModule = require("code.engine.soundHandler")
local IdManagerModule = require("code.engine.idManager")

local SettingsModule = require("code.engine.saves.settings")

local math = require("code.engine.helpers.math")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local Button = {}
Button.__index = Button

local Module = {}
Module._buttons = {}

local manager = IdManagerModule.new()

function Button:Remove()
	Module._buttons[self.id] = nil
	manager:Release(self.id)
end

function Button:MousePressed(x, y, mouseButton)
	if ScreenTransitionModule.transitioning then return end

	if not self.hitboxElement.render then return end
	if (love.timer.getTime() - self.lastUsed) < self.cooldown then return end
	if not self.hitboxElement:IsPointInside(x, y) then return end
	if mouseButton ~= self.mouseButton then return end

	self.lastUsed = love.timer.getTime()

	local animationsEnabled = SettingsModule.loadedFile.graphics.uiAnimationsEnabled

	if animationsEnabled then
		for _, element in pairs(self.elements) do
			element._baseScaleX = element._baseScaleX or (element.scaleX or 1)
			element._baseScaleY = element._baseScaleY or (element.scaleY or 1)

			element.scaleX = element._baseScaleX - self._clickScale
			element.scaleY = element._baseScaleY - self._clickScale
		end
	end

	if self.playClickSound then
		local sound = SoundHandlerModule.new({
			soundPath = "assets/sounds/ui/click.wav"
		})

		if sound then
			sound:Play(true, -100, 100, 1000)
			sound:Remove()
		end
	end

	SignalHandlerModule.Get("game.ui.buttonclicked"):Fire(self)

	if self.onClick then
		self:onClick()
	end
end

function Button:Update(deltaTime)
	if not self.hitboxElement then
		self:Remove()
		return
	end

	local mouseX, mouseY = RenderUtilsModule.GetScaledMousePosition()
	local isHovered = self.hitboxElement:IsPointInside(mouseX, mouseY)

	if isHovered ~= self._isHovered then
		self._isHovered = isHovered
	end

	local animationsEnabled = SettingsModule.loadedFile.graphics.uiAnimationsEnabled
	local scaleLerp = animationsEnabled and math.min(1, self._scaleSpeed * deltaTime * 10) or 1

	for _, element in pairs(self.elements) do
		element._baseScaleX = element._baseScaleX or (element.scaleX or 1)
		element._baseScaleY = element._baseScaleY or (element.scaleY or 1)

		local targetScaleX = element._baseScaleX
		local targetScaleY = element._baseScaleY

		if self._isHovered then
			targetScaleX = targetScaleX + self._hoverScale
			targetScaleY = targetScaleY + self._hoverScale
		end

		element.scaleX = element.scaleX + (targetScaleX - element.scaleX) * scaleLerp
		element.scaleY = element.scaleY + (targetScaleY - element.scaleY) * scaleLerp
	end
end

function Module.new(data)
	if not data then return end
	if not data.hitboxElement then return end
	if #data.elements == 0 then return end

	local button = setmetatable({
		id = manager:Get(),

		elements = data.elements or {},

		cooldown = data.cooldown or .25,
		lastUsed = -math.huge,

		playClickSound = data.playClickSound or true,

		hitboxElement = data.hitboxElement,

		mouseButton = data.mouseButton or 1,
		onClick = data.onClick or nil,

		_clickScale = data.clickScale or .1,
		_hoverScale = data.hoverScale or .05,

		_scaleSpeed = data.scaleSpeed or .5,

		_isHovered = false
	}, Button)

	Module._buttons[button.id] = button

	return button
end

function Module:MousePressed(x, y, mouseButton)
	for _, button in pairs(self._buttons) do
		button:MousePressed(x, y, mouseButton)
	end
end

function Module:Update(deltaTime)
	for _, button in pairs(self._buttons) do
		button:Update(deltaTime)
	end
end

return Module