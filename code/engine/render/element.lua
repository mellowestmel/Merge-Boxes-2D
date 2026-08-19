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
	local width
	local height

	if element.type == "sprite" and element.drawable then
		width = element.drawable:getWidth() * element.scaleX
		height = element.drawable:getHeight() * element.scaleY
	elseif element.type == "text" and element.text then
		local font = element.font or love.graphics.getFont()
		width = font:getWidth(element.text) * element.scaleX
		height = font:getHeight() * element.scaleY
	end

	return width, height
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
	) then return false end

	local width, height = self:GetDimensions()

	local deltaX = x - (self.x + self.offsetX)
	local deltaY = y - (self.y + self.offsetY)

	local radians = math.rad(self.rotation)
	local cosine = math.cos(-radians)
	local sine = math.sin(-radians)

	local localX = deltaX * cosine - deltaY * sine
	local localY = deltaX * sine + deltaY * cosine

	return localX >= -width * self.anchorX
		and localX <= width * (1 - self.anchorX)
		and localY >= -height * self.anchorY
		and localY <= height * (1 - self.anchorY)
end

local function _drawElement(element, windowScaleFactor, windowOffsetX, windowOffsetY)
	-- Default scale to 1 if no scaling arguments are passed.
	windowScaleFactor = windowScaleFactor or 1
	windowOffsetX = windowOffsetX or 0
	windowOffsetY = windowOffsetY or 0

	-- Calculate scaled screen coordinates.
	local positionX = element.x * windowScaleFactor + windowOffsetX + element.offsetX
	local positionY = element.y * windowScaleFactor + windowOffsetY + element.offsetY

	local scaleX = element.scaleX * windowScaleFactor
	local scaleY = element.scaleY * windowScaleFactor
	local radians = math.rad(element.rotation)

	-- Set element color.
	if element.color then
		love.graphics.setColor(element.color.r, element.color.g, element.color.b, element.color.alpha or element.color.a or 1)
	else
		love.graphics.setColor(1, 1, 1, 1)
	end

	-- Apply scaled scissor cropping.
	if element.scissor then
		local scissorX = element.scissor.x * windowScaleFactor + windowOffsetX
		local scissorY = element.scissor.y * windowScaleFactor + windowOffsetY
		local scissorWidth = element.scissor.width * windowScaleFactor
		local scissorHeight = element.scissor.height * windowScaleFactor

		love.graphics.setScissor(scissorX, scissorY, scissorWidth, scissorHeight)
	end

	if element.type == "sprite" and element.drawable then
		local originX = element.drawable:getWidth() * element.anchorX
		local originY = element.drawable:getHeight() * element.anchorY

		love.graphics.draw(
			element.drawable,
			positionX,
			positionY,
			radians,
			scaleX,
			scaleY,
			originX,
			originY
		)
	elseif element.type == "text" and element.text and element.text ~= "" then
		local font = element.font or love.graphics.getFont()
		love.graphics.setFont(font)

		local drawX = positionX - font:getWidth(element.text) * scaleX * element.anchorX
		local drawY = positionY - font:getHeight() * scaleY * element.anchorY

		love.graphics.print(element.text, drawX, drawY, radians, scaleX, scaleY)
	end

	-- Reset scissor.
	if element.scissor then
		if windowScaleFactor ~= 1 or windowOffsetX ~= 0 or windowOffsetY ~= 0 then
			love.graphics.setScissor(windowOffsetX, windowOffsetY, RESOLUTION_WIDTH * windowScaleFactor, RESOLUTION_HEIGHT * windowScaleFactor)
		else
			love.graphics.setScissor()
		end
	end
end

local function _getShaderCanvases(width, height)
	local canvases = Module._shaderCanvases

	if canvases.width ~= width or canvases.height ~= height or not canvases.canvasA or not canvases.canvasB then
		canvases.canvasA = love.graphics.newCanvas(width, height)
		canvases.canvasB = love.graphics.newCanvas(width, height)
		canvases.width = width
		canvases.height = height
	end

	return canvases.canvasA, canvases.canvasB
end

local function _drawWithShaders(element, windowScaleFactor, windowOffsetX, windowOffsetY)
	local width = RESOLUTION_WIDTH
	local height = RESOLUTION_HEIGHT

	local canvasA, canvasB = _getShaderCanvases(width, height)

	local previousCanvas = love.graphics.getCanvas()
	local previousShader = love.graphics.getShader()

	local inputCanvas = canvasA
	local outputCanvas = canvasB

	-- Draw the original element into the first canvas.
	love.graphics.setCanvas(inputCanvas)
	love.graphics.clear(0, 0, 0, 0)
	love.graphics.setShader()

	_drawElement(element, windowScaleFactor, windowOffsetX, windowOffsetY)

	-- Pass the result through every shader in order.
	for _, shaderName in ipairs(element.shaders) do
		local shader = ShaderHandlerModule:Get(shaderName)

		if shader then
			love.graphics.setCanvas(outputCanvas)
			love.graphics.clear(0, 0, 0, 0)
			love.graphics.setShader(shader)

			shader:send("texelSize", {1 / width, 1 / height})

			love.graphics.draw(inputCanvas, 0, 0)

			inputCanvas, outputCanvas = outputCanvas, inputCanvas
		end
	end

	-- Restore whatever was active before the element.
	love.graphics.setCanvas(previousCanvas)
	love.graphics.setShader(previousShader)

	-- Draw the final shader output onto the scene.
	love.graphics.draw(inputCanvas, 0, 0)
end

function Element:Draw(windowScaleFactor, windowOffsetX, windowOffsetY)
	if not self.render then return end

	windowScaleFactor = windowScaleFactor or 1
	windowOffsetX = windowOffsetX or 0
	windowOffsetY = windowOffsetY or 0

	if #self.shaders == 0 then
		_drawElement(self, windowScaleFactor, windowOffsetX, windowOffsetY)
		return
	end

	_drawWithShaders(self, windowScaleFactor, windowOffsetX, windowOffsetY)
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

		type = data.type == "text" and "text" or "sprite",
		zIndex = data.zIndex or 0,

		text = data.text or "",
		font = data.font,

		anchorX = data.anchorX or .5,
		anchorY = data.anchorY or .5,

		offsetX = data.offsetX or 0,
		offsetY = data.offsetY or 0,

		scaleX = data.scaleX or 1,
		scaleY = data.scaleY or 1,

		x = data.x or 0,
		y = data.y or 0,

		color = data.color or RenderUtilsModule.CreateColor(),
		rotation = data.rotation or 0,

		render = data.render ~= false,

		scissor = data.scissor,

		shaders = data.shaders or {}
	}, Element)

	if element.type == "sprite" then
		local fallbackPath = "assets/sprites/missing.png"
		local path = data.spritePath or fallbackPath

		if not love.filesystem.getInfo(path, "file") then path = fallbackPath end

		if not Module.imageCache[path] then
			local drawable = love.graphics.newImage(path)
			drawable:setFilter("nearest", "nearest")
			Module.imageCache[path] = drawable
		end

		element.drawable = Module.imageCache[path]
		element.spritePath = path
	elseif not element.font then
		element.font = love.graphics.newFont("assets/fonts/Stanberry.ttf")
	end

	Module._elements[element.id] = element
	Module._dirty = true

	SignalHandlerModule.Get("engine.render.elementcreated"):Fire(element)

	return element
end

return Module