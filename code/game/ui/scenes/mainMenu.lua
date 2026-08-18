-- ~/code/game/ui/scenes/mainMenu.lua

local RenderElementModule = require("code.engine.render.element")

local SettingsModule = require("code.engine.saves.settings")

local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

local MusicHandlerModule = require("code.game.musicHandler")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")
local UIButtonObjectModule = require("code.game.ui.objects.button")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local SceneData = require("code.data.ui.scenes.mainMenu")

local Module = {}
Module._elements = {}
Module._objects = {}
Module._hideableElements = {}

Module.name = "mainMenu"

local logo2 = nil
local logo = nil

function Module:Clean()
    for _, element in pairs(self._elements) do
        element:Remove()
    end

    for _, object in pairs(self._objects) do
        object:Remove()
    end

    self._hideableElements = {}
    self._elements = {}
    self._objects = {}

    UISharedFunctions:CleanUpdates()
end

local function setupLogo(self)
    logo = RenderElementModule.new(SceneData.logo)
    table.insert(self._elements, logo)

    logo2 = RenderElementModule.new(SceneData.logo2)
    table.insert(self._elements, logo2)
end

local function setupBackground(self)
    local background = RenderElementModule.new(SceneData.background)
    table.insert(self._elements, background)
end

local function setupPlayGameButton(self)
    local playGameButtonHitbox = RenderElementModule.new(SceneData.playGameButtonHitbox)
    local playGameButtonLabel = RenderElementModule.new(SceneData.playGameButtonLabel)

    table.insert(self._hideableElements, playGameButtonHitbox)
    table.insert(self._hideableElements, playGameButtonLabel)

    table.insert(self._elements, playGameButtonHitbox)
    table.insert(self._elements, playGameButtonLabel)

    local playGameButton = UIButtonObjectModule.new({
        elements = {
            playGameButtonHitbox,
            playGameButtonLabel
        },

        hitboxElement = playGameButtonHitbox,

        mouseButton = 1,
        onClick = function()
            ScreenTransitionModule:Transition({
                callback = function()
                    UISceneHandlerModule:Switch("saveFiles")
                end
            })
        end
    })

    table.insert(self._objects, playGameButton)
end

local function setupQuitButton(self)
    local quitButtonHitbox = RenderElementModule.new(SceneData.quitButtonHitbox)
    local quitButtonLabel = RenderElementModule.new(SceneData.quitButtonLabel)

    table.insert(self._hideableElements, quitButtonHitbox)
    table.insert(self._hideableElements, quitButtonLabel)

    table.insert(self._elements, quitButtonHitbox)
    table.insert(self._elements, quitButtonLabel)

    local quitButton = UIButtonObjectModule.new({
        elements = {
            quitButtonHitbox,
            quitButtonLabel
        },

        hitboxElement = quitButtonHitbox,

        mouseButton = 1,
        onClick = function()
            ScreenTransitionModule:Transition({
                callback = function()
                    love.event.quit()
                end
            })
        end
    })

    table.insert(self._objects, quitButton)
end

local function setupVisibilityToggle(self)
    local visibilityToggle = true

    local visibilityToggleButton = UIButtonObjectModule.new({
        elements = {
            logo
        },

        hitboxElement = logo,

        mouseButton = 1,

        onClick = function()
            visibilityToggle = not visibilityToggle

            for _, element in pairs(self._hideableElements) do
                element.render = visibilityToggle
            end
        end
    })

    table.insert(self._objects, visibilityToggleButton)
end

function Module:Update()
    local animationsEnabled = SettingsModule.loadedFile.graphics.animationsEnabled
    if not animationsEnabled then return end

    local rotation = math.sin(love.timer.getTime()) * 2

    if logo then
       logo.rotation = rotation
    end

    if logo2 then
        logo2.rotation = -rotation
    end
end

function Module:Init()
    UISharedFunctions:SetupHighestTierBoxes(self)
    UISharedFunctions:SetupSettingsButton(self)
    UISharedFunctions:SetupDiscordButton(self)

    MusicHandlerModule:PlayTrack("mainMenu")

    setupPlayGameButton(self)
    setupQuitButton(self)
    setupBackground(self)
    setupLogo(self)

    setupVisibilityToggle(self)
end

return Module