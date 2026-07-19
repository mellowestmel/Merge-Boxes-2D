-- ~/code/game/box/mergeManager.lua

--/// ENGINE \\\--
local SoundModule = require("code.engine.sound")
local QuadtreesModule = require("code.engine.quadtrees")

--// SAVES \\--
local SaveFilesModule = require("code.engine.saves.files")

--// HELPERS \\--
local easing = require("code.engine.helpers.easing")
local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

--// BOX \\--
local CONSTANTS = require("code.game.box.constants")
local BoxesObjectModule = require("code.game.box.object")

--// VFX \\--
local ScreenFlashModule = require("code.game.vfx.screenFlash")

--/// DATA \\\--
local BoxesData = require("code.data.boxes")

local Module = {}
Module._activeMerges = {}

function Module:merge(boxA, boxB)
    if boxA.dragging or boxB.dragging then return end
    if boxA.merging or boxB.merging then return end

    if #BoxesData < (boxA.tier + 1) then return end
    if boxA.tier ~= boxB.tier then return end

    boxA.merging = true
    boxB.merging = true

    local startAX, startAY = boxA.element.x, boxA.element.y
    local startBX, startBY = boxB.element.x, boxB.element.y

    local middleX = (startAX + startBX) / 2
    local middleY = (startAY + startBY) / 2

    local dx = middleX - startAX
    local dy = middleY - startAY
    local distance = math.sqrt(dx * dx + dy * dy)

    local averageWeight = (boxA.weight + boxB.weight) / 2
    local velocityMagnitude = math.sqrt(boxA.velocityX^2 + boxA.velocityY^2 + boxB.velocityX^2 + boxB.velocityY^2) / 2

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

function Module:mergeUpdate(deltaTime)
    for i = #self._activeMerges, 1, -1 do
        local merge = self._activeMerges[i]
        if not merge then goto continue end

        local boxA = merge.boxA
        local boxB = merge.boxB

        if not boxA or not boxB then
            table.remove(self._activeMerges, i)
            goto continue
        end

        if not boxA.element or not boxB.element then
            table.remove(self._activeMerges, i)
            goto continue
        end

        merge.timeSinceStart = merge.timeSinceStart + deltaTime

        if boxA.dragging or boxB.dragging then
            boxA.merging = false
            boxB.merging = false
            table.remove(self._activeMerges, i)
            goto continue
        end

        local timerLocalized = math.min(merge.timeSinceStart / merge.duration, 1)
        local eased = easing.easeInQuad(timerLocalized)

        boxA.element.x = math.lerp(merge.startAX, merge.middleX, eased)
        boxA.element.y = math.lerp(merge.startAY, merge.middleY, eased)
        boxB.element.x = math.lerp(merge.startBX, merge.middleX, eased)
        boxB.element.y = math.lerp(merge.startBY, merge.middleY, eased)

        if timerLocalized >= 1 then
            if not SaveFilesModule.loadedFile then
                boxA.merging = false
                boxB.merging = false
                table.remove(self._activeMerges, i)
                goto continue
            end

            local newBoxTier = boxA.tier + 1
            local newBoxData = BoxesObjectModule:getBoxDataByTier(newBoxTier)

            local velocityX = (boxA.velocityX + boxB.velocityX) * CONSTANTS.ELASTICITY
            local velocityY = (boxA.velocityY + boxB.velocityY) * CONSTANTS.ELASTICITY

            local scaleX = boxA.element.scaleX
            local scaleY = boxA.element.scaleY

            local middleX = merge.middleX
            local middleY = merge.middleY

            boxA:remove()
            boxB:remove()

            local newBox = BoxesObjectModule:createBox(newBoxData)

            if newBox then
                if SaveFilesModule.loadedFile.stats.highestBoxTier < newBoxTier then
                    SaveFilesModule.loadedFile.stats.highestBoxTier = newBoxTier
                end

                SaveFilesModule.loadedFile.currencies.credits =
                    SaveFilesModule.loadedFile.currencies.credits + newBox.mergeReward

                newBox.element.x = middleX
                newBox.element.y = middleY

                newBox.velocityX = velocityX
                newBox.velocityY = velocityY

                newBox._scaleTween = {
                    startX = scaleX,
                    startY = scaleY,
                    targetX = newBox.element.scaleX,
                    targetY = newBox.element.scaleY,
                    timeSinceStart = 0,
                    duration = CONSTANTS.BASE_SCALE_TWEEN_DURATION * (1 + newBox.weight / CONSTANTS.WEIGHT_ANIM_DURATION_DIVISOR)
                }

                newBox.element.scaleX = scaleX
                newBox.element.scaleY = scaleY

                local mergeSound = SoundModule:createSound(newBox.mergeSoundData)
                if mergeSound then
                    mergeSound:play()
                    mergeSound:remove()
                end

                if newBox.flashScreen then
                    ScreenFlashModule:flash(newBox.screenFlashColor)
                end
            end

            table.remove(self._activeMerges, i)
        end

        ::continue::
    end
end

local function getMergeRange(boxA, boxB)
    local avgScale = (boxA.element.scaleX + boxB.element.scaleX) / 2
    local baseScale = BoxesData[1].scale or 1

    return CONSTANTS.BASE_MERGE_RANGE * (avgScale / baseScale)
end

function Module:checkMerges()
    --%note TODO: optimize this with quadtrees
    local boxesArray = BoxesObjectModule:getSortedArray()
    local boxesCount = #boxesArray

    for indexA = 1, boxesCount do
        local boxA = boxesArray[indexA]
        if boxA.merging then goto continue end

        for indexB = 1, boxesCount do
            local boxB = boxesArray[indexB]

            if boxA.merging or boxB.merging then goto continue end
            if boxA.tier ~= boxB.tier then goto continue end
            if boxA == boxB then goto continue end

            local distanceX = boxA.element.x - boxB.element.x
            local distanceY = boxA.element.y - boxB.element.y
            local distance = math.sqrt(distanceX^2 + distanceY^2)

            local mergeRange = getMergeRange(boxA, boxB)
            if distance > mergeRange then goto continue end

            self:merge(boxA, boxB)

            :: continue ::
        end

        :: continue ::
    end
end

function Module:update(deltaTime)
    self:mergeUpdate(deltaTime)
    self:checkMerges()
end

return Module