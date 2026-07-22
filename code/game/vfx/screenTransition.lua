-- ~/code/game/vfx/sceneTransition.lua

local SettingsModule = require("code.engine.saves.settings")
local RenderModule = require("code.engine.render")

local Module = {}
Module._screenTransitionElement = nil
Module._currentTransition = {}
Module.transitioning = false

function Module:transition(data)
    if not data then data = {} end

    if not SettingsModule.loadedFile.graphics.animationsEnabled then
        self.transitioning = true

        if self._screenTransitionElement then
            self._screenTransitionElement.color.alpha = 1
        end

        if data.callback then
            data.callback()
        end

        self._currentTransition = {
            duration = 0,
            timeSinceStart = 0,
            callbackFired = true
        }

        return
    end

    self.transitioning = true
    self._currentTransition = {
        callback = data.callback or nil,
        duration = data.duration or .8,
        timeSinceStart = 0,
        callbackFired = false
    }
end

function Module:update(deltaTime)
    local element = self._screenTransitionElement
    if not element then return end

    local transition = self._currentTransition
    if not transition.duration then return end

    transition.timeSinceStart = transition.timeSinceStart + (deltaTime)

    local halfDuration = transition.duration / 2
    local progress = transition.timeSinceStart / halfDuration

    if transition.timeSinceStart < halfDuration then
        element.color.alpha = math.min(progress, 1)
    elseif transition.timeSinceStart >= halfDuration and transition.timeSinceStart < transition.duration then
        if not transition.callbackFired and transition.callback then
            transition.callback()
            transition.callbackFired = true
        end
        element.color.alpha = math.max(1 - (progress - 1), 0)
    else
        element.color.alpha = 0

        self._currentTransition = {}
        self.transitioning = false
    end
end

function Module.init()
    Module._screenTransitionElement = RenderModule:createElement({
        spritePath = "assets/sprites/vfx/whitesquare.png",
        type = "sprite",

        scaleX = 10,
        scaleY = 10,

        color = RenderModule:createColor(0, 0, 0, 0),
        zIndex = math.huge
    })
end

return Module