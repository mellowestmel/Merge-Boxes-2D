-- ~/code/engine/render/element.lua

local math = require("code.engine.helpers.math")

local RenderUtilsModule = require("code.engine.render.utils")
local IdManagerModule = require("code.engine.idManager")

local Module = {}

-- Shared sprite cache and active element registry.
Module.imageCache = {}
Module._elements = {}

local manager = IdManagerModule:CreateManager()

-- Default properties shared by all elements.
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

    color = RenderUtilsModule.CreateColor(255, 255, 255),
    rotation = 0,

    reflective = false,
    render = true,
    flip = false,

    scissor = nil
}

Element.__index = Element

-- Removes the element and releases its ID.
function Element:Remove()
    Module._elements[self.id] = nil
    manager:release(self.id)
end

-- Returns the width and height of the element.
function Element:GetDimensions()
     if self.type == "sprite" and self.drawable then
        local width = self.drawable:getWidth() * self.scaleX
        local height = self.drawable:getHeight() * self.scaleY

        return width, height

    elseif self.type == "text" and self.text then
        local font = (self.font or love.graphics.getFont())

        local width = font:getWidth() * self.scaleX
        local height = font:getHeight() * self.scaleY

        return width, height
    end
end

-- Checks if a point is inside the element.
function Element:IsPointInside(x, y)
    -- Skip if the point is outside the scissor area.
    if self.scissor and (
        x < self.scissor.x or
        x > self.scissor.x + self.scissor.width or
        y < self.scissor.y or
        y > self.scissor.y + self.scissor.height
    ) then
        return false
    end

    local width, height = self:getDimensions()

    -- Get offset from the element's position to the point.
    local deltaX = x - (self.x + self.offsetX)
    local deltaY = y - (self.y + self.offsetY)

    local radians = RenderUtilsModule.GetRotationInRadians(self)

    -- Undo the rotation so we can work with a flat box.
    local cosine = math.cos(-radians)
    local sine = math.sin(-radians)

    local localX = deltaX * cosine - deltaY * sine
    local localY = deltaX * sine + deltaY * cosine

    -- Check if the point is inside the box boundaries.
    return localX >= -width * self.anchorX
       and localX <= width * (1 - self.anchorX)
       and localY >= -height * self.anchorY
       and localY <= height * (1 - self.anchorY)
end

function Element:Draw(windowScaleFactor, windowOffsetX, windowOffsetY)
    if not self.render then return end

    -- Default scale to 1 if no scaling arguments are passed
    windowScaleFactor = windowScaleFactor or 1
    windowOffsetX = windowOffsetX or 0
    windowOffsetY = windowOffsetY or 0

    -- Calculate scaled screen coordinates
    local positionX = self.x * windowScaleFactor + windowOffsetX + self.offsetX
    local positionY = self.y * windowScaleFactor + windowOffsetY + self.offsetY

    local scaleX = self.scaleX * (self.flip and -1 or 1) * windowScaleFactor
    local scaleY = self.scaleY * windowScaleFactor
    local radians = RenderUtilsModule.GetRotationInRadians(self)

    -- Set element color with fallback protection
    if self.color then love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.alpha or self.color.a or 1)
    else love.graphics.setColor(1, 1, 1, 1) end

    -- Apply scaled scissor cropping
    if self.scissor then
        local scissorX = self.scissor.x * windowScaleFactor + windowOffsetX
        local scissorY = self.scissor.y * windowScaleFactor + windowOffsetY

        local scissorWidth = self.scissor.width * windowScaleFactor
        local scissorHeight = self.scissor.height * windowScaleFactor

        love.graphics.setScissor(scissorX, scissorY, scissorWidth, scissorHeight)
    end

    if self.type == "sprite" and self.drawable then
        local originX = self.drawable:getWidth() * self.anchorX
        local originY = self.drawable:getHeight() * self.anchorY

        -- Handle sprite reflection mapping
        if self.reflective and self.reflectionPath and self.reflectionPath ~= "" then
            if not Module.imageCache[self.reflectionPath] then
                Module.imageCache[self.reflectionPath] = love.graphics.newImage(self.reflectionPath)
            end

            local reflectionImage = Module.imageCache[self.reflectionPath]
            local imageWidth, imageHeight = reflectionImage:getWidth(), reflectionImage:getHeight()

            local boxWidth = self.drawable:getWidth() * self.scaleX
            local boxHeight = self.drawable:getHeight() * self.scaleY
            local boxLeft = self.x - self.drawable:getWidth() * self.anchorX
            local boxTop = self.y - self.drawable:getHeight() * self.anchorY

            local reflectionX = boxLeft / _G.RESOLUTION_WIDTH * imageWidth - (boxLeft / 4)
            local reflectionY = boxTop / _G.RESOLUTION_HEIGHT * imageHeight - (boxTop / 4)

            local reflectionWidth = boxWidth / _G.RESOLUTION_WIDTH * imageWidth
            local reflectionHeight = boxHeight / _G.RESOLUTION_HEIGHT * imageHeight

            local reflectionQuad = love.graphics.newQuad(
                reflectionX, reflectionY,
                reflectionWidth, reflectionHeight,
                imageWidth, imageHeight
            )

            love.graphics.setColor(1, 1, 1, (self.color and (self.color.alpha or self.color.a)) or 1)
            love.graphics.draw(
                reflectionImage, reflectionQuad,
                positionX, positionY,
                math.rad(self.rotation),
                windowScaleFactor, windowScaleFactor,
                boxWidth / 2, boxHeight / 2
            )
        end

        love.graphics.draw(self.drawable, positionX, positionY, radians, scaleX, scaleY, originX, originY)

    elseif self.type == "text" and self.text and self.text ~= "" then
        local font = self.font or love.graphics.getFont()
        love.graphics.setFont(font)

        local drawX = positionX - font:getWidth(self.text) * scaleX * self.anchorX
        local drawY = positionY - font:getHeight() * scaleY * self.anchorY

        love.graphics.print(self.text, drawX, drawY, radians, scaleX, scaleY)
    end

    -- Reset scissor back to the main viewport bounding box (or turn off if unscaled)
    if self.scissor then
        if windowScaleFactor ~= 1 or windowOffsetX ~= 0 or windowOffsetY ~= 0 then
            local baseWindowWidth, baseWindowHeight = _G.RESOLUTION_WIDTH, _G.RESOLUTION_HEIGHT
            love.graphics.setScissor(windowOffsetX, windowOffsetY, baseWindowWidth * windowScaleFactor, baseWindowHeight * windowScaleFactor)
        else
            love.graphics.setScissor()
        end
    end
end

-- Creates and registers a new sprite or text element.
function Module.new(data)
    data = data or {}

    local element = setmetatable({
        id = manager:Get(),
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

        reflectionPath = data.reflectionPath or "",
        reflective = data.reflective or false,

        render = data.render ~= false,
        flip = data.flip or false,

        scissor = data.scissor
    }, Element)

    if element.type == "sprite" then
        -- Fallback image
        local path = data.spritePath or "assets/sprites/missing.png"

        -- Load the sprite, or take the cached drawable.
        if not Module.imageCache[path] then
            local drawable = love.graphics.newImage(path)
            drawable:setFilter("nearest", "nearest")

            Module.imageCache[path] = drawable
        end

        element.drawable = Module.imageCache[path]
        element.spritePath = path

    elseif not element.font then
        -- Use the default font
        element.font = love.graphics.newFont("assets/fonts/Stanberry.ttf")
    end

    Module._elements[element.id] = element

    return element
end

return Module