-- ~/code/game/ui/sceneHandler.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

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

function Module:TransitionTo(name, options, ...)
    local args, count = {...}, select("#", ...)
    local transition = {}

    for key, value in pairs(options or {}) do
        transition[key] = value
    end

    transition.callback = function()
        self:Switch(name, unpack(args, 1, count))
    end

    ScreenTransitionModule:Transition(transition)
end

return Module