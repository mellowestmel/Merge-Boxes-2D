-- ~/code/engine/render/utils.lua

local math = require("code.engine.helpers.math")

local Module = {}

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
    return Module.CreateColor(color[1], color[2], color[3], color[4])
end

--- Calculates screen scaling and letterbox offsets to preserve virtual resolution.
function Module.GetViewport()
    local currentWidth, currentHeight = love.graphics.getDimensions()
    local baseWidth, baseHeight = RESOLUTION_WIDTH, RESOLUTION_HEIGHT

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

function Module.GetScaledMousePosition()
    local x, y = love.mouse.getPosition()
    return Module.GetScaledDimensions(x, y)
end

return Module