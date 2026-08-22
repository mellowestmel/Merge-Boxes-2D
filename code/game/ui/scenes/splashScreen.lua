-- ~/code/game/ui/scenes/splashScreen.lua

local SoundHandlerModule = require("code.engine.soundHandler")
local table = require("code.engine.helpers.table")

local SettingsModule = require("code.engine.saves.settings")

local MusicHandlerModule = require("code.game.musicHandler")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local ScreenTransitionModule = require("code.game.vfx.screenTransition")
local UICursorModule = require("code.game.ui.cursor")

local UISharedFunctions = require("code.game.ui.shared")

local SceneData = require("code.data.ui.scenes.splashScreen")

local Module = {}
Module._elements = {}
Module._objects = {}
Module.name = "splashScreen"

local transitionTimer = 2
local logoTimer = 1

local transitionStarted = false
local logoShown = false

local logoFlipSpeed = .05
local logoFlipTimer = 0
local cursorToggleState = false

local splashLogo1
local splashLogo2

function Module:Clean()
    for _, element in pairs(self._elements) do
        element:Remove()
    end

    for _, object in pairs(self._objects) do
        object:Remove()
    end

    UICursorModule:ClearSpriteOverride()

    self._elements = {}
    self._objects = {}
end

local function setupSplashScreenLogo(self)
    splashLogo1 = UISharedFunctions:CreateElement(
        SceneData.splashScreenLogo1,
        self
    )

    splashLogo2 = UISharedFunctions:CreateElement(
        SceneData.splashScreenLogo2,
        self
    )

    splashLogo1.render = true
    splashLogo2.render = false

    local splashScreenSound = SoundHandlerModule.new({
        soundPath = "/assets/sounds/ui/splashscreen.wav",
        volume = 2
    })

    if splashScreenSound then
        splashScreenSound:Play() splashScreenSound:Remove()
    end
end

local function transition()
    ScreenTransitionModule:Transition({
        callback = function()
            UISceneHandlerModule:Switch("mainMenu")
        end
    })
end

function Module:Init()
    MusicHandlerModule:StopTrack(MusicHandlerModule.playingTrack)

    UICursorModule:ClearSpriteOverride()
    UICursorModule:SetSprite()

    transitionTimer = 2
    logoTimer = .5

    transitionStarted = false
    logoShown = false

    cursorToggleState = false

    local animationsEnabled = SettingsModule:Get("graphics.uiAnimationsEnabled")
    logoFlipTimer = (animationsEnabled and 0 or 999)
end

function Module:Update(deltaTime)
    if not logoShown then
        logoTimer = logoTimer - deltaTime

        if logoTimer <= 0 then
            logoShown = true
            setupSplashScreenLogo(self)
        end
    end

    logoFlipTimer = logoFlipTimer - deltaTime

    if logoFlipTimer <= 0 then
        logoFlipTimer = logoFlipSpeed
        cursorToggleState = not cursorToggleState

        if splashLogo1 and splashLogo2 then
            splashLogo1.render = not splashLogo1.render
            splashLogo2.render = not splashLogo2.render
        end

        if SettingsModule:Get("graphics.cursorAnimationsEnabled") then
            local targetCursorSprite = cursorToggleState and "splashscreen_cursor_1" or "splashscreen_cursor_2"
            UICursorModule:SetSpriteOverride(targetCursorSprite)
        end
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