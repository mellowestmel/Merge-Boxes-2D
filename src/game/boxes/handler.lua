local SignalHandlerModule = require("src.engine.events.signalHandler")

local BoxesPhysicsHandlerModule = require("src.game.boxes.physicsHandler")
local BoxesDragHandlerModule = require("src.game.boxes.dragHandler")

local BoxesMergeManagerModule = require("src.game.boxes.mergeManager")
local BoxesFactoryModule = require("src.game.boxes.factory")

local BoxesObjectModule = require("src.game.boxes.object")

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