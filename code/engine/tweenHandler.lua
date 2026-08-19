-- ~/code/engine/tween.lua
-- Generic tween system, works on any table with numbers.

local SignalHandlerModule = require("code.engine.events.signalHandler")

local easing = require("code.engine.helpers.easing")
local math = require("code.engine.helpers.math")

local Module = {}
Module._active = {}

-- Accounts for float accumulation drift, so completion still triggers on time.
local COMPLETION_EPSILON = 1e-6

local Tween = {}
Tween.__index = Tween

-- Stops the tween where it currently is. Does not snap to the goal and does not fire onComplete.
function Tween:Cancel()
    self._cancelled = true
end

-- target: table whose fields will be animated (e.g. a RenderElement)
-- properties: { [propertyName] = goalValue, ... } e.g. { x = 100, rotation = 90 }
-- duration: seconds
-- easingName: looks into code.engine.helpers.easing (defaults to "linear")
-- onComplete: optional function called once the tween finishes naturally

function Module.new(target, properties, duration, easingName, onComplete)
    if not target or not properties then return end

    local startValues = {}
    for property in pairs(properties) do
        startValues[property] = target[property] or 0
    end

    local tween = setmetatable({
        target = target,

        startValues = startValues,
        goalValues = properties,

        duration = duration or 0.3,
        easingName = easingName or "linear",

        timeSinceStart = 0,
        onComplete = onComplete,

        _cancelled = false
    }, Tween)

    table.insert(Module._active, tween)

    return tween
end

function Module:Update(deltaTime)
    for index = #self._active, 1, -1 do
        local tween = self._active[index]

        if tween._cancelled or not tween.target then
            table.remove(self._active, index)
            goto continue
        end

        tween.timeSinceStart = tween.timeSinceStart + deltaTime

        local isFinished = tween.timeSinceStart >= tween.duration - COMPLETION_EPSILON
        local timerLocalized = isFinished and 1 or (tween.timeSinceStart / tween.duration)
        local easingFunction = easing[tween.easingName] or easing.linear
        local eased = easingFunction(timerLocalized)

        for property, goalValue in pairs(tween.goalValues) do
            local startValue = tween.startValues[property]
            tween.target[property] = math.lerp(startValue, goalValue, eased)
        end

        if isFinished then
            table.remove(self._active, index)

            if tween.onComplete then
                tween.onComplete()
            end
        end

        :: continue ::
    end
end

function Module.Init()
    SignalHandlerModule.Get("love.update"):Connect(function(deltaTime)
        Module:Update(deltaTime)
    end)
end

return Module