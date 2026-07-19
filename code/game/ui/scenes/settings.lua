-- ~/code/game/ui/scenes/settings.lua

--/// ENGINE \\\--
local RenderModule = require("code.engine.render")

--// HELPERS \\--
local table = require("code.engine.helpers.table")

--/// GAME \\\--
local MusicHandlerModule = require("code.game.musicHandler")

--// BOX \\--
local BoxesObjectModule = require("code.game.box.object")

--// UI \\--
local UISceneHandlerModule = require("code.game.ui.sceneHandler")

--/ UI OBJECTS \--
local UIButtonObjectModule = require("code.game.ui.objects.button")

--// VFX \\--
local ScreenTransitionModule = require("code.game.vfx.screenTransition")

--/// DATA \\\--
local SceneData = require("code.data.ui.scenes.settings")

local Module = {}
Module._elements = {}
Module._objects = {}
Module.name = "settings"

function Module:clean()
    for _, element in pairs(self._elements) do
        element:remove()
    end

    for _, object in pairs(self._objects) do
        object:remove()
    end

    self._elements = {}
    self._objects = {}
end

local function setupBackground(self)
    local background = RenderModule:createElement(SceneData.background)
    table.insert(self._elements, background)
end

local function setupBackButton(self)
    local backButtonHitbox = RenderModule:createElement(SceneData.backButtonHitbox)
    local backButtonLabel = RenderModule:createElement(SceneData.backButtonLabel)

    table.insert(self._elements, backButtonHitbox)
    table.insert(self._elements, backButtonLabel)

    local backButton = UIButtonObjectModule:createButton({
        elements = {
            backButtonHitbox,
            backButtonLabel
        },

        hitboxElement = backButtonHitbox,

        mouseButton = 1,
        onClick = function()
            ScreenTransitionModule:transition({
                callback = function()
                    UISceneHandlerModule:switch(UISceneHandlerModule.lastScene.name)
                end
            })
        end
    })

    table.insert(self._objects, backButton)
end

function Module:update()
end

function Module:init()
    MusicHandlerModule:playTrack("mainMenu")

    BoxesObjectModule.renderBoxes = false

    setupBackButton(self)
    setupBackground(self)
end

return Module