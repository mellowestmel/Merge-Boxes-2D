-- ~/code/game/ui/handler.lua

local UISceneHandlerModule = require("code.game.ui.sceneHandler")

local UIScrollingFrameObjectModule = require("code.game.ui.objects.scrollingFrame")
local UIButtonObjectModule = require("code.game.ui.objects.button")

local Module = {}

function Module:wheelMoved(x, y)
    UIScrollingFrameObjectModule:wheelMoved(x, y)
end

function Module:mousePressed(x, y, button)
    UIScrollingFrameObjectModule:mousePressed(x, y, button)
    UIButtonObjectModule:mousePressed(x, y, button)
end

function Module:mouseReleased(x, y, button)
    UIScrollingFrameObjectModule:mouseReleased(x, y, button)
end

function Module:update(deltaTime)
    UIScrollingFrameObjectModule:updateAll(deltaTime)
    UIButtonObjectModule:updateAll(deltaTime)

    UISceneHandlerModule:update(deltaTime)
end

function Module.init()
    UISceneHandlerModule:switch("splashScreen")
end

return Module