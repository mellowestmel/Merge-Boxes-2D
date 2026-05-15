-- ~/code/game/ui/handler.lua

--// UI \\--
local UISceneHandlerModule = require("code.game.ui.sceneHandler")

--/ UI OBJECTS \--
local UIButtonObjectModule = require("code.game.ui.objects.button")

local Module = {}

function Module:mousePressed(x, y, button)
    UIButtonObjectModule:mousePressed(x, y, button)
end

function Module:keyPressed(input, scanCode, isRepeat)
    if input == "f11" then
        local isFullscreen = love.window.getFullscreen()
        love.window.setFullscreen(not isFullscreen)
    end
end

function Module:textInput(input)
end

function Module:update(deltaTime)
    UIButtonObjectModule:updateAll(deltaTime)

    UISceneHandlerModule:update(deltaTime)
end

function Module.init()
    UISceneHandlerModule:switch("mainMenu")
end

return Module