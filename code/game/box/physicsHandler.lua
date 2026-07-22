-- ~/code/game/box/physicsHandler.lua

local Module = {}

local RenderModule = require("code.engine.render")
local math = require("code.engine.helpers.math")

local CONSTANTS = require("code.game.box.constants")

local BoxDragHandlerModule = require("code.game.box.dragHandler")
local BoxesObjectModule = require("code.game.box.object")

local function getWeightFactor(box)
    return box.weight / CONSTANTS.BASE_WEIGHT
end

local function applyFriction(box, deltaTime)
    local fpsFactor = deltaTime * _G.FPS_SCALE
    local weightFactor = getWeightFactor(box)

    local friction = CONSTANTS.FRICTION * weightFactor

    box.velocityX = box.velocityX * (1 - friction * fpsFactor)
    box.velocityY = box.velocityY * (1 - friction * fpsFactor)
end

local function edgeBounceX(box)
    local width = box.element.drawable:getWidth() * box.element.scaleX
    local halfWidth = width * box.element.anchorX

    if box.element.x - halfWidth < 0 then
        box.element.x = halfWidth
        box.velocityX = -box.velocityX * CONSTANTS.ELASTICITY
    elseif box.element.x + width * (1 - box.element.anchorX) > CONSTANTS.AREA_WIDTH then
        box.element.x = CONSTANTS.AREA_WIDTH - width * (1 - box.element.anchorX)
        box.velocityX = -box.velocityX * CONSTANTS.ELASTICITY
    end
end

local function edgeBounceY(box)
    local height = box.element.drawable:getHeight() * box.element.scaleY
    local halfHeight = height * box.element.anchorY

    if box.element.y - halfHeight < 0 then
        box.element.y = halfHeight
        box.velocityY = -box.velocityY * CONSTANTS.ELASTICITY
    elseif box.element.y + height * (1 - box.element.anchorY) > CONSTANTS.AREA_HEIGHT then
        box.element.y = CONSTANTS.AREA_HEIGHT - height * (1 - box.element.anchorY)
        box.velocityY = -box.velocityY * CONSTANTS.ELASTICITY
    end
end

local function dragPhysics(box)
    if box.dragging then
        local mouseX, mouseY = RenderModule:getMousePos()

        mouseY = math.clamp(mouseY, 0, CONSTANTS.AREA_HEIGHT)
        mouseX = math.clamp(mouseX, 0, CONSTANTS.AREA_WIDTH)

        local weightFactor = math.max(getWeightFactor(box), .01)

        box.velocityX = (mouseX - box.element.x)
            * CONSTANTS.DRAG_VELOCITY_MULTIPLIER
            / weightFactor

        box.velocityY = (mouseY - box.element.y)
            * CONSTANTS.DRAG_VELOCITY_MULTIPLIER
            / weightFactor
    end
end

local function changePosition(box, deltaTime)
    local fpsFactor = deltaTime * _G.FPS_SCALE
    box.element.x = box.element.x + box.velocityX * fpsFactor
    box.element.y = box.element.y + box.velocityY * fpsFactor
end

function Module:update(deltaTime)
    if BoxDragHandlerModule.draggedBox then
        dragPhysics(BoxDragHandlerModule.draggedBox)
    end

    local boxesArray = BoxesObjectModule:getSortedArray()
    local boxesCount = #boxesArray

    for index = 1, boxesCount do
        local box = boxesArray[index]
        if box.merging then goto continue end

        changePosition(box, deltaTime)
        applyFriction(box, deltaTime)

        edgeBounceX(box)
        edgeBounceY(box)

        :: continue ::
    end
end

return Module