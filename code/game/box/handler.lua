-- ~/code/game/box/handler.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")

local BoxRotationHandlerModule = require("code.game.box.rotationHandler")
local BoxPhysicsHandlerModule = require("code.game.box.physicsHandler")
local BoxDragHandlerModule = require("code.game.box.dragHandler")

local BoxMergeManagerModule = require("code.game.box.mergeManager")
local BoxesObjectModule = require("code.game.box.object")

local BoxScaleTweenModule = require("code.game.box.scaleTween")

local Module = {}

function Module:Update(deltaTime)
    if BoxesObjectModule.renderBoxes then
        BoxPhysicsHandlerModule:Update(deltaTime)
        BoxMergeManagerModule:Update(deltaTime)
        BoxScaleTweenModule:Update(deltaTime)
        BoxRotationHandlerModule:Update()
        BoxDragHandlerModule:Update()
    end

    BoxesObjectModule:Update(deltaTime)
end

function Module.Init()
    SignalHandlerModule.Get("love.update"):Connect(function(deltaTime)
        Module:Update(deltaTime)
    end)
end

return Module