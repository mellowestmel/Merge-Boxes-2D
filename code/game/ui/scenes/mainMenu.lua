-- ~/code/game/ui/scenes/mainMenu.lua

local SettingsModule = require("code.engine.saves.settings")

local MusicHandlerModule = require("code.game.musicHandler")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")
local UIObjectHelperModule = require("code.game.ui.helpers.object")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local SceneData = require("code.data.ui.scenes.mainMenu")

local Module = {}
Module._elements = {}
Module._objects = {}

Module.name = "mainMenu"

local logo2 = nil
local logo = nil

function Module:Clean()
    UIObjectHelperModule.CleanScene(self)

    UISharedFunctions:Clean()
end

local function _setupLogo(self)
    logo = UIObjectHelperModule.CreateElement(
        SceneData.logo,
        self
    )

    logo2 = UIObjectHelperModule.CreateElement(
        SceneData.logo2,
        self
    )
end

local function _setupPlayGameButton(self)
    local playGameButtonHitbox = UIObjectHelperModule.CreateElement(
        SceneData.playGameButtonHitbox,
        self
    )

    local playGameButtonLabel = UIObjectHelperModule.CreateElement(
        SceneData.playGameButtonLabel,
        self
    )

    UIObjectHelperModule.CreateButton(
        self,
        {
            playGameButtonHitbox,
            playGameButtonLabel
        },
        playGameButtonHitbox,
        function()
            ScreenTransitionModule:Transition({
                callback = function()
                    UISceneHandlerModule:Switch("saveFiles")
                end
            })
        end
    )
end

local function _setupQuitButton(self)
    local quitButtonHitbox = UIObjectHelperModule.CreateElement(
        SceneData.quitButtonHitbox,
        self
    )

    local quitButtonLabel = UIObjectHelperModule.CreateElement(
        SceneData.quitButtonLabel,
        self
    )

    UIObjectHelperModule.CreateButton(
        self,
        {
            quitButtonHitbox,
            quitButtonLabel
        },
        quitButtonHitbox,
        function()
            ScreenTransitionModule:Transition({
                callback = function()
                    love.event.quit()
                end
            })
        end
    )
end

function Module:Update()
    local animationsEnabled = SettingsModule:Get("graphics.uiAnimationsEnabled")
    if not animationsEnabled then return end

    local wave = math.sin(love.timer.getTime())

    if logo then logo.offsetY = wave * 5 end
    if logo2 then logo2.offsetY = wave * 8 end
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

end

return Module