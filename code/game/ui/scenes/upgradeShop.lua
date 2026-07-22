-- ~/code/game/ui/scenes/upgradeShop.lua

local RenderModule = require("code.engine.render")
local SoundModule = require("code.engine.sound")

local table = require("code.engine.helpers.table")

local MusicHandlerModule = require("code.game.musicHandler")

local BoxesObjectModule = require("code.game.box.object")

local UISharedFunctions = require("code.game.ui.shared")
local UIButtonObjectModule = require("code.game.ui.objects.button")

local SceneData = require("code.data.ui.scenes.upgradeShop")

local Module = {}
Module._elements = {}
Module._objects = {}
Module.name = "upgradeShop"

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

local function setupTheBirbsWord(self)
    local birb = RenderModule:createElement(SceneData.theBirbsWord)
    table.insert(self._elements, birb)

    local birbButton = UIButtonObjectModule:createButton({
        elements = {
            birb
        },

        hitboxElement = birb,

        mouseButton = 1,
        onClick = function()
            local birbSound = SoundModule:createSound({soundPath = "assets/sounds/birb.wav"})

            if birbSound then
                birbSound:play()
                birbSound:remove()
            end
        end
    })

    table.insert(self._objects, birbButton)
end

function Module:update(deltaTime)
    UISharedFunctions:update()
end

function Module:init()
    MusicHandlerModule:playTrack("upgradeShop")

    BoxesObjectModule.renderBoxes = false

    UISharedFunctions:setupSidebarBackground(self)
    UISharedFunctions:setupSettingsButton(self)
    UISharedFunctions:setupShopBackButton(self)

    UISharedFunctions:setupSessionPlaytimeLabel(self)
    UISharedFunctions:setupCurrencyLabels(self)

    UISharedFunctions:setupBackToMenuButton(self)

    setupTheBirbsWord(self)
    setupBackground(self)
end

return Module