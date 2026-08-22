-- ~/code/game/boxes/mergeManager.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")

local QuadtreeModule = require("code.engine.quadtree")

local SoundHandlerModule = require("code.engine.soundHandler")
local TweenHandlerModule = require("code.engine.tweenHandler")

local SavesFilesModule = require("code.engine.saves.files")
local SettingsModule = require("code.engine.saves.settings")

local easing = require("code.engine.helpers.easing")
local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

local CONSTANTS = require("code.game.boxes.constants")
local BoxesObjectModule = require("code.game.boxes.object")

local ScreenFlashModule = require("code.game.vfx.screenFlash")

local BoxesData = require("code.data.boxes")

local Module = {}
Module._activeMerges = {}

local function _calculateScaleRange()
    local baseScale, maxScale

    for _, boxData in pairs(BoxesData) do
        local scale = boxData.scale or 1

        if not baseScale or scale < baseScale then
            baseScale = scale
        end

        if not maxScale or scale > maxScale then
            maxScale = scale
        end
    end

    return baseScale or 1, maxScale or baseScale or 1
end

local BASE_SCALE, MAX_SCALE = _calculateScaleRange()

local function _getMergeRange(boxA, boxB)
    local averageScale =
        (boxA.element.scaleX + boxB.element.scaleX) / 2

    return CONSTANTS.BASE_MERGE_RANGE
        * (averageScale / BASE_SCALE)
end

local maxMergeQueryRadius =
    CONSTANTS.BASE_MERGE_RANGE
    * ((MAX_SCALE * CONSTANTS.SPAWN_SCALE_MULTIPLIER) / BASE_SCALE)

local function _createQuadtree()
    return QuadtreeModule.new({
        x = 0,
        y = 0,
        width = CONSTANTS.AREA_WIDTH,
        height = CONSTANTS.AREA_HEIGHT
    })
end

-- Cancels an in-progress merge and drops it from the active list.
-- Safe to call with a nil box (e.g. one already removed elsewhere).
local function _cancelMerge(activeMerges, index, boxA, boxB)
    if boxA then
        boxA.merging = false
    end

    if boxB then
        boxB.merging = false
    end

    table.remove(activeMerges, index)
end

function Module:Merge(boxA, boxB)
    if boxA.dragging
        or boxB.dragging
        or boxA.merging
        or boxB.merging
        or boxA.data.tier ~= boxB.data.tier
        or not boxA.data.mergeable
        or not boxB.data.mergeable
    then
        return
    end

    local newBoxData =
        BoxesObjectModule.GetBoxDataByTier(boxA.data.tier + 1)

    if not newBoxData then
        return
    end

    SignalHandlerModule.Get("game.boxes.mergestarted"):Fire(boxA, boxB)

    boxA.merging = true
    boxB.merging = true

    local startAX, startAY = boxA.element.x, boxA.element.y
    local startBX, startBY = boxB.element.x, boxB.element.y

    local middleX =
        (startAX + startBX) / 2

    local middleY =
        (startAY + startBY) / 2

    local distance =
        math.distance2D(
            startAX,
            startAY,
            middleX,
            middleY
        )

    local averageWeight =
        (boxA.data.weight + boxB.data.weight) / 2

    local velocityMagnitude = math.sqrt(
        boxA.velocityX ^ 2
            + boxA.velocityY ^ 2
            + boxB.velocityX ^ 2
            + boxB.velocityY ^ 2
    ) / 2

    -- Negative weight can otherwise reduce this multiplier to zero
    -- or below, causing the merge duration to become invalid.
    local weightDurationMultiplier = math.max(
        .1,
        1 + averageWeight
            / CONSTANTS.WEIGHT_ANIM_DURATION_DIVISOR
    )

    local velocityDurationMultiplier =
        1 + velocityMagnitude
            / CONSTANTS.VELOCITY_MERGE_DURATION_FACTOR

    local duration =
        (distance / CONSTANTS.BASE_MERGE_SPEED)
        * weightDurationMultiplier
        / velocityDurationMultiplier

    -- Always guarantee that the merge has a valid positive duration.
    duration = math.max(duration, .001)

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
-- newBoxData must already be known to exist (caller checked GetBoxDataByTier).
local function _spawnMergedBox(
    boxA,
    boxB,
    newBoxData,
    middleX,
    middleY
)
    local velocityX =
        (boxA.velocityX + boxB.velocityX)
        * CONSTANTS.ELASTICITY

    local velocityY =
        (boxA.velocityY + boxB.velocityY)
        * CONSTANTS.ELASTICITY

    local scaleX, scaleY =
        boxA.element.scaleX,
        boxA.element.scaleY

    boxA:Remove()
    boxB:Remove()

    local newBox = BoxesObjectModule.new(newBoxData)

    if not newBox then
        return nil
    end

    newBox.element.x = middleX
    newBox.element.y = middleY

    newBox.velocityX = velocityX
    newBox.velocityY = velocityY

    local credits =
        SavesFilesModule:Get("currencies.credits")

    SavesFilesModule:Set(
        "currencies.credits",
        credits + newBox.data.mergeReward
    )

    newBox.element.scaleX = scaleX
    newBox.element.scaleY = scaleY

    TweenHandlerModule.new(
        newBox.element,
        {
            scaleX = newBox.data.scale,
            scaleY = newBox.data.scale
        },
        CONSTANTS.BASE_SCALE_TWEEN_DURATION
            * (
                1
                + newBox.data.weight
                    / CONSTANTS.WEIGHT_ANIM_DURATION_DIVISOR
            ),
        "easeOutQuad"
    )

    if newBox.data.mergeSoundData then
        local mergeSound =
            SoundHandlerModule.new(newBox.data.mergeSoundData)

        if mergeSound then
            mergeSound:Play()
            mergeSound:Remove()
        end
    end

    if newBox.data.flashScreen then
        ScreenFlashModule:Flash(
            newBox.data.screenFlashColor
        )
    end

    return newBox
end

function Module:MergeUpdate(deltaTime)
    for index = #self._activeMerges, 1, -1 do
        local merge = self._activeMerges[index]

        if not merge then
            goto continue
        end

        local boxA, boxB =
            merge.boxA,
            merge.boxB

        if not (
            boxA
            and boxB
            and boxA.element
            and boxB.element
        ) then
            _cancelMerge(
                self._activeMerges,
                index,
                boxA,
                boxB
            )

            goto continue
        end

        if boxA.dragging or boxB.dragging then
            _cancelMerge(
                self._activeMerges,
                index,
                boxA,
                boxB
            )

            goto continue
        end

        merge.timeSinceStart =
            merge.timeSinceStart + deltaTime

        local progress =
            math.min(
                merge.timeSinceStart / merge.duration,
                1
            )

        local eased =
            easing.easeInQuad(progress)

        boxA.element.x =
            math.lerp(
                merge.startAX,
                merge.middleX,
                eased
            )

        boxA.element.y =
            math.lerp(
                merge.startAY,
                merge.middleY,
                eased
            )

        boxB.element.x =
            math.lerp(
                merge.startBX,
                merge.middleX,
                eased
            )

        boxB.element.y =
            math.lerp(
                merge.startBY,
                merge.middleY,
                eased
            )

        if progress < 1 then
            goto continue
        end

        local newBoxData =
            SavesFilesModule.loadedFile
            and BoxesObjectModule.GetBoxDataByType(
                boxA.data.next
            )

        if not newBoxData then
            _cancelMerge(
                self._activeMerges,
                index,
                boxA,
                boxB
            )

            goto continue
        end

        local newBox =
            _spawnMergedBox(
                boxA,
                boxB,
                newBoxData,
                merge.middleX,
                merge.middleY
            )

        SignalHandlerModule.Get(
            "game.boxes.mergecompleted"
        ):Fire(
            newBox,
            boxA,
            boxB
        )

        table.remove(
            self._activeMerges,
            index
        )

        :: continue ::
    end
end

function Module:CheckMerges()
    local boxes =
        BoxesObjectModule:GetSortedArray()

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

        if boxA.merging then
            goto continue
        end

        local nearbyPoints =
            tree:QueryRadius(
                {
                    x = boxA.element.x,
                    y = boxA.element.y
                },
                maxMergeQueryRadius
            )

        for pointIndex = 1, #nearbyPoints do
            local boxB =
                nearbyPoints[pointIndex].box

            local canMerge =
                boxB
                and boxB ~= boxA
                and not boxB.merging
                and boxB.id >= boxA.id
                and boxA.data.tier
                and boxA.data.tier == boxB.data.tier
                and boxA.data.mergeable
                and boxB.data.mergeable

            if canMerge then
                local distance =
                    math.distance2D(
                        boxA.element.x,
                        boxA.element.y,
                        boxB.element.x,
                        boxB.element.y
                    )

                if distance <= _getMergeRange(boxA, boxB) then
                    self:Merge(boxA, boxB)
                    break
                end
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