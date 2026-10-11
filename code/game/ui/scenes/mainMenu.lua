-- ~/code/game/ui/scenes/mainMenu.lua

local SettingsModule = require("code.engine.saves.settings")

local MusicHandlerModule = require("code.game.musicHandler")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")
local UIObjectHelperModule = require("code.game.ui.helpers.object")
local UISceneBase = require("code.game.ui.helpers.scene")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local SceneData = require("code.data.ui.scenes.mainMenu")

local Module = UISceneBase.new("mainMenu")

local logo = nil
local logo2 = nil

function Module:OnClean()
    logo = nil
    logo2 = nil
end

local function _setupLogo(self)
    logo = UIObjectHelperModule.CreateElement(SceneData.logo, self)
    logo2 = UIObjectHelperModule.CreateElement(SceneData.logo2, self)
end

local function _setupButtons(self)
    UIObjectHelperModule.CreateElementButton(
        self,
        SceneData.playGameButtonHitbox,
        SceneData.playGameButtonLabel,
        function()
            UISceneHandlerModule:TransitionTo("saveFiles")
        end
    )

    UIObjectHelperModule.CreateElementButton(
        self,
        SceneData.quitButtonHitbox,
        SceneData.quitButtonLabel,
        function()
            ScreenTransitionModule:Transition({
                callback = function()
                    love.event.quit()
                end
            })
        end
    )
end

function Module:OnUpdate()
    if not SettingsModule:Get("graphics.uiAnimationsEnabled") then return end

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

    _setupButtons(self)
    _setupLogo(self)
end

return Module