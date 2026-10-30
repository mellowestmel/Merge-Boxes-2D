local RenderUtilsModule = require("src.engine.render.utils")
local SignalHandlerModule = require("src.engine.events.signalHandler")

local UISceneHandlerModule = require("src.game.ui.sceneHandler")

local UIScrollingFrameObjectModule = require("src.game.ui.objects.scrollingFrame")
local UIButtonObjectModule = require("src.game.ui.objects.button")

local UICursorModule = require("src.game.ui.cursor")

local Module = {}

function Module:WheelMoved(x, y)
    UIScrollingFrameObjectModule:WheelMoved(x, y)
end

function Module:MousePressed(x, y, button)
    UIScrollingFrameObjectModule:MousePressed(x, y, button)
    UIButtonObjectModule:MousePressed(x, y, button)
end

function Module:MouseReleased(x, y, button)
    UIScrollingFrameObjectModule:MouseReleased(button)
end

function Module:Update(deltaTime)
    UIScrollingFrameObjectModule:Update(deltaTime)
    UIButtonObjectModule:Update(deltaTime)

    UISceneHandlerModule:Update(deltaTime)

    UICursorModule:Update(deltaTime)
end

function Module.Init()
    UICursorModule.Init()

    SignalHandlerModule.Get("love.update"):Connect(function(deltaTime)
        Module:Update(deltaTime)
    end)

    SignalHandlerModule.Get("love.mousepressed"):Connect(function(_, _, button)
        local mouseX, mouseY = RenderUtilsModule.GetScaledMousePosition()
        Module:MousePressed(mouseX, mouseY, button)
    end)

    SignalHandlerModule.Get("love.mousereleased"):Connect(function(_, _, button)
        local mouseX, mouseY = RenderUtilsModule.GetScaledMousePosition()
        Module:MouseReleased(mouseX, mouseY, button)
    end)

    SignalHandlerModule.Get("love.wheelmoved"):Connect(function(x, y)
        Module:WheelMoved(x, y)
    end)

    UISceneHandlerModule:Switch("splashScreen")
end

return Module