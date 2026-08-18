-- ~/code/game/vfx/screenFlash.lua

local RenderElementModule = require("code.engine.render.element")
local RenderUtilsModule = require("code.engine.render.utils")

local table = require("code.engine.helpers.table")

local SettingsModule = require("code.engine.saves.settings")

local CONSTANTS = require("code.game.vfx.constants")

local Module = {}
Module._screenFlashElement = nil
Module._fadeDuration = 2

function Module:Flash(color, fadeDuration)
    local screenFlashEnabled = SettingsModule.loadedFile.accessibility.screenFlashEnabled
    if not screenFlashEnabled then return end

    if color then color = table.clone(color) end

    self._screenFlashElement.color = color or RenderUtilsModule.CreateColor(
        CONSTANTS.BASE_SCREEN_FLASH_COLOR.r * 255,
        CONSTANTS.BASE_SCREEN_FLASH_COLOR.g * 255,
        CONSTANTS.BASE_SCREEN_FLASH_COLOR.b * 255,
        1
    )

    self._fadeDuration = fadeDuration or 2
end

function Module:Stop()
    self._screenFlashElement.color = RenderUtilsModule.CreateColor(0, 0, 0, 0)
end

function Module:Update(deltaTime)
    local element = self._screenFlashElement
    if not element then return end

    local alpha = element.color.alpha
    if alpha > 0 then
        local alphaPerSecond = 1 / self._fadeDuration
        alpha = alpha - alphaPerSecond * deltaTime

        if alpha < 0 then return end
        element.color.alpha = alpha
    end
end

function Module.Init()
    Module._screenFlashElement = RenderElementModule.new({
        spritePath = "assets/sprites/vfx/whitesquare.png",
        type = "sprite",

        scaleX = 10^10,
        scaleY = 10^10,

        color = CONSTANTS.BASE_SCREEN_FLASH_COLOR,
        zIndex = 50
    })
end

return Module