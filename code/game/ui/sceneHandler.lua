-- ~/code/game/ui/sceneHandler.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")

local Module = {}
Module.currentScene = nil
Module.lastScene = nil

local function _sceneExists(name)
    local fsPath = "code/game/ui/scenes/" .. name .. ".lua"
    return love.filesystem.getInfo(fsPath, "file") ~= nil
end

function Module:Update(deltaTime)
    if not self.currentScene then return end

    if self.currentScene.Update then
        self.currentScene:Update(deltaTime)
    end
end

function Module:Switch(name, ...)
	if not _sceneExists(name) then
		return
	end

	local oldScene = self.currentScene
	local scene = require("code.game.ui.scenes." .. name)

	SignalHandlerModule.Get("game.ui.scenechanging"):Fire(
		name,
		oldScene
	)

	self.lastScene = oldScene

	if oldScene then
		oldScene:Clean()
	end

	scene:Init(...)

	self.currentScene = scene

	SignalHandlerModule.Get("game.ui.scenechanged"):Fire(
		name,
		scene,
		oldScene
	)
end

return Module