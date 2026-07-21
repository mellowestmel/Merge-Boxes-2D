-- ~/code/engine/render.lua

--// ENGINE \\--
local IdManagerModule = require("code.engine.idManager")
local ShaderModule = require("code.engine.shaders")

--// SAVES \\--
local SettingsModule = require("code.engine.saves.settings")

--// HELPERS \\--
local math = require("code.engine.helpers.math")

--/// DATA \\\--
local ColorblindData = require("code.data.colorblind")

local Module = {}
Module.fullscreen = false
Module.imageCache = {}
Module._elements = {}

Module._sortedCache = {}
Module._dirty = true

local manager = IdManagerModule:createManager()

function Module:createColorFromTable(color)
    return self:createColor(
        color[1],
        color[2],
        color[3],
        color[4]
    )
end

function Module:createColor(r, g, b, alpha)
    return {
        r = (r or 255) / 255,
        g = (g or 255) / 255,
        b = (b or 255)  / 255,
        alpha = alpha or 1
    }
end

local Element = {
    id = 0,

    type = "sprite",
    zIndex = 0,

    anchorX = .5,
    anchorY = .5,

    offsetX = 0,
    offsetY = 0,

    scaleX = 1,
    scaleY = 1,

    x = 0,
    y = 0,

    color = Module:createColor(255, 255, 255),
    rotation = 0,

    reflective = false,
    render = true,
    flip = false
}
Element.__index = Element

function Element:remove()
    local id = self.id

    Module._elements[id] = nil
    Module._dirty = true
    manager:release(id)
end

function Element:setZIndex(value)
    if self.zIndex == value then return end
    self.zIndex = value
    Module._dirty = true
end

function Element:isPointInside(pointX, pointY)
    local width, height = 0, 0

    if self.type == "sprite" and self.drawable then
        width = self.drawable:getWidth() * self.scaleX
        height = self.drawable:getHeight() * self.scaleY
    elseif self.type == "text" and self.text then
        local font = love.graphics.getFont()
        width = font:getWidth(self.text) * self.scaleX
        height = font:getHeight() * self.scaleY
    end

    local deltaX = pointX - (self.x + (self.offsetX or 0))
    local deltaY = pointY - (self.y + (self.offsetY or 0))

    local rotation = self.rotation * (self.flip and -1 or 1)
    local cosRotation = math.cos(-rotation)
    local sinRotation = math.sin(-rotation)

    local localX = deltaX * cosRotation - deltaY * sinRotation
    local localY = deltaX * sinRotation + deltaY * cosRotation

    local left = -width * self.anchorX
    local right = width * (1 - self.anchorX)
    local top = -height * self.anchorY
    local bottom = height * (1 - self.anchorY)

    return localX >= left and localX <= right
       and localY >= top and localY <= bottom
end

function Element:draw(windowScaleFactor, windowOffsetX, windowOffsetY)
    local x = self.x * windowScaleFactor + windowOffsetX + (self.offsetX or 0)
    local y = self.y * windowScaleFactor + windowOffsetY + (self.offsetY or 0)

    local scaleX = self.scaleX * (self.flip and -1 or 1) * windowScaleFactor
    local scaleY = self.scaleY * windowScaleFactor
    local rotation = self.rotation * (self.flip and -1 or 1)

    local color = self.color or Module:createColor()
    love.graphics.setColor(color.r, color.g, color.b, color.alpha)

    if self.type == "sprite" and self.drawable then
        local offsetX = self.drawable:getWidth() * self.anchorX
        local offsetY = self.drawable:getHeight() * self.anchorY

        if self.reflective and self.reflectionPath then
            if not Module.imageCache[self.reflectionPath] then
                Module.imageCache[self.reflectionPath] = love.graphics.newImage(self.reflectionPath)
            end

            local reflectionImage = Module.imageCache[self.reflectionPath]

            local iw, ih = reflectionImage:getWidth(), reflectionImage:getHeight()

            local boxWidth = self.drawable:getWidth() * self.scaleX
            local boxHeight = self.drawable:getHeight() * self.scaleY
            local boxLeft = self.x - self.drawable:getWidth() * self.anchorX
            local boxTop = self.y - self.drawable:getHeight() * self.anchorY

            local rx = boxLeft / _G.WINDOW_WIDTH * iw - (boxLeft / 4)
            local ry = boxTop / _G.WINDOW_HEIGHT * ih - (boxTop / 4)
            local rw = boxWidth / _G.WINDOW_WIDTH * iw
            local rh = boxHeight / _G.WINDOW_HEIGHT * ih

            local quad = love.graphics.newQuad(rx, ry, rw, rh, iw, ih)

            love.graphics.setColor(1, 1, 1, self.color.alpha)
            love.graphics.draw(reflectionImage, quad,
                x,
                y,
                self.rotation,
                windowScaleFactor, windowScaleFactor,
                boxWidth / 2, boxHeight / 2
            )
        end

        love.graphics.draw(self.drawable, x, y, rotation, scaleX, scaleY, offsetX, offsetY)
    elseif self.type == "text" and self.text then
        local font = self.font or love.graphics.getFont()
        love.graphics.setFont(font)
        local drawX = x - font:getWidth(self.text) * scaleX * self.anchorX
        local drawY = y - font:getHeight(self.text) * scaleY * self.anchorY
        love.graphics.print(self.text, drawX, drawY, rotation, scaleX, scaleY)
    end
end

function Element:setRotation(rotation)
    self.rotation = math.rad(rotation)
end

function Module:createElement(data)
    if (data.type ~= "text") and (data.type ~= "sprite") then data.type = "sprite" end

    local element = setmetatable({
        id = manager:get(),

        type = data.type or "sprite",
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

        color = data.color or Module:createColor(),
        rotation = data.rotation or 0,

        reflectionPath = data.reflectionPath or "",
        reflective = (data.reflective ~= nil) and data.reflective or false,

        render = (data.render ~= nil) and data.render or true,
        flip = (data.flip ~= nil) and data.flip or false
    }, Element)

    self._elements[element.id] = element
    self._dirty = true

    if data.type == "sprite" then
        if not (data.spritePath and love.filesystem.getInfo(data.spritePath)) then
            data.spritePath = "assets/sprites/missing.png"
        end

        if not Module.imageCache[data.spritePath] then
            local drawable = love.graphics.newImage(data.spritePath)
            drawable:setFilter("nearest", "nearest")

            Module.imageCache[data.spritePath] = drawable
        end

        element.drawable = Module.imageCache[data.spritePath]
        element.spritePath = data.spritePath
    elseif data.type == "text" then
        if not data.font then
            data.font = love.graphics.newFont("assets/fonts/Stanberry.ttf")
        end
    end

    return element
end

function Module:getScaledDimensions(x, y)
    local currentWindowWidth, currentWindowHeight = love.graphics.getDimensions()
    local baseWindowWidth, baseWindowHeight = _G.WINDOW_WIDTH, _G.WINDOW_HEIGHT

    local windowScaleX = currentWindowWidth / baseWindowWidth
    local windowScaleY = currentWindowHeight / baseWindowHeight
    local windowScale = math.min(windowScaleX, windowScaleY)

    local offsetX = (currentWindowWidth - baseWindowWidth * windowScale) / 2
    local offsetY = (currentWindowHeight - baseWindowHeight * windowScale) / 2

    local virtualX = (x - offsetX) / windowScale
    local virtualY = (y - offsetY) / windowScale

    virtualX = math.max(0, math.min(baseWindowWidth, virtualX))
    virtualY = math.max(0, math.min(baseWindowHeight, virtualY))

    return virtualX, virtualY
end

function Module:getMousePos()
    local x, y = love.mouse.getPosition()
    return self:getScaledDimensions(x, y)
end

local function getSortOrder(element)
    return element.zIndex + ((element.id / 1000) % 1)
end

function Module:drawAll()
    if self._dirty then
        local elementsArray = {}
        for _, element in pairs(self._elements) do
            table.insert(elementsArray, element)
        end

        table.sort(elementsArray, function(a, b)
            return getSortOrder(a) < getSortOrder(b)
        end)

        self._sortedCache = elementsArray
        self._dirty = false
    end

    local currentWindowWidth, currentWindowHeight = love.graphics.getDimensions()
    local baseWindowWidth, baseWindowHeight = _G.WINDOW_WIDTH, _G.WINDOW_HEIGHT

    local windowScaleFactorX = currentWindowWidth / baseWindowWidth
    local windowScaleFactorY = currentWindowHeight / baseWindowHeight
    local windowScaleFactor = math.min(windowScaleFactorX, windowScaleFactorY)

    local windowOffsetX = (currentWindowWidth - baseWindowWidth * windowScaleFactor) / 2
    local windowOffsetY = (currentWindowHeight - baseWindowHeight * windowScaleFactor) / 2

    love.graphics.setScissor(windowOffsetX, windowOffsetY, baseWindowWidth * windowScaleFactor, baseWindowHeight * windowScaleFactor)

    local accessibility = SettingsModule.loadedFile.accessibility
    local graphics = SettingsModule.loadedFile.graphics

    local shader = ShaderModule:get("accessibility")

    shader:send("contrast", graphics.contrast)
    shader:send("gamma", graphics.gamma)

    shader:send(
        "enableColorblind",
        accessibility.colorblindMode ~= "none"
    )

    if accessibility.colorblindMode ~= "none" then
        shader:send(
            "colorMatrix",
            ColorblindData[accessibility.colorblindMode]
        )
    end

    love.graphics.setShader(shader)

    for _, element in ipairs(self._sortedCache) do
        if not element.render then goto continue end
        element:draw(windowScaleFactor, windowOffsetX, windowOffsetY)

        :: continue ::
    end

    love.graphics.setScissor()
    love.graphics.setShader()
end

function Module:init()
    ShaderModule:load(
        "accessibility",
        "code/data/shaders/accessibility.glsl"
    )
end

return Module