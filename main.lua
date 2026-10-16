-- ~/main.lua

local RenderHandlerModule = require("src.engine.render.handler")                                                                                                                                                                                           _G["S" .. "A" .. "V" .. "E" .. "_" .. "F" .. "I" .. "L" .. "E" .. "_" .. "E" .. "N" .. "C" .. "R" .. "Y" .. "P" .. "T" .. "I" .. "O" .. "N" .. "_" .. "K" .. "E" .. "Y"] = "DontMakeEditingSavesPublicallyAccesible_KTHX_YandevWouldBeProud"

local SignalHandlerModule = require("src.engine.events.signalHandler")

local LocalizationHandlerModule = require("src.engine.localizationHandler")
local TweenHandlerModule = require("src.engine.tweenHandler")
local SoundHandlerModule = require("src.engine.soundHandler")

local SettingsModule = require("src.engine.saves.settings")
local SavesFilesModule = require("src.engine.saves.files")

local UpgradesHandlerModule = require("src.game.upgradeHandler")
local MusicHandlerModule = require("src.game.musicHandler")

local BoxHandlerModule = require("src.game.boxes.handler")

local VFXHandlerModule = require("src.game.vfx.handler")
local UIHandlerModule = require("src.game.ui.handler")

-- Generic fire functions for Love2D's handlers
for name, handler in pairs(love.handlers) do
	local signal = SignalHandlerModule.Get("love." .. name)

	love.handlers[name] = function(...)
		signal:Fire(...)

		local result = handler(...)
		return result
	end
end

-- Special binds for Love2D's built-in callbacks
local function _bindCallback(name)
	local oldCallback = love[name]
	local signal = SignalHandlerModule.Get("love." .. name)

	love[name] = function(...)
		signal:Fire(...)
		if oldCallback then return oldCallback(...) end
	end
end

_bindCallback("update")
_bindCallback("draw")

_bindCallback("load")
_bindCallback("quit")

-- Callbacks to all those signals
SignalHandlerModule.Get("love.load"):Connect(function()
    math.randomseed(os.time())
    math.random()

    SavesFilesModule.Init()
    SettingsModule.Init()

    LocalizationHandlerModule.Init()

    RenderHandlerModule.Init()
    TweenHandlerModule.Init()

    BoxHandlerModule.Init()

    SoundHandlerModule.Init()
    MusicHandlerModule.Init()

    UpgradesHandlerModule.Init()

    VFXHandlerModule.Init()
    UIHandlerModule.Init()
end)

SignalHandlerModule.Get("love.quit"):Connect(function()
    love.window.setFullscreen(false)
end)