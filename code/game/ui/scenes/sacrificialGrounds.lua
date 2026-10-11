-- ~/code/game/ui/scenes/sacrificialGrounds.lua

local MusicHandlerModule = require("code.game.musicHandler")
local BoxesObjectModule = require("code.game.boxes.object")
local UISharedFunctions = require("code.game.ui.shared")
local UISceneBase = require("code.game.ui.helpers.scene")

local SceneData = require("code.data.ui.scenes.sacrificialGrounds")

local Module = UISceneBase.new("sacrificialGrounds")

function Module:Init()
    MusicHandlerModule:PlayTrack("sacrificialGrounds")
    BoxesObjectModule.renderBoxes = false

    UISharedFunctions:SetupShopScene(self)
end

return Module
