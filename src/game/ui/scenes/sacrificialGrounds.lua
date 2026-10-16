-- ~/src/game/ui/scenes/sacrificialGrounds.lua

local MusicHandlerModule = require("src.game.musicHandler")
local BoxesObjectModule = require("src.game.boxes.object")
local UISharedFunctions = require("src.game.ui.shared")
local UISceneBase = require("src.game.ui.helpers.scene")

local SceneData = require("src.data.ui.scenes.sacrificialGrounds")

local Module = UISceneBase.new("sacrificialGrounds")

function Module:Init()
    MusicHandlerModule:PlayTrack("sacrificialGrounds")
    BoxesObjectModule.renderBoxes = false

    UISharedFunctions:SetupShopScene(self)
end

return Module
