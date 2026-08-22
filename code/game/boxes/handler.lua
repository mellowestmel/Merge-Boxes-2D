-- ~/code/game/box/handler.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")

local BoxesPhysicsHandlerModule = require("code.game.boxes.physicsHandler")
local BoxesDragHandlerModule = require("code.game.boxes.dragHandler")

local BoxesMergeManagerModule = require("code.game.boxes.mergeManager")
local BoxesFactoryModule = require("code.game.boxes.factory")

local BoxesObjectModule = require("code.game.boxes.object")

local Module = {}

function Module:Update(deltaTime)
    if BoxesObjectModule.renderBoxes then
        BoxesDragHandlerModule:Update(deltaTime)
        BoxesPhysicsHandlerModule:Update(deltaTime)

        BoxesMergeManagerModule:Update(deltaTime)
        BoxesFactoryModule:Update()
    end

    BoxesObjectModule:Update(deltaTime)
end

function Module.Init()
    SignalHandlerModule.Get("love.update"):Connect(function(deltaTime)
        Module:Update(deltaTime)
    end)

    BoxesObjectModule.Init()
end

return Module