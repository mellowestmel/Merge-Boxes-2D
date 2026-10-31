local Module = {}

local SavesFilesModule = require("src.engine.saves.files")
local RenderUtilsModule = require("src.engine.render.utils")

local BoxDragHandlerModule = require("src.game.boxes.dragHandler")
local BoxesObjectModule = require("src.game.boxes.object")

local function _getWeightFactor(box)
    return box.data.weight / CONSTANTS.BOX.PHYSICS.BASE_WEIGHT
end

local function _applyFriction(box, deltaTime)
    local fpsFactor = deltaTime * CONSTANTS.DISPLAY.FPS_SCALE
    local friction = CONSTANTS.BOX.PHYSICS.FRICTION

    local damping = math.max(0, 1 - friction * fpsFactor)

    if box.data.weight < 0 then
        damping = 1 / damping
    end

    box.velocityX = box.velocityX * damping
    box.velocityY = box.velocityY * damping
end

local function _edgeBounceX(box)
    local width = box.element:GetWidth()
    local halfWidth = width * box.element.anchorX

    if box.element.x - halfWidth < 0 then
        box.element.x = halfWidth
        box.velocityX = -box.velocityX * CONSTANTS.BOX.PHYSICS.ELASTICITY
    elseif box.element.x + width * (1 - box.element.anchorX) > CONSTANTS.BOX.AREA.WIDTH then
        box.element.x = CONSTANTS.BOX.AREA.WIDTH - width * (1 - box.element.anchorX)
        box.velocityX = -box.velocityX * CONSTANTS.BOX.PHYSICS.ELASTICITY
    end
end

local function _edgeBounceY(box)
    local height = box.element:GetHeight()
    local halfHeight = height * box.element.anchorY

    if box.element.y - halfHeight < 0 then
        box.element.y = halfHeight
        box.velocityY = -box.velocityY * CONSTANTS.BOX.PHYSICS.ELASTICITY
    elseif box.element.y + height * (1 - box.element.anchorY) > CONSTANTS.BOX.AREA.HEIGHT then
        box.element.y = CONSTANTS.BOX.AREA.HEIGHT - height * (1 - box.element.anchorY)
        box.velocityY = -box.velocityY * CONSTANTS.BOX.PHYSICS.ELASTICITY
    end
end

local function _dragPhysics(box)
    if not box.dragging then return end

    local mouseX, mouseY = RenderUtilsModule.GetScaledMousePosition()

    local dragMultiplier = SavesFilesModule:Get("stats.upgradeable.dragMultiplier")
    local weightFactor = _getWeightFactor(box)

    local currentMultiplier = CONSTANTS.BOX.DRAG.VELOCITY_MULTIPLIER * dragMultiplier

    local targetX = mouseX - box.dragOffsetX
    local targetY = mouseY - box.dragOffsetY

    local targetVelocityX = (targetX - box.element.x) * currentMultiplier / weightFactor
    local targetVelocityY = (targetY - box.element.y) * currentMultiplier / weightFactor

    box.velocityX = targetVelocityX
    box.velocityY = targetVelocityY
end

local function _changePosition(box, deltaTime)
    local fpsFactor = deltaTime * CONSTANTS.DISPLAY.FPS_SCALE

    box.element.x = box.element.x + box.velocityX * fpsFactor
    box.element.y = box.element.y + box.velocityY * fpsFactor
end

local function _rotationHandler(box, deltaTime)
    local fpsFactor = deltaTime * CONSTANTS.DISPLAY.FPS_SCALE

    if box.dragging then
        local width = box.element:GetWidth()
        local height = box.element:GetHeight()

        local offsetX = math.clamp(box.dragOffsetX / (width * .5), -1, 1)
        local offsetY = math.clamp(box.dragOffsetY / (height * .5), -1, 1)

        local horizontalRotation = (box.velocityX * CONSTANTS.BOX.DRAG.ROTATION_MULTIPLIER * -offsetY) * fpsFactor
        local verticalRotation = (box.velocityY * CONSTANTS.BOX.DRAG.ROTATION_MULTIPLIER * offsetX) * fpsFactor

        local targetRotation = horizontalRotation + verticalRotation
        targetRotation = math.clamp(targetRotation, -CONSTANTS.BOX.DRAG.MAX_TILT, CONSTANTS.BOX.DRAG.MAX_TILT)

        local result = box.element.rotation + (targetRotation - box.element.rotation) * CONSTANTS.BOX.DRAG.BASE_TILT_SPEED
        box.element.rotation = result
    else
        local velocity = ((box.velocityX + box.velocityY) / 2) * fpsFactor
        local result = box.element.rotation
            + velocity / CONSTANTS.BOX.PHYSICS.FREE_ROTATION_VELOCITY_DIVISOR

        box.element.rotation = result
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

        _rotationHandler(box, deltaTime)

        :: continue ::
    end
end

return Module