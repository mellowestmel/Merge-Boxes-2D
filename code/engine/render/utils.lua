-- ~/code/engine/render/utils.lua

local math = require("code.engine.helpers.math")

local Module = {}

-- Converts rotation from degrees to radians, because love2d uses radians for some reason.
function Module.GetRotationInRadians(element)
    return math.rad(element.rotation * (element.flip and -1 or 1))
end

--- Normalizes RGBA values (0-255 -> 0.0-1.0).
function Module.CreateColor(r, g, b, alpha)
    return {
        r = (r or 255) / 255,
        g = (g or 255) / 255,
        b = (b or 255) / 255,
        alpha = alpha or 1
    }
end

--- Creates RGBA color object from a 1-4 index array.
function Module.CreateColorFromTable(color)
    return Module.createColor(color[1], color[2], color[3], color[4])
end

--- Calculates screen scaling and letterbox offsets to preserve virtual resolution.
function Module.GetViewport()
    local currentWidth, currentHeight = love.graphics.getDimensions()
    local baseWidth, baseHeight = _G.RESOLUTION_WIDTH, _G.RESOLUTION_HEIGHT

    local scaleX = currentWidth / baseWidth
    local scaleY = currentHeight / baseHeight
    local scale = math.min(scaleX, scaleY)

    local offsetX = (currentWidth - baseWidth * scale) / 2
    local offsetY = (currentHeight - baseHeight * scale) / 2

    return scale, offsetX, offsetY, baseWidth, baseHeight
end

--- Maps screen coordinates to internal virtual resolution bounds.
function Module.GetScaledDimensions(x, y)
    local scale, offsetX, offsetY, baseWidth, baseHeight = Module.GetViewport()

    local virtualX = (x - offsetX) / scale
    local virtualY = (y - offsetY) / scale

    virtualX = math.max(0, math.min(baseWidth, virtualX))
    virtualY = math.max(0, math.min(baseHeight, virtualY))

    return virtualX, virtualY
end

function Module.GetMousePos()
    local x, y = love.mouse.getPosition()
    return Module.GetScaledDimensions(x, y)
end

return Module