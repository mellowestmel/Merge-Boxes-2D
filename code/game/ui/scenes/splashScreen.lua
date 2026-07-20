-- ~/code/game/ui/scenes/mainMenu.lua

--/// ENGINE \\\--
local RenderModule = require("code.engine.render")
local SoundModule = require("code.engine.sound")

--// HELPERS \\--
local table = require("code.engine.helpers.table")

--// UI \\--
local UISceneHandlerModule = require("code.game.ui.sceneHandler")

--// VFX \\--
local ScreenTransitionModule = require("code.game.vfx.screenTransition")

--/// DATA \\\--
local SceneData = require("code.data.ui.scenes.splashScreen")

local Module = {}
Module._elements = {}
Module._objects = {}
Module.name = "splashScreen"

local transitionTimer = 2
local logoTimer = 1

local transitionStarted = false
local logoShown = false

local logoFlipSpeed = 0.05
local logoFlipTimer = 0

local splashLogo1
local splashLogo2

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

local function setupSplashScreenLogo(self)
    splashLogo1 = RenderModule:createElement(SceneData.splashScreenLogo1)
    splashLogo2 = RenderModule:createElement(SceneData.splashScreenLogo2)

    table.insert(self._elements, splashLogo1)
    table.insert(self._elements, splashLogo2)

    splashLogo1.render = true
    splashLogo2.render = false

    local splashScreenSound = SoundModule:createSound({
        soundPath = "/assets/sounds/ui/splashscreen.wav",
        volume = 2
    })

    if splashScreenSound then
        splashScreenSound:play()
        splashScreenSound:remove()
    end
end

local function transition()
    ScreenTransitionModule:transition({
        callback = function()
            UISceneHandlerModule:switch("mainMenu")
        end
    })
end

function Module:init()
    transitionTimer = 2
    logoTimer = .5

    transitionStarted = false
    logoShown = false

    logoFlipTimer = 0
end

function Module:update(deltaTime)
    if not logoShown then
        logoTimer = logoTimer - deltaTime

        if logoTimer <= 0 then
            logoShown = true
            setupSplashScreenLogo(self)
        end

        return
    end

    logoFlipTimer = logoFlipTimer - deltaTime

    if logoFlipTimer <= 0 then
        logoFlipTimer = logoFlipSpeed

        splashLogo1.render = not splashLogo1.render
        splashLogo2.render = not splashLogo2.render
    end

    if not transitionStarted then
        transitionTimer = transitionTimer - deltaTime

        if transitionTimer <= 0 then
            transitionStarted = true
            transition()
        end
    end
end

return Module