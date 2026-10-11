-- ~/code/engine/render/element.lua

local math = require("code.engine.helpers.math")

local SignalHandlerModule = require("code.engine.events.signalHandler")
local ShaderHandlerModule = require("code.engine.shaderHandler")
local IdManagerModule = require("code.engine.idManager")
local RenderUtilsModule = require("code.engine.render.utils")

local Module = {}

Module.imageCache = {}
Module._shaderCanvases = {}
Module._elements = {}
Module._dirty = true

local manager = IdManagerModule.new()

local Element = {}
Element.__index = Element

function Module:PreloadSprite(path)
    if not path then return nil end

    if not love.filesystem.getInfo(path, "file") then
        path = "assets/sprites/missing.png"
    end

    local drawable = self.imageCache[path]

    if not drawable then
        drawable = love.graphics.newImage(path)
        drawable:setFilter("nearest", "nearest")

        self.imageCache[path] = drawable
    end

    return drawable
end

function Element:ChangeSprite(path)
    if self.type ~= "sprite" then
        return
    end

    local fallbackPath = "assets/sprites/missing.png"

    if not path or not love.filesystem.getInfo(path, "file") then
        path = fallbackPath
    end

    self.drawable = Module:PreloadSprite(path)
    self.spritePath = path

    Module._dirty = true
end

-- Partial updates are fine: :ChangeColor({a = 0.5}) only changes alpha.
-- The existing color table is updated in place, so references stay valid.
function Element:ChangeColor(new)
    local color = self.color

    local updated = RenderUtilsModule.CreateColor(
        new.r or new[1] or color.r,
        new.g or new[2] or color.g,
        new.b or new[3] or color.b,
        new.a or new[4] or color.a
    )

    color.r, color.g, color.b, color.a =
        updated.r, updated.g, updated.b, updated.a
end

function Element:SetAlpha(alpha)
    self.color.a = math.clamp(alpha, 0, 1)
end

function Element:GetAlpha()
    return self.color.a
end

function Element:GetColor()
    local color = self.color
    return color.r, color.g, color.b, color.a
end

function Element:Remove()
    Module._elements[self.id] = nil
    manager:Release(self.id)
    Module._dirty = true
end

local function _getDimensions(element)
    local width, height

    if element.type == "sprite" and element.drawable then
        width, height = element.drawable:getDimensions()

    elseif element.type == "text" then
        local font = element.font or love.graphics.getFont()
        width = font:getWidth(element.text or "")
        height = font:getHeight()

    else
        width, height = RESOLUTION_WIDTH, RESOLUTION_HEIGHT
    end

    return
        (element.width or width) * element.scaleX,
        (element.height or height) * element.scaleY
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

local function _drawElement(element)
    local positionX = element.x + element.offsetX
    local positionY = element.y + element.offsetY
    local radians = math.rad(element.rotation)

    local width, height = _getDimensions(element)
    local color = element.color

    love.graphics.setColor(
        color.r / 255,
        color.g / 255,
        color.b / 255,
        color.a
    )

    if element.scissor then
        love.graphics.setScissor(
            element.scissor.x,
            element.scissor.y,
            element.scissor.width,
            element.scissor.height
        )
    end

    if element.type == "sprite" and element.drawable then
        local drawable = element.drawable
        local drawableWidth, drawableHeight = drawable:getDimensions()

        love.graphics.draw(
            drawable,
            positionX,
            positionY,
            radians,
            width / drawableWidth,
            height / drawableHeight,
            drawableWidth * element.anchorX,
            drawableHeight * element.anchorY
        )

    elseif element.type == "text" and element.text ~= "" then
        local font = element.font or love.graphics.getFont()
        love.graphics.setFont(font)

        local fontWidth = math.max(font:getWidth(element.text), 1)
        local fontHeight = math.max(font:getHeight(), 1)

        love.graphics.print(
            element.text,
            positionX - width * element.anchorX,
            positionY - height * element.anchorY,
            radians,
            width / fontWidth,
            height / fontHeight
        )

    elseif element.type == "rectangle" then
        love.graphics.push()

        love.graphics.translate(positionX, positionY)
        love.graphics.rotate(radians)

        love.graphics.rectangle(
            element.shapeMode,
            -width * element.anchorX,
            -height * element.anchorY,
            width,
            height
        )

        love.graphics.pop()
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

local function _loadTexture(path)
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

local STANDARD_UNIFORM_PROVIDERS = {
    time = function()
        return love.timer.getTime()
    end,

    canvasSize = function()
        return { RESOLUTION_WIDTH, RESOLUTION_HEIGHT }
    end,

    texelSize = function()
        return { 1 / RESOLUTION_WIDTH, 1 / RESOLUTION_HEIGHT }
    end,

    elementCenter = function(element)
        return { element.x + element.offsetX, element.y + element.offsetY }
    end,

    elementSize = function(element)
        return { _getDimensions(element) }
    end,

    elementRotation = function(element)
        return math.rad(element.rotation)
    end,

    elementAlpha = function(element)
        return element.color.a
    end,
}

local function _sendShaderParams(shader, shaderEntry, element)
    for name, getValue in pairs(STANDARD_UNIFORM_PROVIDERS) do
        if shader:hasUniform(name) then
            shader:send(name, getValue(element))
        end
    end

    if type(shaderEntry) ~= "table" then
        return
    end

    for name, value in pairs(shaderEntry) do
        if name ~= "name" then
            if type(value) == "string" and name:match("Texture$") then
                value = _loadTexture(value)
            end

            _sendUniform(shader, name, value)
        end
    end
end

local function _drawWithShaders(element)
    local inputCanvas, outputCanvas = _getShaderCanvases()

    local previousCanvas = love.graphics.getCanvas()
    local previousShader = love.graphics.getShader()

    love.graphics.setCanvas(inputCanvas)
    love.graphics.clear(0, 0, 0, 0)

    love.graphics.setShader()

    _drawElement(element)

    for _, shaderEntry in pairs(element.shaders) do
        local shaderName = type(shaderEntry) == "table"
            and shaderEntry.name
            or shaderEntry

        local shader = ShaderHandlerModule:Get(shaderName)

        if shader then
            love.graphics.setCanvas(outputCanvas)
            love.graphics.clear(0, 0, 0, 0)

            love.graphics.setShader(shader)

            love.graphics.setColor(1, 1, 1, 1)

            _sendShaderParams(shader, shaderEntry, element)
            love.graphics.draw(inputCanvas, 0, 0)

            inputCanvas, outputCanvas = outputCanvas, inputCanvas
        end
    end

    love.graphics.setCanvas(previousCanvas)
    love.graphics.setShader(previousShader)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(inputCanvas, 0, 0)
end

function Element:Draw()
    if not self.render then
        return
    end

    if self.bypassShaders or #self.shaders == 0 then
        _drawElement(self)
        return
    end

    _drawWithShaders(self)
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

        type = data.type == "text" and "text"
            or data.type == "rectangle" and "rectangle"
            or "sprite",

        zIndex = data.zIndex or 0,

        shapeMode = data.shapeMode or "line",
        spritePath = data.spritePath or "",

        text = data.text or "",
        font = data.font,

        anchorX = data.anchorX or .5,
        anchorY = data.anchorY or .5,

        offsetX = data.offsetX or 0,
        offsetY = data.offsetY or 0,

        scaleX = data.scaleX or 1,
        scaleY = data.scaleY or 1,

        height = data.height,
        width = data.width,

        x = data.x or 0,
        y = data.y or 0,

        color = RenderUtilsModule.CreateColor(data.color),

        rotation = data.rotation or 0,

        bypassShaders = data.bypassShaders or false,
        render = data.render ~= false,

        scissor = data.scissor,

        shaders = data.shaders or {}
    }, Element)

    if element.type == "sprite" then
        element:ChangeSprite(data.spritePath)

    elseif not element.font then
        element.font = love.graphics.newFont(
            "assets/fonts/Stanberry.ttf"
        )
    end

    Module._elements[element.id] = element
    Module._dirty = true

    SignalHandlerModule.Get("engine.render.elementcreated"):Fire(element)

    return element
end

return Module