-- ~/code/engine/tweenHandler.lua

-- Generic tween system, works on any table with numbers.
local SignalHandlerModule = require("code.engine.events.signalHandler")
local easingData = require("code.data.easing")

local CONSTANTS = require("code.data.constants")

local Module = {}
Module._active = {}

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
    assert(target, "Tween.new requires target")
    assert(properties, "Tween.new requires properties")

    local startValues = {}

    for property in pairs(properties) do
        startValues[property] = target[property] or 0
    end

    local tween = setmetatable({
        target = target,

        startValues = startValues,
        goalValues = properties,

        duration = duration or .3,
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

        if tween._cancelled then
            table.remove(self._active, index)
            goto continue
        end

        tween.timeSinceStart = tween.timeSinceStart + deltaTime

        local isFinished =
            tween.timeSinceStart >= tween.duration - CONSTANTS.TWEEN.COMPLETION_EPSILON

        local timerLocalized =
            isFinished and 1 or (tween.timeSinceStart / tween.duration)

        local easingFunction =
            easingData[tween.easingName] or easingData.linear

        local eased = easingFunction(timerLocalized)

        for property, goalValue in pairs(tween.goalValues) do
            local startValue = tween.startValues[property]

            tween.target[property] =
                math.lerp(startValue, goalValue, eased)
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