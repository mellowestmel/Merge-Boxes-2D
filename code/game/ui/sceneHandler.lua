-- ~/code/game/ui/sceneHandler.lua

local Module = {}
Module._activeTransition = nil
Module.currentScene = nil
Module.lastScene = nil

local function sceneExists(name)
    local fsPath = "code/game/ui/scenes/" .. name .. ".lua"
    return love.filesystem.getInfo(fsPath, "file") ~= nil
end

function Module:Update(deltaTime)
    if not self.currentScene then return end

    if self.currentScene.update then
        self.currentScene:Update(deltaTime)
    end
end

function Module:Switch(name, ...)
    if not sceneExists(name) then return end

    self.lastScene = self.currentScene

    if self.currentScene then
        self.currentScene:Clean()
    end

    local scene = require("code.game.ui.scenes." .. name)
    scene:init(...)

    self.currentScene = scene
end

return Module