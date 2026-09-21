-- ~/code/game/ui/scenes/blackMarket.lua

local MusicHandlerModule = require("code.game.musicHandler")
local BoxesObjectModule = require("code.game.boxes.object")
local UISharedFunctions = require("code.game.ui.shared")
local UIObjectHelperModule = require("code.game.ui.helpers.object")

local SceneData = require("code.data.ui.scenes.blackMarket")

local Module = {}
Module._elements = {}
Module._objects = {}
Module.name = "blackMarket"

function Module:Clean()
    UIObjectHelperModule.CleanScene(self)
    UISharedFunctions:Clean()
end

function Module:Update()
    UISharedFunctions:Update()
end

function Module:Init()
    MusicHandlerModule:PlayTrack("blackMarket")
    BoxesObjectModule.renderBoxes = false

    UISharedFunctions:SetupSidebarBackground(self)
    UISharedFunctions:SetupBackground(self)

    UISharedFunctions:SetupBackToMenuButton(self)
    UISharedFunctions:SetupSettingsButton(self)

    UISharedFunctions:SetupSessionPlaytimeLabel(self)
    UISharedFunctions:SetupCurrencyLabels(self)

    UISharedFunctions:SetupShopBackButton(self)
end

return Module