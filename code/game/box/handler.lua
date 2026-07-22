-- ~/code/game/box/handler.lua

local BoxRotationHandlerModule = require("code.game.box.rotationHandler")
local BoxPhysicsHandlerModule = require("code.game.box.physicsHandler")
local BoxDragHandlerModule = require("code.game.box.dragHandler")

local BoxMergeManagerModule = require("code.game.box.mergeManager")
local BoxesObjectModule = require("code.game.box.object")

local BoxScaleTweenModule = require("code.game.box.scaleTween")

local Module = {}

function Module:update(deltaTime)
    if BoxesObjectModule.renderBoxes then
        BoxPhysicsHandlerModule:update(deltaTime)
        BoxMergeManagerModule:update(deltaTime)
        BoxScaleTweenModule:update(deltaTime)
        BoxRotationHandlerModule:update()
        BoxDragHandlerModule:update()
    end

    BoxesObjectModule:update(deltaTime)
end

return Module