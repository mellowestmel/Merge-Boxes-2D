-- ~/code/game/vfx/handler.lua

local ScreenTransitionModule = require("code.game.vfx.screenTransition")
local ScreenFlashModule = require("code.game.vfx.screenFlash")

local Module = {}

function Module:Update(deltaTime)
    ScreenTransitionModule:Update(deltaTime)
    ScreenFlashModule:Update(deltaTime)
end

function Module.Init()
    ScreenTransitionModule.Init()
    ScreenFlashModule.Init()
end

return Module