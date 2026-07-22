-- ~/code/game/vfx/handler.lua

local ScreenTransitionModule = require("code.game.vfx.screenTransition")
local ScreenFlashModule = require("code.game.vfx.screenFlash")

local Module = {}

function Module:update(deltaTime)
    ScreenTransitionModule:update(deltaTime)
    ScreenFlashModule:update(deltaTime)
end

function Module.init()
    ScreenTransitionModule.init()
    ScreenFlashModule.init()
end

return Module