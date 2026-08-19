local math = require("code.engine.helpers.math")

local SignalHandlerModule = require("code.engine.events.signalHandler")
local ShaderHandlerModule = require("code.engine.shaderHandler")
local RenderUtilsModule = require("code.engine.render.utils")
local IdManagerModule = require("code.engine.idManager")

local Module = {}

Module.imageCache = {}
Module._shaderCanvases = {}
Module._elements = {}
Module._dirty = true

local manager = IdManagerModule.new()

local Element = {}
Element.__index = Element

function Element:Remove()
	Module._elements[self.id] = nil
	manager:Release(self.id)
	Module._dirty = true
end

local function _getDimensions(element)
	if element.type == "sprite" and element.drawable then
		return
			element.drawable:getWidth() * element.scaleX,
			element.drawable:getHeight() * element.scaleY
	end

	if element.type == "text" and element.text then
		local font = element.font or love.graphics.getFont()

		return
			font:getWidth(element.text) * element.scaleX,
			font:getHeight() * element.scaleY
	end
end

function Element:SetZIndex(zIndex)
	if self.zIndex == zIndex then return end

	self.zIndex = zIndex
	Module._dirty = true
end

function Element:GetDimensions()
	return _getDimensions(self)
end

function Element:GetWidth()
	local width = _getDimensions(self)
	return width
end

function Element:GetHeight()
	local _, height = _getDimensions(self)
	return height
end

function Element:IsPointInside(x, y)
	if self.scissor and (
		x < self.scissor.x or
		x > self.scissor.x + self.scissor.width or
		y < self.scissor.y or
		y > self.scissor.y + self.scissor.height
	) then
		return false
	end

	local width, height = self:GetDimensions()

	local deltaX = x - (self.x + self.offsetX)
	local deltaY = y - (self.y + self.offsetY)

	local radians = math.rad(self.rotation)
	local cosine = math.cos(-radians)
	local sine = math.sin(-radians)

	local localX = deltaX * cosine - deltaY * sine
	local localY = deltaX * sine + deltaY * cosine

	return
		localX >= -width * self.anchorX
		and localX <= width * (1 - self.anchorX)
		and localY >= -height * self.anchorY
		and localY <= height * (1 - self.anchorY)
end

local function _drawElement(element, windowScaleFactor, windowOffsetX, windowOffsetY)
	local positionX =
		element.x * windowScaleFactor +
		windowOffsetX +
		element.offsetX

	local positionY =
		element.y * windowScaleFactor +
		windowOffsetY +
		element.offsetY

	local scaleX = element.scaleX * windowScaleFactor
	local scaleY = element.scaleY * windowScaleFactor
	local radians = math.rad(element.rotation)

	local color = element.color

	if color then
		love.graphics.setColor(
			color.r,
			color.g,
			color.b,
			color.alpha or color.a or 1
		)
	else
		love.graphics.setColor(1, 1, 1, 1)
	end

	if element.scissor then
		love.graphics.setScissor(
			element.scissor.x * windowScaleFactor + windowOffsetX,
			element.scissor.y * windowScaleFactor + windowOffsetY,
			element.scissor.width * windowScaleFactor,
			element.scissor.height * windowScaleFactor
		)
	end

	if element.type == "sprite" and element.drawable then
		local drawable = element.drawable

		love.graphics.draw(
			drawable,
			positionX,
			positionY,
			radians,
			scaleX,
			scaleY,
			drawable:getWidth() * element.anchorX,
			drawable:getHeight() * element.anchorY
		)

	elseif element.type == "text" and element.text ~= "" then
		local font = element.font or love.graphics.getFont()

		love.graphics.setFont(font)

		love.graphics.print(
			element.text,
			positionX - font:getWidth(element.text) * scaleX * element.anchorX,
			positionY - font:getHeight() * scaleY * element.anchorY,
			radians,
			scaleX,
			scaleY
		)
	end

	if element.scissor then
		love.graphics.setScissor()
	end
end

local function _getShaderCanvases()
	local width = RESOLUTION_WIDTH
	local height = RESOLUTION_HEIGHT
	local canvases = Module._shaderCanvases

	if canvases.width ~= width
		or canvases.height ~= height
		or not canvases.canvasA
		or not canvases.canvasB
	then
		canvases.canvasA = love.graphics.newCanvas(width, height)
		canvases.canvasB = love.graphics.newCanvas(width, height)

		canvases.width = width
		canvases.height = height
	end

	return canvases.canvasA, canvases.canvasB
end

local function _loadShaderTexture(path)
	local texture = Module.imageCache[path]

	if not texture then
		texture = love.graphics.newImage(path)
		Module.imageCache[path] = texture
	end

	return texture
end

local function _sendUniform(shader, name, value)
	if shader:hasUniform(name) then
		shader:send(name, value)
	end
end

local function _sendShaderParams(
	shader,
	shaderEntry,
	element,
	windowScaleFactor,
	windowOffsetX,
	windowOffsetY
)
	_sendUniform(shader, "time", love.timer.getTime())

	_sendUniform(shader, "canvasSize", {
		RESOLUTION_WIDTH,
		RESOLUTION_HEIGHT
	})

	_sendUniform(shader, "texelSize", {
		1 / RESOLUTION_WIDTH,
		1 / RESOLUTION_HEIGHT
	})

	_sendUniform(shader, "elementCenter", {
		element.x * windowScaleFactor +
			windowOffsetX +
			element.offsetX,

		element.y * windowScaleFactor +
			windowOffsetY +
			element.offsetY
	})

	_sendUniform(shader, "elementSize", {
		100 * element.scaleX * windowScaleFactor,
		100 * element.scaleY * windowScaleFactor
	})

	_sendUniform(
		shader,
		"elementRotation",
		math.rad(element.rotation)
	)

	if type(shaderEntry) ~= "table" then
		return
	end

	for name, value in pairs(shaderEntry) do
		if name ~= "name" then
			if name == "reflectionTexture"
				and type(value) == "string"
			then
				value = _loadShaderTexture(value)
			end

			_sendUniform(shader, name, value)
		end
	end
end

local function _drawWithShaders(
	element,
	windowScaleFactor,
	windowOffsetX,
	windowOffsetY
)
	local canvasA, canvasB = _getShaderCanvases()

	local previousCanvas = love.graphics.getCanvas()
	local previousShader = love.graphics.getShader()

	local inputCanvas = canvasA
	local outputCanvas = canvasB

	love.graphics.setCanvas(inputCanvas)
	love.graphics.clear(0, 0, 0, 0)

	love.graphics.setShader()

	_drawElement(
		element,
		windowScaleFactor,
		windowOffsetX,
		windowOffsetY
	)

	for _, shaderEntry in ipairs(element.shaders) do
		local shaderName =
			type(shaderEntry) == "table"
			and shaderEntry.name
			or shaderEntry

		local shader = ShaderHandlerModule:Get(shaderName)

		if shader then
			love.graphics.setCanvas(outputCanvas)
			love.graphics.clear(0, 0, 0, 0)

			love.graphics.setShader(shader)

			_sendShaderParams(
				shader,
				shaderEntry,
				element,
				windowScaleFactor,
				windowOffsetX,
				windowOffsetY
			)

			love.graphics.draw(inputCanvas, 0, 0)

			inputCanvas, outputCanvas =
				outputCanvas, inputCanvas
		end
	end

	love.graphics.setCanvas(previousCanvas)
	love.graphics.setShader(previousShader)

	love.graphics.draw(inputCanvas, 0, 0)
end

function Element:Draw(
	windowScaleFactor,
	windowOffsetX,
	windowOffsetY
)
	if not self.render then
		return
	end

	windowScaleFactor = windowScaleFactor or 1
	windowOffsetX = windowOffsetX or 0
	windowOffsetY = windowOffsetY or 0

	if #self.shaders == 0 then
		_drawElement(
			self,
			windowScaleFactor,
			windowOffsetX,
			windowOffsetY
		)

		return
	end

	_drawWithShaders(
		self,
		windowScaleFactor,
		windowOffsetX,
		windowOffsetY
	)
end

function Module.Get(id)
	return Module._elements[id]
end

function Module.GetAll()
	return Module._elements
end

function Module.new(data)
	data = data or {}

	local element = setmetatable({
		id = manager:Get(),

		name = data.name,

		type = data.type == "text"
			and "text"
			or "sprite",

		zIndex = data.zIndex or 0,

		text = data.text or "",
		font = data.font,

		anchorX = data.anchorX or 0.5,
		anchorY = data.anchorY or 0.5,

		offsetX = data.offsetX or 0,
		offsetY = data.offsetY or 0,

		scaleX = data.scaleX or 1,
		scaleY = data.scaleY or 1,

		x = data.x or 0,
		y = data.y or 0,

		color = data.color
			or RenderUtilsModule.CreateColor(),

		rotation = data.rotation or 0,

		render = data.render ~= false,

		scissor = data.scissor,

		shaders = data.shaders or {}
	}, Element)

	if element.type == "sprite" then
		local fallbackPath = "assets/sprites/missing.png"
		local path = data.spritePath or fallbackPath

		if not love.filesystem.getInfo(path, "file") then
			path = fallbackPath
		end

		local drawable = Module.imageCache[path]

		if not drawable then
			drawable = love.graphics.newImage(path)
			drawable:setFilter("nearest", "nearest")

			Module.imageCache[path] = drawable
		end

		element.drawable = drawable
		element.spritePath = path

	elseif not element.font then
		element.font = love.graphics.newFont(
			"assets/fonts/Stanberry.ttf"
		)
	end

	Module._elements[element.id] = element
	Module._dirty = true

	SignalHandlerModule
		.Get("engine.render.elementcreated")
		:Fire(element)

	return element
end

return Module