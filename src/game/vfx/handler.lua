local SignalHandlerModule = require("src.engine.events.signalHandler")

local ScreenTransitionModule = require("src.game.vfx.screenTransition")
local ScreenFlashModule = require("src.game.vfx.screenFlash")

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