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

--[[
Shrinks `element` to fit inside `target` (never enlarges) by setting maxWidth/maxHeight.

padding: free space on each side. 
axis: "x" or "y" to fit one axis (use "x" for text).
]]--

function Module.FitToElement(element, target, padding, axis)
    padding = padding or 0

    local width, height = target:GetDimensions()

    local radians = math.rad(target.rotation or 0)
    local cosine, sine = math.abs(math.cos(radians)), math.abs(math.sin(radians))

    width, height =
        width * cosine + height * sine,
        width * sine + height * cosine

    -- maxWidth/maxHeight are compared before the element's own scale, so convert back.
    local scaleX = element.scaleX ~= 0 and element.scaleX or 1
    local scaleY = element.scaleY ~= 0 and element.scaleY or 1

    if axis ~= "y" then
        element.maxWidth = math.max(width - padding * 2, 0) / scaleX
    end

    if axis ~= "x" then
        element.maxHeight = math.max(height - padding * 2, 0) / scaleY
    end

    return element
end

--- Calculates screen scaling and letterbox offsets to preserve virtual resolution.
function Module.GetViewport()
    local currentWidth, currentHeight = love.graphics.getDimensions()
    local baseWidth, baseHeight = CONSTANTS.DISPLAY.RESOLUTION_WIDTH, CONSTANTS.DISPLAY.RESOLUTION_HEIGHT

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
    
    virtualX = math.clamp(baseWidth, 0, virtualX)
    virtualY = math.clamp(baseHeight, 0, virtualY)

    return virtualX, virtualY
end

function Module.GetScaledMousePosition()
    local x, y = love.mouse.getPosition()
    return Module.GetScaledDimensions(x, y)
end

return Module