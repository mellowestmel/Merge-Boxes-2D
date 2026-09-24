-- ~/code/engine/render/element.lua

local LocalizationHandlerModule = require("code.engine.localizationHandler")
local SignalHandlerModule = require("code.engine.events.signalHandler")
local ShaderHandlerModule = require("code.engine.shaderHandler")
local IdManagerModule = require("code.engine.idManager")
local RenderUtilsModule = require("code.engine.render.utils")

local Module = {}

Module.imageCache = {}
Module._elements = {}
Module._dirty = true

local manager = IdManagerModule.new()

local Element = {}
Element.__index = Element

function Module:PreloadSprite(path)
    assert(path, "PreloadSprite requires path")

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
    self.removed = true

    Module._elements[self.id] = nil
    manager:Release(self.id)
    Module._dirty = true
end

local function _getDimensions(element)
    if element.type == "sprite" then
        local drawable = element.drawable

        assert(drawable, "Sprite element requires drawable")

        return
            drawable:getWidth() * element.scaleX,
            drawable:getHeight() * element.scaleY
    end

    local font = element.font or love.graphics.getFont()
    local text = type(element.text) == "string" and element.text or ""

    return
        font:getWidth(text),
        font:getHeight() * element.scaleY
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

    if element.type == "sprite" then
        local drawable = element.drawable

        assert(drawable, "Sprite element requires drawable")

        love.graphics.draw(
            drawable,

            positionX,
            positionY,

            radians,

            element.scaleX,
            element.scaleY,

            drawable:getWidth() * element.anchorX,
            drawable:getHeight() * element.anchorY
        )

    elseif element.type == "custom" and element.onDraw then
        element.onDraw(element)

    elseif element.type == "text" and type(element.text) == "string" and element.text ~= "" then
        local font = element.font or love.graphics.getFont()

        love.graphics.setFont(font)

        love.graphics.print(
            element.text,

            positionX - font:getWidth(element.text) * element.scaleX * element.anchorX,
            positionY - font:getHeight() * element.scaleY * element.anchorY,

            radians,

            element.scaleX,
            element.scaleY
        )
    end

    if element.scissor then
        love.graphics.setScissor()
    end
end

-- Reused every draw. The shader handler only reads it during the call.
local _shaderContext = {}

local function _getShaderContext(element)
    local width, height = _getDimensions(element)

    _shaderContext.x = element.x + element.offsetX
    _shaderContext.y = element.y + element.offsetY

    _shaderContext.width = width
    _shaderContext.height = height

    _shaderContext.rotation = math.rad(element.rotation)
    _shaderContext.alpha = element.color.a

    return _shaderContext
end

function Element:Draw()
    if not self.render then
        return
    end

    if self.bypassShaders or #self.shaders == 0 then
        _drawElement(self)
        return
    end

    ShaderHandlerModule:DrawChain(
        self.shaders,
        _getShaderContext(self),
        _drawElement,
        self
    )
end

function Module.Get(id)
    return Module._elements[id]
end

function Module.GetAll()
    return Module._elements
end

function Module.new(data)
    assert(data, "RenderElementModule.new requires data")

    local element = setmetatable({
        id = manager:Get(),

        name = data.name,

        -- "custom" calls data.onDraw(element) instead of drawing a sprite or text
        type = (data.type == "text" or data.type == "custom")
            and data.type
            or "sprite",

        onDraw = data.onDraw,
        removed = false,

        zIndex = data.zIndex or 0,

        text = data.textKey
        and LocalizationHandlerModule.Get(data.textKey)
        or data.text
        or "",

        font = data.font,

        anchorX = data.anchorX or .5,
        anchorY = data.anchorY or .5,

        offsetX = data.offsetX or 0,
        offsetY = data.offsetY or 0,

        scaleX = data.scaleX or 1,
        scaleY = data.scaleY or 1,

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
    elseif element.type == "text" and not element.font then
        element.font = love.graphics.newFont(
            "assets/fonts/Baloo2.ttf"
        )
    end

    Module._elements[element.id] = element
    Module._dirty = true

    SignalHandlerModule.Get("engine.render.elementcreated"):Fire(element)

    return element
end

return Module