-- ~/code/game/box/rotationHandler.lua

--// SAVES \\--
local SettingsModule = require("code.engine.saves.settings")

--// HELPERS \\--
local math = require("code.engine.helpers.math")

--// BOX \\--
local CONSTANTS = require("code.game.box.constants")
local BoxesObjectModule = require("code.game.box.object")

local Module = {}

function Module:update()
    local boxesArray = BoxesObjectModule:getSortedArray()
    local boxesCount = #boxesArray

    for index = 1, boxesCount do
        local box = boxesArray[index]
        if box.merging then goto continue end

        if box.dragging then
            local targetRotation = box.velocityX * CONSTANTS.DRAG_ROTATION_MULTIPLIER
            targetRotation = math.max(-CONSTANTS.DRAGGING_MAX_TILT, math.min(CONSTANTS.DRAGGING_MAX_TILT, targetRotation))

            box.element:setRotation(box.element.rotation + (targetRotation - box.element.rotation) * CONSTANTS.BASE_DRAGGING_TILT_SPEED)
        else
            local velocity = (box.velocityX + box.velocityY) / 2
            box.element:setRotation(math.deg(box.element.rotation) + velocity / CONSTANTS.FREE_ROTATION_VELOCITY_DIVISOR)
        end

        :: continue ::
    end
end

return Module