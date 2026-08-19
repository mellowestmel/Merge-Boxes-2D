local SignalHandlerModule = require("code.engine.events.signalHandler")
local ShaderHandlerModule = require("code.engine.shaderHandler")
local SettingsModule = require("code.engine.saves.settings")
local ColorblindData = require("code.data.colorblind")
local RenderElementModule = require("code.engine.render.element")

local Module = {}

Module._sortedCache = {}

Module._sceneCanvas = nil

local function _getSortOrder(element)
	return element.zIndex + ((element.id / 1000) % 1)
end

local function _getSceneCanvas()
	if not Module._sceneCanvas then
		Module._sceneCanvas = love.graphics.newCanvas(
			RESOLUTION_WIDTH,
			RESOLUTION_HEIGHT
		)
	end

	return Module._sceneCanvas
end

function Module:Draw()
	-- Rebuild sorted cache only when element hierarchy changes.
	if RenderElementModule._dirty then
		local sortedElements = {}

		for _, element in pairs(RenderElementModule._elements) do
			table.insert(sortedElements, element)
		end

		table.sort(sortedElements, function(a, b)
			return _getSortOrder(a) < _getSortOrder(b)
		end)

		self._sortedCache = sortedElements
		RenderElementModule._dirty = false
	end

	-- Compute resolution scale & letterbox offsets.
	local currentWindowWidth, currentWindowHeight = love.graphics.getDimensions()

	local windowScaleX = currentWindowWidth / RESOLUTION_WIDTH
	local windowScaleY = currentWindowHeight / RESOLUTION_HEIGHT
	local windowScaleFactor = math.min(windowScaleX, windowScaleY)

	local windowOffsetX =
		(currentWindowWidth - RESOLUTION_WIDTH * windowScaleFactor) / 2

	local windowOffsetY =
		(currentWindowHeight - RESOLUTION_HEIGHT * windowScaleFactor) / 2

	local sceneCanvas = _getSceneCanvas()

	-- Render entire scene at virtual resolution.
	local previousCanvas = love.graphics.getCanvas()
	local previousShader = love.graphics.getShader()

	love.graphics.setCanvas(sceneCanvas)
	love.graphics.clear(0, 0, 0, 0)
	love.graphics.setShader()
	love.graphics.setScissor()

	for _, element in ipairs(self._sortedCache) do
		element:Draw()
	end

	-- Update accessibility shaders.
	local accessibility = SettingsModule.loadedFile.accessibility
	local graphics = SettingsModule.loadedFile.graphics

	ShaderHandlerModule:Send("accessibility", "contrast", graphics.contrast)
	ShaderHandlerModule:Send("accessibility", "gamma", graphics.gamma)

	ShaderHandlerModule:Send("accessibility", "enableColorblind", accessibility.colorblindMode ~= "none")

	if accessibility.colorblindMode ~= "none" then
		ShaderHandlerModule:Send("accessibility", "colorMatrix", ColorblindData[accessibility.colorblindMode])
	end

	-- Restore the original render target.
	love.graphics.setCanvas(previousCanvas)
	love.graphics.setShader(previousShader)
	love.graphics.setScissor()

	-- Draw the virtual-resolution scene into the letterboxed window.
	love.graphics.setColor(1, 1, 1, 1)

	local accessibilityShader =
		ShaderHandlerModule:Get("accessibility")

	if accessibilityShader then
		love.graphics.setShader(accessibilityShader)
	end

	love.graphics.draw(
		sceneCanvas,
		windowOffsetX,
		windowOffsetY,
		0,
		windowScaleFactor,
		windowScaleFactor
	)

	love.graphics.setShader(previousShader)
	love.graphics.setColor(1, 1, 1, 1)
end

function Module:Update()
	local fullscreen = SettingsModule.loadedFile.graphics.fullscreen
	local vsync = SettingsModule.loadedFile.graphics.vsync

	love.window.setFullscreen(fullscreen)
	love.window.setVSync(vsync)
end

function Module.Init()
	SignalHandlerModule.Get("love.update"):Connect(function()
		Module:Update()
	end)

	SignalHandlerModule.Get("love.draw"):Connect(function()
		Module:Draw()
	end)

	ShaderHandlerModule.Init()
end

return Module