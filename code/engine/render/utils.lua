-- ~/code/engine/render/utils.lua

local math = require("code.engine.helpers.math")

local Module = {}

-- Creates a color from a table or 4 r, g, b, a values
function Module.CreateColor(r, g, b, a)
    -- Accept a table: {r=, g=, b=, a=} or {r, g, b, a}
    if type(r) == "table" then
        local color = r

        r = color.r or color[1]
        g = color.g or color[2]
        b = color.b or color[3]
        a = color.a or color[4]
    end

    return {
        r = math.clamp(r or 255, 0, 255),
        g = math.clamp(g or 255, 0, 255),
        b = math.clamp(b or 255, 0, 255),
        a = math.clamp(a or 1, 0, 1)
    }
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