-- ~/code/game/vfx/handler.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")
local ScreenFlashModule = require("code.game.vfx.screenFlash")

local Module = {}

function Module:Update(deltaTime)
    ScreenTransitionModule:Update(deltaTime)
    ScreenFlashModule:Update(deltaTime)
end

function Module.Init()
    SignalHandlerModule.Get("love.update"):Connect(function(deltaTime)
        Module:Update(deltaTime)
    end)

    ScreenTransitionModule.Init()
    ScreenFlashModule.Init()
end

return Module