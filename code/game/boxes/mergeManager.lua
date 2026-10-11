-- ~/code/game/boxes/mergeManager.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")

local QuadtreeModule = require("code.engine.quadtree")

local SoundHandlerModule = require("code.engine.soundHandler")
local TweenHandlerModule = require("code.engine.tweenHandler")

local SavesFilesModule = require("code.engine.saves.files")

local easingData = require("code.data.easing")

local CONSTANTS = require("code.data.constants")
local BoxesObjectModule = require("code.game.boxes.object")

local ScreenFlashModule = require("code.game.vfx.screenFlash")

local BoxesData = require("code.data.boxes")

local Module = {}
Module._activeMerges = {}

--- Validates if two boxes meet the basic criteria to be considered for a merge.
local function _areBoxesEligible(boxA, boxB)
    return boxB ~= boxA
        and not boxA.merging
        and not boxB.merging
        and not boxA.dragging
        and not boxB.dragging
        and boxA.data.tier == boxB.data.tier
        and boxA.data.mergeable
        and boxB.data.mergeable
end

--- Validates full merge capability, including distance checks.
local function _canBoxesMerge(boxA, boxB, maxRange)
    if not _areBoxesEligible(boxA, boxB) then return false end

    local distance = math.distance2D(
        boxA.element.x,
        boxA.element.y,
        boxB.element.x,
        boxB.element.y
    )

    return distance <= maxRange
end

local function _getMaxBoxScale()
    local maxScale = 1

    for _, boxData in pairs(BoxesData) do
        maxScale = math.max(maxScale, boxData.scale or 1)
    end

    return maxScale
end

local function _getMergeRange(boxA, boxB)
    local averageScale = (boxA.element.scaleX + boxB.element.scaleX) / 2
    return CONSTANTS.BOX.MERGE.BASE_RANGE * averageScale
end

local MAX_MERGE_RANGE =
    CONSTANTS.BOX.MERGE.BASE_RANGE * _getMaxBoxScale()

local function _createQuadtree()
    return QuadtreeModule.new({
        x = 0,
        y = 0,

        width = CONSTANTS.BOX.AREA.WIDTH,
        height = CONSTANTS.BOX.AREA.HEIGHT
    })
end

local function _cancelMerge(index, boxA, boxB)
    boxA.merging = false
    boxB.merging = false

    table.remove(Module._activeMerges, index)
end

function Module:Merge(boxA, boxB)
    if not _areBoxesEligible(boxA, boxB) then return end

    local newBoxData = BoxesObjectModule.GetBoxDataByTier(boxA.data.tier + 1)

    SignalHandlerModule.Get("game.boxes.mergestarted"):Fire(boxA, boxB)

    boxA.merging = true
    boxB.merging = true

    local startAX, startAY = boxA.element.x, boxA.element.y
    local startBX, startBY = boxB.element.x, boxB.element.y

    local middleX = (startAX + startBX) / 2
    local middleY = (startAY + startBY) / 2

    local distance = math.distance2D(
            startAX,
            startAY,

            middleX,
            middleY
        )

    local averageWeight = (boxA.data.weight + boxB.data.weight) / 2

    local velocityMagnitude = math.sqrt(
        boxA.velocityX ^ 2
            + boxA.velocityY ^ 2
            + boxB.velocityX ^ 2
            + boxB.velocityY ^ 2
    ) / 2

    local weightDurationMultiplier = math.max(.1, 1 + averageWeight / CONSTANTS.BOX.ANIMATION.WEIGHT_ANIM_DURATION_DIVISOR)
    local velocityDurationMultiplier = 1 + velocityMagnitude / CONSTANTS.BOX.MERGE.VELOCITY_DURATION_FACTOR

    local duration = (distance / CONSTANTS.BOX.MERGE.BASE_SPEED) * weightDurationMultiplier / velocityDurationMultiplier

    -- Make sure merge has an actual duration so it works
    duration = math.max(duration, CONSTANTS.BOX.MERGE.MIN_DURATION)

    table.insert(self._activeMerges, {
        boxA = boxA,
        boxB = boxB,

        startAX = startAX,
        startAY = startAY,

        startBX = startBX,
        startBY = startBY,

        middleX = middleX,
        middleY = middleY,

        timeSinceStart = 0,
        duration = duration
    })
end

-- Spawns the merged box, grants rewards, and plays its merge fx.
local function _spawnMergedBox(boxA, boxB, newBoxData, middleX, middleY)
    local velocityX = (boxA.velocityX + boxB.velocityX) * CONSTANTS.BOX.PHYSICS.ELASTICITY
    local velocityY = (boxA.velocityY + boxB.velocityY) * CONSTANTS.BOX.PHYSICS.ELASTICITY

    local scaleX, scaleY = boxA.element.scaleX, boxA.element.scaleY

    boxA:Remove() boxB:Remove()

    local newBox = BoxesObjectModule.new(newBoxData)

    newBox.element.x = middleX
    newBox.element.y = middleY

    newBox.velocityX = velocityX
    newBox.velocityY = velocityY

    local credits = SavesFilesModule:Get("currencies.credits")

    SavesFilesModule:Set("currencies.credits", credits + newBox.data.mergeReward)

    newBox.element.scaleX = scaleX
    newBox.element.scaleY = scaleY

    TweenHandlerModule.new(
        newBox.element,

        {
            scaleX = newBox.data.scale,
            scaleY = newBox.data.scale
        },

        CONSTANTS.BOX.ANIMATION.BASE_SCALE_TWEEN_DURATION * (1 + newBox.data.weight / CONSTANTS.BOX.ANIMATION.WEIGHT_ANIM_DURATION_DIVISOR),
        "easeOutQuad"
    )

    if newBox.data.mergeSoundData then
        SoundHandlerModule.new(newBox.data.mergeSoundData):Play(true)
    end

    if newBox.data.flashScreen then
        ScreenFlashModule:Flash(
            newBox.data.screenFlashColor,
            newBox.data.screenFlashFadeDuration
        )
    end

    return newBox
end

function Module:MergeUpdate(deltaTime)
    for index = #self._activeMerges, 1, -1 do
        local merge = self._activeMerges[index]
        local boxA, boxB = merge.boxA, merge.boxB

        if boxA.dragging or boxB.dragging then
            _cancelMerge(index, boxA, boxB)
            goto continue
        end

        merge.timeSinceStart = merge.timeSinceStart + deltaTime

        local progress = math.min(merge.timeSinceStart / merge.duration, 1)
        local eased = easingData.easeInQuad(progress)

        -- Larp towards the middle
        boxA.element.x = math.lerp(merge.startAX, merge.middleX, eased)
        boxA.element.y = math.lerp(merge.startAY, merge.middleY, eased)

        boxB.element.x = math.lerp(merge.startBX, merge.middleX, eased)
        boxB.element.y = math.lerp(merge.startBY, merge.middleY, eased)

        if progress < 1 then goto continue end

        local newBoxData = BoxesObjectModule.GetBoxDataByType(boxA.data.next)

        local newBox = _spawnMergedBox(boxA, boxB, newBoxData, merge.middleX, merge.middleY)
        SignalHandlerModule.Get("game.boxes.mergecompleted"):Fire(newBox, boxA, boxB)

        table.remove(self._activeMerges, index)

        :: continue ::
    end
end

function Module:CheckMerges()
    local boxes = BoxesObjectModule:GetSortedArray()

    local tree = _createQuadtree()

    for index = 1, #boxes do
        local box = boxes[index]

        if not box.merging then
            tree:Insert({
                x = box.element.x,
                y = box.element.y,

                box = box
            })
        end
    end

    for index = 1, #boxes do
        local boxA = boxes[index]
        if boxA.merging then goto continue end

        local nearbyPoints = tree:QueryRadius(
                {
                    x = boxA.element.x,
                    y = boxA.element.y
                },

                MAX_MERGE_RANGE
            )

        for index = 1, #nearbyPoints do
            local boxB = nearbyPoints[index].box
            local mergeRange = _getMergeRange(boxA, boxB)

            if _canBoxesMerge(boxA, boxB, mergeRange) then
                self:Merge(boxA, boxB)
                break
            end
        end

        :: continue ::
    end
end

function Module:Update(deltaTime)
    self:MergeUpdate(deltaTime)
    self:CheckMerges()
end

return Module