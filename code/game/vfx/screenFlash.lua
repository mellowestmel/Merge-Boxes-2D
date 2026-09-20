-- ~/code/game/vfx/screenFlash.lua

local RenderElementModule = require("code.engine.render.element")
local table = require("code.engine.helpers.table")

local SettingsModule = require("code.engine.saves.settings")

local CONSTANTS = require("code.data.constants")

local Module = {}
Module._screenFlashElement = nil
Module._fadeDuration = 2

function Module:Flash(color, fadeDuration)
    local screenFlashEnabled = SettingsModule:Get("accessibility.screenFlashEnabled")
    if not screenFlashEnabled then return end

    if color then color = table.clone(color) end

    self._screenFlashElement:ChangeColor(color or CONSTANTS.VFX.BASE_SCREEN_FLASH_COLOR)
    self._fadeDuration = fadeDuration or 2
end

function Module:Stop()
    self._screenFlashElement.render = false
end

function Module:Update(deltaTime)
    local element = self._screenFlashElement
    if not element then return end

    local alpha = element:GetAlpha()
    if alpha > 0 then
        local alphaPerSecond = 1 / self._fadeDuration
        alpha = alpha - alphaPerSecond * deltaTime

        if alpha < 0 then return end
        element:SetAlpha(alpha)
    end
end

function Module.Init()
    Module._screenFlashElement = RenderElementModule.new({
        spritePath = "assets/sprites/vfx/whitesquare.png",
        type = "sprite",

        scaleX = 10^10,
        scaleY = 10^10,

        color = CONSTANTS.VFX.BASE_SCREEN_FLASH_COLOR,
        zIndex = 99999
    })
end

return Module