local SettingsModule = require("src.engine.saves.settings")

local MusicHandlerModule = require("src.game.musicHandler")

local UISceneHandlerModule = require("src.game.ui.sceneHandler")
local UISharedFunctions = require("src.game.ui.shared")
local UIObjectHelperModule = require("src.game.ui.helpers.object")
local UISceneBase = require("src.game.ui.helpers.scene")

local ScreenTransitionModule = require("src.game.vfx.screenTransition")

local SceneData = require("src.data.ui.scenes.mainMenu")

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
