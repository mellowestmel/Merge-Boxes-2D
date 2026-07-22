-- ~/code/game/ui/handler.lua

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UIButtonObjectModule = require("code.game.ui.objects.button")

local Module = {}

function Module:mousePressed(x, y, button)
    UIButtonObjectModule:mousePressed(x, y, button)
end

function Module:textInput(input)
end

function Module:update(deltaTime)
    UIButtonObjectModule:updateAll(deltaTime)

    UISceneHandlerModule:update(deltaTime)
end

function Module.init()
    UISceneHandlerModule:switch("splashScreen")
end

return Module