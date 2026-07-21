-- ~/code/game/box/scaleTween.lua

--// SAVES \\--
local SettingsModule = require("code.engine.saves.settings")

--// HELPERS \\--
local easing = require("code.engine.helpers.easing")
local math = require("code.engine.helpers.math")

--// BOX \\--
local BoxesObjectModule = require("code.game.box.object")

local Module = {}

function Module:update(deltaTime)
    local animationsEnabled = SettingsModule.loadedFile.graphics.animationsEnabled
    if not animationsEnabled then return end

    local boxesArray = BoxesObjectModule:getSortedArray()
    local boxesCount = #boxesArray

    for index = 1, boxesCount do
        local box = boxesArray[index]
        local tween = box._scaleTween
        
        if tween then
            tween.timeSinceStart = tween.timeSinceStart + deltaTime

            local timerLocalized = math.min(tween.timeSinceStart / tween.duration, 1)
            local lerpFactor = easing.easeOutQuad(timerLocalized)

            box.element.scaleX = math.lerp(tween.startX, tween.targetX, lerpFactor)
            box.element.scaleY = math.lerp(tween.startY, tween.targetY, lerpFactor)

            if timerLocalized >= 1 then
                box._scaleTween = nil
            end
        end
    end
end

return Module