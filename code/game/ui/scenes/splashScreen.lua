-- ~/code/game/ui/scenes/splashScreen.lua

local SoundHandlerModule = require("code.engine.soundHandler")
local SettingsModule = require("code.engine.saves.settings")

local MusicHandlerModule = require("code.game.musicHandler")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UIObjectHelperModule = require("code.game.ui.helpers.object")
local UICursorModule = require("code.game.ui.cursor")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local SceneData = require("code.data.ui.scenes.splashScreen")

local Module = {}
Module._elements = {}
Module._objects = {}
Module.name = "splashScreen"

local transitionTimer = 2
local logoTimer = .5
local logoFlipTimer = 0

local transitionStarted = false
local logoShown = false
local cursorToggleState = false

local logoFlipSpeed = .05

local splashLogo1
local splashLogo2

local animationsEnabled
local cursorAnimationsEnabled

function Module:Clean()
	UIObjectHelperModule.CleanScene(self)

	UICursorModule:ClearSpriteOverride()

	splashLogo1 = nil
	splashLogo2 = nil
end

local function _setupSplashScreenLogo(self)
	splashLogo1 = UIObjectHelperModule.CreateElement(
		SceneData.splashScreenLogo1,
		self
	)

	splashLogo2 = UIObjectHelperModule.CreateElement(
		SceneData.splashScreenLogo2,
		self
	)

	splashLogo2.render = false

	SoundHandlerModule.new({
		soundPath = "/assets/sounds/ui/splashscreen.wav",
		volume = 2
	}):Play(true)
end

function Module:Init()
	MusicHandlerModule:StopTrack(MusicHandlerModule.playingTrack)

	UICursorModule:ClearSpriteOverride()
	UICursorModule:SetSprite()

	transitionTimer = 2
	logoTimer = .5
	logoFlipTimer = 0

	transitionStarted = false
	logoShown = false
	cursorToggleState = false

	animationsEnabled = SettingsModule:Get("graphics.uiAnimationsEnabled")
	cursorAnimationsEnabled = SettingsModule:Get("graphics.cursorAnimationsEnabled")

	if not animationsEnabled then
		logoFlipTimer = logoFlipSpeed
	end
end

function Module:Update(deltaTime)
	if not logoShown then
		logoTimer = logoTimer - deltaTime

		if logoTimer <= 0 then
			logoShown = true
			_setupSplashScreenLogo(self)
		end
	end

	if animationsEnabled then
		logoFlipTimer = logoFlipTimer - deltaTime

		if logoFlipTimer <= 0 then
			logoFlipTimer = logoFlipSpeed
			cursorToggleState = not cursorToggleState

			if splashLogo1 then
				splashLogo1.render = not splashLogo1.render
			end

			if splashLogo2 then
				splashLogo2.render = not splashLogo2.render
			end

			if cursorAnimationsEnabled then
				UICursorModule:SetSpriteOverride(
					cursorToggleState
						and "splashscreen_cursor_1"
						or "splashscreen_cursor_2"
				)
			end
		end
	end

	if not transitionStarted then
		transitionTimer = transitionTimer - deltaTime

		if transitionTimer <= 0 then
			transitionStarted = true

			ScreenTransitionModule:Transition({
				callback = function()
					UISceneHandlerModule:Switch("mainMenu")
				end
			})
		end
	end
end

return Module