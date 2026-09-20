-- ~/code/game/ui/helpers/layout.lua

local Module = {}

--- Calculates a vertical stack coordinate based on an index and item spacing.
function Module.GetVerticalStackY(basePositionY, index, itemSpacing)
    basePositionY = basePositionY or 0
    itemSpacing = itemSpacing or 0
    return basePositionY + ((index - 1) * itemSpacing)
end

--- Calculates a horizontal stack coordinate based on an index and item spacing.
function Module.GetHorizontalStackX(basePositionX, index, itemSpacing)
    basePositionX = basePositionX or 0
    itemSpacing = itemSpacing or 0
    return basePositionX + ((index - 1) * itemSpacing)
end

--- Positions a list of elements vertically with consistent spacing.
function Module.StackVertically(elements, startPositionY, itemSpacing)
    for index, element in pairs(elements) do
        if element then
            element.y = Module.GetVerticalStackY(startPositionY, index, itemSpacing)
        end
    end
end

--- Positions a list of elements horizontally with consistent spacing.
function Module.StackHorizontally(elements, startPositionX, itemSpacing)
    for index, element in pairs(elements) do
        if element then
            element.x = Module.GetHorizontalStackX(startPositionX, index, itemSpacing)
        end
    end
end

--- Lays out elements in a centered row within given bounds.
function Module:LayoutRow(elements, options)
    options = options or {}
    local itemSpacing = options.spacing or 0
    local layoutBounds = options.bounds or {
        x = 0,
        y = 0,

        width = RESOLUTION_WIDTH or 800,
        height = RESOLUTION_HEIGHT or 600
    }

    if #elements == 0 then return end

    -- Determine element width from drawable or fallback width property
    local firstElement = elements[1]
    local elementWidth = 0

    if firstElement.drawable and firstElement.drawable.getWidth then
        elementWidth = firstElement.drawable:getWidth()
    elseif firstElement.getWidth then
        elementWidth = firstElement:getWidth()
    else
        elementWidth = firstElement.width or firstElement.w or 0
    end

    local totalWidth = (#elements * elementWidth) + ((#elements - 1) * itemSpacing)
    local boundsWidth = layoutBounds.width or layoutBounds.w or 0
    local boundsPositionX = layoutBounds.x or 0
    local startPositionX = boundsPositionX + (boundsWidth - totalWidth) / 2 + (elementWidth / 2)

    for index, element in pairs(elements) do
        if element then
            element.x = startPositionX + ((index - 1) * (elementWidth + itemSpacing))
        end
    end
end

--- Calculates 2D grid coordinates for a given item index.
function Module.GetGridPosition(index, columnCount, startPositionX, startPositionY, cellWidth, cellHeight)
    local column = (index - 1) % columnCount
    local row = math.floor((index - 1) / columnCount)

    local positionX = startPositionX + (column * cellWidth)
    local positionY = startPositionY + (row * cellHeight)

    return positionX, positionY
end

--- Wraps array index looping cleanly in both directions.
function Module.WrapIndex(currentIndex, stepDirection, maximumItems)
    if maximumItems <= 0 then return 1 end
    return ((currentIndex - 1 + stepDirection) % maximumItems) + 1
end

return Module