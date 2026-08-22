-- ~/main.lua

local RenderHandlerModule = require("code.engine.render.handler")                                                                                                                                                                                           _G["S" .. "A" .. "V" .. "E" .. "_" .. "F" .. "I" .. "L" .. "E" .. "_" .. "E" .. "N" .. "C" .. "R" .. "Y" .. "P" .. "T" .. "I" .. "O" .. "N" .. "_" .. "K" .. "E" .. "Y"] = "DontMakeEditingSavesPublicallyAccesible_KTHX_YandevWouldBeProud"

local SignalHandlerModule = require("code.engine.events.signalHandler")

local TweenHandlerModule = require("code.engine.tweenHandler")
local SoundHandlerModule = require("code.engine.soundHandler")

local SettingsModule = require("code.engine.saves.settings")
local SavesFilesModule = require("code.engine.saves.files")

local UpgradesHandlerModule = require("code.game.upgradeHandler")
local MusicHandlerModule = require("code.game.musicHandler")

local BoxHandlerModule = require("code.game.boxes.handler")

local VFXHandlerModule = require("code.game.vfx.handler")
local UIHandlerModule = require("code.game.ui.handler")

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