-- ~/code/game/ui/scenes/mainMenu.lua

local RenderModule = require("code.engine.render")

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
Module.name = "mainMenu"

local logo2 = nil
local logo = nil

function Module:clean()
    for _, element in pairs(self._elements) do
        element:remove()
    end

    for _, object in pairs(self._objects) do
        object:remove()
    end

    self._elements = {}
    self._objects = {}

    UISharedFunctions:cleanUpdates()
end

local function setupLogo(self)
    logo = RenderModule:createElement(SceneData.logo)
    table.insert(self._elements, logo)

    logo2 = RenderModule:createElement(SceneData.logo2)
    table.insert(self._elements, logo2)
end

local function setupBackground(self)
    local background = RenderModule:createElement(SceneData.background)
    table.insert(self._elements, background)
end

local function setupPlayGameButton(self)
    local playGameButtonHitbox = RenderModule:createElement(SceneData.playGameButtonHitbox)
    local playGameButtonLabel = RenderModule:createElement(SceneData.playGameButtonLabel)

    table.insert(self._elements, playGameButtonHitbox)
    table.insert(self._elements, playGameButtonLabel)

    local playGameButton = UIButtonObjectModule:createButton({
        elements = {
            playGameButtonHitbox,
            playGameButtonLabel
        },

        hitboxElement = playGameButtonHitbox,

        mouseButton = 1,
        onClick = function()
            ScreenTransitionModule:transition({
                callback = function()
                    UISceneHandlerModule:switch("saveFiles")
                end
            })
        end
    })

    table.insert(self._objects, playGameButton)
end

local function setupQuitButton(self)
    local quitButtonHitbox = RenderModule:createElement(SceneData.quitButtonHitbox)
    local quitButtonLabel = RenderModule:createElement(SceneData.quitButtonLabel)

    table.insert(self._elements, quitButtonHitbox)
    table.insert(self._elements, quitButtonLabel)

    local quitButton = UIButtonObjectModule:createButton({
        elements = {
            quitButtonHitbox,
            quitButtonLabel
        },

        hitboxElement = quitButtonHitbox,

        mouseButton = 1,
        onClick = function()
            ScreenTransitionModule:transition({
                callback = function()
                    love.event.quit()
                end
            })
        end
    })

    table.insert(self._objects, quitButton)
end

local function setupDiscordButton(self)
    local discordButtonHitbox = RenderModule:createElement(SceneData.discordButtonHitbox)
    table.insert(self._elements, discordButtonHitbox)

    local discordButton = UIButtonObjectModule:createButton({
        elements = {
            discordButtonHitbox
        },

        hitboxElement = discordButtonHitbox,

        mouseButton = 1,
        onClick = function()
            love.system.openURL("https://www.discord.gg/pQShPG8XPf")
        end
    })

    table.insert(self._objects, discordButton)
end

function Module:update()
    local animationsEnabled = SettingsModule.loadedFile.graphics.animationsEnabled
    if not animationsEnabled then return end

    local rotation = math.sin(love.timer.getTime()) * 2

    if logo then
       logo:setRotation(rotation)
    end

    if logo2 then
        logo2:setRotation(-rotation)
    end
end

function Module:init()
    UISharedFunctions:setupSettingsButton(self)
    MusicHandlerModule:playTrack("mainMenu")

    setupPlayGameButton(self)
    setupDiscordButton(self)
    setupQuitButton(self)
    setupBackground(self)
    setupLogo(self)
end

return Module