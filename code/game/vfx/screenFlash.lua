-- ~/code/game/vfx/screenFlash.lua

local RenderElementModule = require("code.engine.render.element")

local SettingsModule = require("code.engine.saves.settings")

local CONSTANTS = require("code.data.constants")

local Module = {}
Module._screenFlashElement = nil
Module._fadeDuration = 2

function Module:Flash(color, fadeDuration)
    if not SettingsModule:Get("accessibility.screenFlashEnabled") then return end

    local element = self._screenFlashElement

    color = color or CONSTANTS.VFX.BASE_SCREEN_FLASH_COLOR

    element:ChangeColor(color)
    element:SetAlpha(color.a or color[4] or 1)

    element.render = true

    self._fadeDuration = fadeDuration or 2
end

function Module:Stop()
    self._screenFlashElement:SetAlpha(0)
end

function Module:Update(deltaTime)
    local element = self._screenFlashElement

    local alpha = element:GetAlpha()
    if alpha <= 0 then return end

    element:SetAlpha(alpha - deltaTime / self._fadeDuration)
end

function Module.Init()
    local element = RenderElementModule.new({
        spritePath = "assets/sprites/vfx/whitesquare.png",
        type = "sprite",

        scaleX = 10^10,
        scaleY = 10^10,

        color = CONSTANTS.VFX.BASE_SCREEN_FLASH_COLOR,
        zIndex = 99999
    })

    -- Start invisible so nothing flashes at startup.
    element:SetAlpha(0)

    Module._screenFlashElement = element
end

return Module