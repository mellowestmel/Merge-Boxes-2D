-- ~/code/game/ui/scenes/blackMarket.lua

local MusicHandlerModule = require("code.game.musicHandler")
local BoxesObjectModule = require("code.game.boxes.object")
local UISharedFunctions = require("code.game.ui.shared")
local UISceneBase = require("code.game.ui.helpers.scene")

local SceneData = require("code.data.ui.scenes.blackMarket")

local Module = UISceneBase.new("blackMarket")

function Module:Init()
    MusicHandlerModule:PlayTrack("blackMarket")
    BoxesObjectModule.renderBoxes = false

    UISharedFunctions:SetupShopScene(self)
end

return Module