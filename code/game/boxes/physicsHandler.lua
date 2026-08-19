-- ~/code/game/box/physicsHandler.lua

local Module = {}

local RenderUtilsModule = require("code.engine.render.utils")
local math = require("code.engine.helpers.math")

local CONSTANTS = require("code.game.boxes.constants")

local BoxDragHandlerModule = require("code.game.boxes.dragHandler")
local BoxesObjectModule = require("code.game.boxes.object")

local function _getWeightFactor(box)
    return box.data.weight / CONSTANTS.BASE_WEIGHT
end

local function _applyFriction(box, deltaTime)
    local fpsFactor = deltaTime * FPS_SCALE
    local weightFactor = _getWeightFactor(box)

    local friction = CONSTANTS.FRICTION * weightFactor

    box.velocityX = box.velocityX * (1 - friction * fpsFactor)
    box.velocityY = box.velocityY * (1 - friction * fpsFactor)
end

local function _edgeBounceX(box)
    local width = box.element:GetWidth() * box.element.scaleX
    local halfWidth = width * box.element.anchorX

    if box.element.x - halfWidth < 0 then
        box.element.x = halfWidth
        box.velocityX = -box.velocityX * CONSTANTS.ELASTICITY
    elseif box.element.x + width * (1 - box.element.anchorX) > CONSTANTS.AREA_WIDTH then
        box.element.x = CONSTANTS.AREA_WIDTH - width * (1 - box.element.anchorX)
        box.velocityX = -box.velocityX * CONSTANTS.ELASTICITY
    end
end

local function _edgeBounceY(box)
    local height = box.element:GetHeight() * box.element.scaleY
    local halfHeight = height * box.element.anchorY

    if box.element.y - halfHeight < 0 then
        box.element.y = halfHeight
        box.velocityY = -box.velocityY * CONSTANTS.ELASTICITY
    elseif box.element.y + height * (1 - box.element.anchorY) > CONSTANTS.AREA_HEIGHT then
        box.element.y = CONSTANTS.AREA_HEIGHT - height * (1 - box.element.anchorY)
        box.velocityY = -box.velocityY * CONSTANTS.ELASTICITY
    end
end

local function _dragPhysics(box)
    if box.dragging then
        local mouseX, mouseY = RenderUtilsModule.GetScaledMousePosition()

        mouseY = math.clamp(mouseY, 0, CONSTANTS.AREA_HEIGHT)
        mouseX = math.clamp(mouseX, 0, CONSTANTS.AREA_WIDTH)

        local weightFactor = math.max(_getWeightFactor(box), .01)

        box.velocityX = (mouseX - box.element.x) * CONSTANTS.DRAG_VELOCITY_MULTIPLIER / weightFactor
        box.velocityY = (mouseY - box.element.y) * CONSTANTS.DRAG_VELOCITY_MULTIPLIER / weightFactor
    end
end

local function _changePosition(box, deltaTime)
    local fpsFactor = deltaTime * FPS_SCALE

    box.element.x = box.element.x + box.velocityX * fpsFactor
    box.element.y = box.element.y + box.velocityY * fpsFactor
end

local function _rotationHandler(box)
    if box.dragging then
        local targetRotation = box.velocityX * CONSTANTS.DRAG_ROTATION_MULTIPLIER
        targetRotation = math.max(-CONSTANTS.DRAGGING_MAX_TILT, math.min(CONSTANTS.DRAGGING_MAX_TILT, targetRotation))

        box.element.rotation = box.element.rotation + (targetRotation - box.element.rotation) * CONSTANTS.BASE_DRAGGING_TILT_SPEED
    else
        local velocity = (box.velocityX + box.velocityY) / 2
        box.element.rotation = box.element.rotation + velocity / CONSTANTS.FREE_ROTATION_VELOCITY_DIVISOR
    end
end

function Module:Update(deltaTime)
    if BoxDragHandlerModule.draggedBox then
        _dragPhysics(BoxDragHandlerModule.draggedBox)
    end

    local boxesArray = BoxesObjectModule:GetSortedArray()
    local boxesCount = #boxesArray

    for index = 1, boxesCount do
        local box = boxesArray[index]
        if box.merging then goto continue end

        _changePosition(box, deltaTime)
        _applyFriction(box, deltaTime)

        _edgeBounceX(box)
        _edgeBounceY(box)

        _rotationHandler(box)

        :: continue ::
    end
end

return Module