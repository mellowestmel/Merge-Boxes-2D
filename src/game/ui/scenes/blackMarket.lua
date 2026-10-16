-- ~/src/game/ui/scenes/blackMarket.lua

local MusicHandlerModule = require("src.game.musicHandler")
local BoxesObjectModule = require("src.game.boxes.object")
local UISharedFunctions = require("src.game.ui.shared")
local UISceneBase = require("src.game.ui.helpers.scene")

local SceneData = require("src.data.ui.scenes.blackMarket")

local Module = UISceneBase.new("blackMarket")

function Module:Init()
    MusicHandlerModule:PlayTrack("blackMarket")
    BoxesObjectModule.renderBoxes = false

    UISharedFunctions:SetupShopScene(self)
end

return Module
