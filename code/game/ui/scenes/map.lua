-- ~/code/game/ui/scenes/map.lua

local MusicHandlerModule = require("code.game.musicHandler")
local BoxesObjectModule = require("code.game.boxes.object")
local UISharedFunctions = require("code.game.ui.shared")
local UIObjectHelperModule = require("code.game.ui.helpers.object")

local SceneData = require("code.data.ui.scenes.map")

local Module = {}
Module._elements = {}
Module._objects = {}
Module.name = "map"

function Module:Clean()
    UIObjectHelperModule.CleanScene(self)
    UISharedFunctions:Clean()
end

function Module:Update()
    UISharedFunctions:Update()
end

function Module:Init()
    MusicHandlerModule:PlayTrack("map")
    BoxesObjectModule.renderBoxes = false

    UISharedFunctions:SetupSidebarBackground(self)
    UISharedFunctions:SetupBackground(self)

    UISharedFunctions:SetupBackToMenuButton(self)
    UISharedFunctions:SetupSettingsButton(self)

    UISharedFunctions:SetupSessionPlaytimeLabel(self)
    UISharedFunctions:SetupCurrencyLabels(self)
end

return Module