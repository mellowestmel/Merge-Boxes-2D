-- ~/code/game/ui/scenes/sacrificialGrounds.lua

local RenderElementModule = require("code.engine.render.element")
local table = require("code.engine.helpers.table")

local MusicHandlerModule = require("code.game.musicHandler")

local BoxesObjectModule = require("code.game.box.object")

local UISharedFunctions = require("code.game.ui.shared")

local SceneData = require("code.data.ui.scenes.sacrificialGrounds")

local Module = {}
Module._elements = {}
Module._objects = {}
Module.name = "sacrificialGrounds"

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

local function setupBackground(self)
    local background = RenderElementModule.new(SceneData.background)
    table.insert(self._elements, background)
end

function Module:Update(deltaTime)
    UISharedFunctions:Update()
end

function Module:Init()
    MusicHandlerModule:PlayTrack("sacrificialGrounds")

    BoxesObjectModule.renderBoxes = false

    UISharedFunctions:SetupSidebarBackground(self)
    UISharedFunctions:SetupSettingsButton(self)
    UISharedFunctions:SetupShopBackButton(self)

    UISharedFunctions:SetupSessionPlaytimeLabel(self)
    UISharedFunctions:SetupCurrencyLabels(self)

    UISharedFunctions:SetupBackToMenuButton(self)

    setupBackground(self)
end

return Module