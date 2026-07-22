-- ~/code/game/ui/scenes/sacrificialGrounds.lua

local RenderModule = require("code.engine.render")
local table = require("code.engine.helpers.table")

local MusicHandlerModule = require("code.game.musicHandler")

local BoxesObjectModule = require("code.game.box.object")

local UISharedFunctions = require("code.game.ui.shared")

local SceneData = require("code.data.ui.scenes.sacrificialGrounds")

local Module = {}
Module._elements = {}
Module._objects = {}
Module.name = "sacrificialGrounds"

function Module:clean()
    for _, element in pairs(self._elements) do
        element:remove()
    end

    for _, button in pairs(self._objects) do
        button:remove()
    end

    self._elements = {}
    self._objects = {}

    UISharedFunctions:cleanUpdates()
end

local function setupBackground(self)
    local background = RenderModule:createElement(SceneData.background)
    table.insert(self._elements, background)
end

function Module:update(deltaTime)
    UISharedFunctions:update()
end

function Module:init()
    MusicHandlerModule:playTrack("sacrificialGrounds")

    BoxesObjectModule.renderBoxes = false

    UISharedFunctions:setupSidebarBackground(self)
    UISharedFunctions:setupSettingsButton(self)
    UISharedFunctions:setupShopBackButton(self)

    UISharedFunctions:setupSessionPlaytimeLabel(self)
    UISharedFunctions:setupCurrencyLabels(self)

    UISharedFunctions:setupBackToMenuButton(self)

    setupBackground(self)
end

return Module