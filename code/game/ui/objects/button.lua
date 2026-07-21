-- ~/code/game/ui/objects/button.lua

--/// ENGINE \\\--
local RenderModule = require("code.engine.render")
local SoundModule = require("code.engine.sound")
local IdManagerModule = require("code.engine.idManager")

--// SAVES \\--
local SettingsModule = require("code.engine.saves.settings")

--// HELPERS \\--
local math = require("code.engine.helpers.math")

--// VFX \\--
local ScreenTransitionModule = require("code.game.vfx.screenTransition")

local Button = {
    id = 0,

    elements = {},

    cooldown = 0,
    lastUsed = 0,

    hitboxElement = {},

    mouseButton = 1,
    onClick = nil,

    _clickScale = .1,
    _hoverScale = .05,

    _scaleSpeed = .5,

    _isHovered = false
}
Button.__index = Button

local Module = {}
Module._buttons = {}

local manager = IdManagerModule:createManager()

function Button:remove()
    Module._buttons[self.id] = nil
    manager:release(self.id)
end

function Button:mousePressed(x, y, mouseButton)
    if ScreenTransitionModule.transitioning then return end

    if (love.timer.getTime() - self.lastUsed) < self.cooldown then return end
    if not self.hitboxElement:isPointInside(x, y) then return end
    if mouseButton ~= self.mouseButton then return end

    self.lastUsed = love.timer.getTime()

    local animationsEnabled = SettingsModule.loadedFile.graphics.animationsEnabled

    if animationsEnabled then
        for _, element in pairs(self.elements) do
            element._baseScaleX = element._baseScaleX or (element.scaleX or 1)
            element._baseScaleY = element._baseScaleY or (element.scaleY or 1)

            element.scaleX = element._baseScaleX - self._clickScale
            element.scaleY = element._baseScaleY - self._clickScale
        end
    end

    if self.playClickSound then
        local sound = SoundModule:createSound({soundPath = "assets/sounds/ui/click.wav"})

        if sound then
            sound:play(true, -100, 100, 1000)
            sound:remove()
        end
    end

    if self.onClick then
        self:onClick()
    end
end

function Button:update(deltaTime)
    if not self.hitboxElement then self:remove() return end

    local mouseX, mouseY = RenderModule:getMousePos()
    self._isHovered = self.hitboxElement:isPointInside(mouseX, mouseY)

    local animationsEnabled = SettingsModule.loadedFile.graphics.animationsEnabled
    local scaleLerp = animationsEnabled and math.min(1, self._scaleSpeed * deltaTime * 10) or 1

    for _, element in pairs(self.elements) do
        element._baseScaleX = element._baseScaleX or (element.scaleX or 1)
        element._baseScaleY = element._baseScaleY or (element.scaleY or 1)

        local targetScaleX = element._baseScaleX
        local targetScaleY = element._baseScaleY

        if self._isHovered then
            targetScaleX = targetScaleX + self._hoverScale
            targetScaleY = targetScaleY + self._hoverScale
        end

        element.scaleX = element.scaleX + (targetScaleX - element.scaleX) * scaleLerp
        element.scaleY = element.scaleY + (targetScaleY - element.scaleY) * scaleLerp
    end
end

function Module:createButton(data)
    if not data then return end
    if not data.hitboxElement then return end
    if #data.elements == 0 then return end

    local button = setmetatable({
        id = manager:get(),

        elements = data.elements or {},

        cooldown = data.cooldown or .25,
        lastUsed = -math.huge,

        playClickSound = data.playClickSound or true,

        hitboxElement = data.hitboxElement,

        mouseButton = data.mouseButton or 1,
        onClick = data.onClick or nil,

        _clickScale = data.clickScale or .1,
        _hoverScale = data.hoverScale or .05,

        _scaleSpeed = data.scaleSpeed or .5
    }, Button)

    Module._buttons[button.id] = button
    return button
end

function Module:mousePressed(x, y, mouseButton)
    for _, button in pairs(self._buttons) do
        button:mousePressed(x, y, mouseButton)
    end
end

function Module:updateAll(deltaTime)
    for _, button in pairs(self._buttons) do
        button:update(deltaTime)
    end
end

return Module