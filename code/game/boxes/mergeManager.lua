-- ~/code/game/box/mergeManager.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")

local QuadtreeModule = require("code.engine.quadtree")

local SoundHandlerModule = require("code.engine.soundHandler")
local TweenHandlerModule = require("code.engine.tweenHandler")

local SaveFilesModule = require("code.engine.saves.files")
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

        if not baseScale or scale < baseScale then baseScale = scale end
        if not maxScale or scale > maxScale then maxScale = scale end
    end

    return baseScale or 1, maxScale or baseScale or 1
end

local BASE_SCALE, MAX_SCALE = _calculateScaleRange()

local function _getMergeRange(boxA, boxB)
    local averageScale = (boxA.element.scaleX + boxB.element.scaleX) / 2
    return CONSTANTS.BASE_MERGE_RANGE * (averageScale / BASE_SCALE)
end

local maxMergeQueryRadius = CONSTANTS.BASE_MERGE_RANGE * ((MAX_SCALE * CONSTANTS.SPAWN_SCALE_MULTIPLIER) / BASE_SCALE)

local function _createQuadtree()
    return QuadtreeModule.new({
        x = 0,
        y = 0,
        width = CONSTANTS.AREA_WIDTH,
        height = CONSTANTS.AREA_HEIGHT
    })
end

function Module:Merge(boxA, boxB)
    if boxA.dragging or boxB.dragging then return end
    if boxA.merging or boxB.merging then return end
    if boxA.data.tier ~= boxB.data.tier then return end

    local newBoxTier = boxA.data.tier + 1
    local newBoxData = BoxesObjectModule.GetBoxDataByTier(newBoxTier)

    if not newBoxData then return end

    SignalHandlerModule.Get("game.boxes.mergestarted"):Fire(boxA, boxB)

    boxA.merging = true
    boxB.merging = true

    local startAX, startAY = boxA.element.x, boxA.element.y
    local startBX, startBY = boxB.element.x, boxB.element.y
    local middleX, middleY = (startAX + startBX) / 2, (startAY + startBY) / 2
    local distance = math.distance2D(startAX, startAY, middleX, middleY)
    local averageWeight = (boxA.data.weight + boxB.data.weight) / 2

    local velocityMagnitude = math.sqrt(
        boxA.velocityX ^ 2 +
        boxA.velocityY ^ 2 +
        boxB.velocityX ^ 2 +
        boxB.velocityY ^ 2
    ) / 2

    local duration = (distance / CONSTANTS.BASE_MERGE_SPEED) * (1 + averageWeight / CONSTANTS.WEIGHT_ANIM_DURATION_DIVISOR)
    duration = duration / (1 + velocityMagnitude / CONSTANTS.VELOCITY_MERGE_DURATION_FACTOR)

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

function Module:MergeUpdate(deltaTime)
    for index = #self._activeMerges, 1, -1 do
        local merge = self._activeMerges[index]
        if not merge then goto continue end

        local boxA, boxB = merge.boxA, merge.boxB

        if not boxA or not boxB then
            table.remove(self._activeMerges, index)
            goto continue
        end

        if not boxA.element or not boxB.element then
            table.remove(self._activeMerges, index)
            goto continue
        end

        if boxA.dragging or boxB.dragging then
            boxA.merging = false
            boxB.merging = false
            table.remove(self._activeMerges, index)
            goto continue
        end

        merge.timeSinceStart = merge.timeSinceStart + deltaTime

        local timerLocalized = math.min(merge.timeSinceStart / merge.duration, 1)
        local eased = easing.easeInQuad(timerLocalized)

        boxA.element.x = math.lerp(merge.startAX, merge.middleX, eased)
        boxA.element.y = math.lerp(merge.startAY, merge.middleY, eased)
        boxB.element.x = math.lerp(merge.startBX, merge.middleX, eased)
        boxB.element.y = math.lerp(merge.startBY, merge.middleY, eased)

        if timerLocalized < 1 then goto continue end

        if not SaveFilesModule.loadedFile then
            boxA.merging = false
            boxB.merging = false
            table.remove(self._activeMerges, index)
            goto continue
        end

        local newBoxTier = boxA.data.tier + 1
        local newBoxData = BoxesObjectModule.GetBoxDataByTier(newBoxTier)

        if not newBoxData then
            boxA.merging = false
            boxB.merging = false
            table.remove(self._activeMerges, index)
            goto continue
        end

        local velocityX = (boxA.velocityX + boxB.velocityX) * CONSTANTS.ELASTICITY
        local velocityY = (boxA.velocityY + boxB.velocityY) * CONSTANTS.ELASTICITY
        local scaleX, scaleY = boxA.element.scaleX, boxA.element.scaleY
        local middleX, middleY = merge.middleX, merge.middleY

        boxA:Remove()
        boxB:Remove()

        local newBox = BoxesObjectModule.new(newBoxData)

        if newBox then
            newBox.element.x = middleX
            newBox.element.y = middleY

            newBox.velocityX = velocityX
            newBox.velocityY = velocityY

            SaveFilesModule.loadedFile.currencies.credits = SaveFilesModule.loadedFile.currencies.credits + newBox.data.mergeReward

            local animationsEnabled = SettingsModule.loadedFile.graphics.animationsEnabled

            if animationsEnabled then
                local targetScaleX, targetScaleY = newBox.data.scale, newBox.data.scale

                newBox.element.scaleX = scaleX
                newBox.element.scaleY = scaleY

                TweenHandlerModule.new(
                    newBox.element,
                    {scaleX = targetScaleX, scaleY = targetScaleY},
                    CONSTANTS.BASE_SCALE_TWEEN_DURATION * (1 + newBox.data.weight / CONSTANTS.WEIGHT_ANIM_DURATION_DIVISOR),
                    "easeOutQuad"
                )
            end

            if newBox.data.mergeSoundData then
                local mergeSound = SoundHandlerModule.new(newBox.data.mergeSoundData)

                if mergeSound then
                    mergeSound:Play()
                    mergeSound:Remove()
                end
            end

            if newBox.data.flashScreen then ScreenFlashModule:Flash(newBox.data.screenFlashColor) end
        end

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

        local nearbyPoints = tree:QueryRadius({x = boxA.element.x, y = boxA.element.y}, maxMergeQueryRadius)

        for pointIndex = 1, #nearbyPoints do
            local boxB = nearbyPoints[pointIndex].box

            if not boxB then goto continue end
            if boxB == boxA then goto continue end
            if boxB.merging then goto continue end
            if boxB.id < boxA.id then goto continue end
            if boxA.data.tier ~= boxB.data.tier then goto continue end

            local distance = math.distance2D(boxA.element.x, boxA.element.y, boxB.element.x, boxB.element.y)

            if distance <= _getMergeRange(boxA, boxB) then
                self:Merge(boxA, boxB)
                break
            end

            :: continue ::
        end

        :: continue ::
    end
end

function Module:Update(deltaTime)
    self:MergeUpdate(deltaTime)
    self:CheckMerges()
end

return Module