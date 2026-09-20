-- ~/code/game/ui/scenes/blackMarket.lua

local MusicHandlerModule = require("code.game.musicHandler")
local BoxesObjectModule = require("code.game.boxes.object")
local UISharedFunctions = require("code.game.ui.shared")

local SceneData = require("code.data.ui.scenes.blackMarket")

local Module = {}
Module._elements = {}
Module._objects = {}
Module.name = "blackMarket"

function Module:Clean()
    for _, element in pairs(self._elements) do
        element:Remove()
    end

    for _, button in pairs(self._objects) do
        button:Remove()
    end

    self._elements = {}
    self._objects = {}

    UISharedFunctions:CleanUpdates()
end

function Module:Update()
    UISharedFunctions:Update()
end

function Module:Init()
    MusicHandlerModule:PlayTrack("blackMarket")

    BoxesObjectModule.renderBoxes = false

    UISharedFunctions:SetupSidebarBackground(self)
    UISharedFunctions:SetupSettingsButton(self)
    UISharedFunctions:SetupShopBackButton(self)

    UISharedFunctions:SetupSessionPlaytimeLabel(self)
    UISharedFunctions:SetupCurrencyLabels(self)

    UISharedFunctions:SetupBackToMenuButton(self)

    UISharedFunctions:SetupBackground(self)
end

return Module