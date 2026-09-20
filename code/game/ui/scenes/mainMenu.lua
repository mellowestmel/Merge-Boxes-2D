-- ~/code/game/ui/scenes/mainMenu.lua

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

function Module:Clean()
    for _, element in pairs(self._elements) do
        element:Remove()
    end

    for _, object in pairs(self._objects) do
        object:Remove()
    end

    self._elements = {}
    self._objects = {}

    UISharedFunctions:CleanUpdates()
end

local function _setupLogo(self)
    logo = UISharedFunctions:CreateElement(
        SceneData.logo,
        self
    )

    logo2 = UISharedFunctions:CreateElement(
        SceneData.logo2,
        self
    )
end

local function _setupPlayGameButton(self)
    local playGameButtonHitbox = UISharedFunctions:CreateElement(
        SceneData.playGameButtonHitbox,
        self
    )

    local playGameButtonLabel = UISharedFunctions:CreateElement(
        SceneData.playGameButtonLabel,
        self
    )

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

local function _setupQuitButton(self)
    local quitButtonHitbox = UISharedFunctions:CreateElement(
        SceneData.quitButtonHitbox,
        self
    )

    local quitButtonLabel = UISharedFunctions:CreateElement(
        SceneData.quitButtonLabel,
        self
    )

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

function Module:Update()
    local animationsEnabled = SettingsModule:Get("graphics.uiAnimationsEnabled")
    if not animationsEnabled then return end

    local animation = math.sin(love.timer.getTime())

    if logo then
        logo.offsetY = animation * 5
    end

    if logo2 then
        logo2.offsetY = animation * 8
    end
end

function Module:Init()
    MusicHandlerModule:PlayTrack("mainMenu")

    UISharedFunctions:SetupHighestTierBoxes(self)
    UISharedFunctions:SetupSettingsButton(self)
    UISharedFunctions:SetupDiscordButton(self)

    UISharedFunctions:SetupBackground(self)

    _setupPlayGameButton(self)
    _setupQuitButton(self)
    _setupLogo(self)

    --UISharedFunctions:SetupVisibilityToggle(self)
end

return Module