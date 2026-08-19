-- ~/code/game/box/rotationHandler.lua

local math = require("code.engine.helpers.math")

local CONSTANTS = require("code.game.boxes.constants")
local BoxesObjectModule = require("code.game.boxes.object")

local Module = {}

function Module:Update()
    local boxesArray = BoxesObjectModule:GetSortedArray()
    local boxesCount = #boxesArray

    for index = 1, boxesCount do
        local box = boxesArray[index]
        if box.merging then goto continue end

        if box.dragging then
            local targetRotation = box.velocityX * CONSTANTS.DRAG_ROTATION_MULTIPLIER
            targetRotation = math.max(-CONSTANTS.DRAGGING_MAX_TILT, math.min(CONSTANTS.DRAGGING_MAX_TILT, targetRotation))

            box.element.rotation = box.element.rotation + (targetRotation - box.element.rotation) * CONSTANTS.BASE_DRAGGING_TILT_SPEED
        else
            local velocity = (box.velocityX + box.velocityY) / 2
            box.element.rotation = box.element.rotation + velocity / CONSTANTS.FREE_ROTATION_VELOCITY_DIVISOR
        end

        :: continue ::
    end
end

return Module