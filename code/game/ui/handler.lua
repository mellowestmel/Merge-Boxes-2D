-- ~/code/game/ui/handler.lua

local UISceneHandlerModule = require("code.game.ui.sceneHandler")

local UIScrollingFrameObjectModule = require("code.game.ui.objects.scrollingFrame")
local UIButtonObjectModule = require("code.game.ui.objects.button")

local Module = {}

function Module:WheelMoved(x, y)
    UIScrollingFrameObjectModule:WheelMoved(x, y)
end

function Module:MousePressed(x, y, button)
    UIScrollingFrameObjectModule:MousePressed(x, y, button)
    UIButtonObjectModule:MousePressed(x, y, button)
end

function Module:MouseReleased(x, y, button)
    UIScrollingFrameObjectModule:MouseReleased(x, y, button)
end

function Module:Update(deltaTime)
    UIScrollingFrameObjectModule:UpdateAll(deltaTime)
    UIButtonObjectModule:UpdateAll(deltaTime)

    UISceneHandlerModule:Update(deltaTime)
end

function Module.Init()
    UISceneHandlerModule:Switch("splashScreen")
end

return Module