-- ~/code/game/ui/cursor.lua

local RenderElementModule = require("code.engine.render.element")
local RenderUtilsModule = require("code.engine.render.utils")
local SettingsModule = require("code.engine.saves.settings")
local TweenHandlerModule = require("code.engine.tweenHandler")

local math = require("code.engine.helpers.math")

local CONSTANTS = require("code.game.ui.constants")

local Module = {
    _sprites = {},

    _dragging = false,
    _dragOffsetX = 0,
    _dragOffsetY = 0,
    _lastDragX = 0,
    _lastDragY = 0,

    _wasMouseDown = false,
    _clickTween = nil,
    _hoverCursor = nil,
    _spriteOverride = nil,

    _dragLineElements = {},
    _dragLineActiveCount = 0,

    _dragLineAnchorX = 0,
    _dragLineAnchorY = 0
}

local function _lerpAngle(currentAngle, targetAngle, lerpFactor)
    local angleDelta = (targetAngle - currentAngle) % 360
    if angleDelta > 180 then angleDelta = angleDelta - 360 end

    return currentAngle + angleDelta * lerpFactor
end

local function _loadSprites()
    for _, fileName in pairs(love.filesystem.getDirectoryItems(CONSTANTS.CURSOR_SPRITE_PATH)) do
        local spriteName = fileName:match("^(.-)%.png$")
        if not spriteName then goto continue end

        Module._sprites[spriteName] = RenderElementModule:PreloadSprite(
            CONSTANTS.CURSOR_SPRITE_PATH .. fileName
        )

        :: continue ::
    end
end

local function _createDragLineDot(dotIndex, x, y)
    return RenderElementModule.new({
        name = "cursorDragLine" .. dotIndex,
        type = "sprite",

        spritePath = CONSTANTS.CURSOR_DRAG_LINE_SPRITE_PATH,

        x = x,
        y = y,

        anchorX = .5,
        anchorY = .5,

        zIndex = CONSTANTS.CURSOR_Z_INDEX - 1
    })
end

local function _hideDragLine()
    for _, dotElement in pairs(Module._dragLineElements) do
        dotElement:Remove()
    end

    Module._dragLineElements = {}
    Module._dragLineActiveCount = 0
end

local function _removeTrailingDragLineDots(requiredDotCount)
    while Module._dragLineActiveCount > requiredDotCount do
        local dotIndex = Module._dragLineActiveCount
        local dotElement = Module._dragLineElements[dotIndex]

        dotElement:Remove()

        Module._dragLineElements[dotIndex] = nil
        Module._dragLineActiveCount = dotIndex - 1
    end
end

local function _getCursorCenterPosition(x, y)
    local element = Module._element

    local cursorWidth = element.drawable:getWidth()
    local cursorHeight = element.drawable:getHeight()

    local anchorX = element.anchorX or 0
    local anchorY = element.anchorY or 0

    return x + (.5 - anchorX) * cursorWidth * element.scaleX,
           y + (.5 - anchorY) * cursorHeight * element.scaleY
end

local function _getCursorBottomPosition(x, y)
    local element = Module._element

    local width, height = element:GetDimensions()
    local anchorX, anchorY = element.anchorX, element.anchorY

    local localX = (.5 - anchorX) * width
    local localY = (.5 - anchorY) * height

    local rotation = math.rad(element.rotation)
    local cosRotation, sinRotation = math.cos(rotation), math.sin(rotation)

    return x + (localX * cosRotation - localY * sinRotation),
           y + (localX * sinRotation + localY * cosRotation)
end

local function _getDragLineOrigin(animationsEnabled)
    local element = Module._element
    local x, y = element.x, element.y

    if animationsEnabled then
        return _getCursorBottomPosition(x, y)
    end

    return _getCursorCenterPosition(x, y)
end

local function _updateDragLine(animationsEnabled)
    if not Module._dragging then
        _hideDragLine()
        return
    end

    local mouseX, mouseY = RenderUtilsModule.GetScaledMousePosition()
    local currentStartX, currentStartY = _getDragLineOrigin(animationsEnabled)

    Module._dragLineAnchorX = currentStartX
    Module._dragLineAnchorY = currentStartY

    local totalDeltaX = mouseX - currentStartX
    local totalDeltaY = mouseY - currentStartY

    local rawTotalDistance = math.distance2D(
        currentStartX,
        currentStartY,

        mouseX,
        mouseY
    )

    local directionX, directionY = 0, 0

    if rawTotalDistance > 0 then
        directionX = totalDeltaX / rawTotalDistance
        directionY = totalDeltaY / rawTotalDistance
    end

    local projection = math.max(
        0,
        totalDeltaX * directionX + totalDeltaY * directionY
    )

    local requiredDotCount = math.max(
        CONSTANTS.CURSOR_DRAG_LINE_MIN_DOTS,
        math.floor(projection / CONSTANTS.CURSOR_DRAG_LINE_SPACING) + 1
    )

    _removeTrailingDragLineDots(requiredDotCount)

    while Module._dragLineActiveCount < requiredDotCount do
        local newDotIndex = Module._dragLineActiveCount + 1

        local newDot = _createDragLineDot(
            newDotIndex,
            currentStartX,
            currentStartY
        )

        Module._dragLineElements[newDotIndex] = newDot
        Module._dragLineActiveCount = newDotIndex
    end

    for index = 1, Module._dragLineActiveCount do
        local dot = Module._dragLineElements[index]

        if index == Module._dragLineActiveCount then
            dot.x = currentStartX + directionX * rawTotalDistance
            dot.y = currentStartY + directionY * rawTotalDistance

            dot.render = not Module._element:IsPointInside(dot.x, dot.y)
        else
            local targetDistance = index * CONSTANTS.CURSOR_DRAG_LINE_SPACING

            dot.x = currentStartX + directionX * targetDistance
            dot.y = currentStartY + directionY * targetDistance

            dot.render = true
        end
    end
end

function Module:SetSprite(spriteName, force)
    if self._dragging and not force then return end

    spriteName = spriteName or CONSTANTS.CURSOR_DEFAULT_NAME
    local drawable = self._sprites[spriteName] or self._sprites[CONSTANTS.CURSOR_DEFAULT_NAME]
    if not drawable then return end

    if self._spriteName == spriteName then return end

    self._spriteName = spriteName
    self._element:ChangeSprite(
        CONSTANTS.CURSOR_SPRITE_PATH .. spriteName .. ".png"
    )
end

function Module:SetSpriteOverride(spriteName)
    self._spriteOverride = spriteName
end

function Module:ClearSpriteOverride()
    self._spriteOverride = nil
end

function Module:SetHovering(hoveringCursor)
    if self._dragging then return end
    self._hoverCursor = hoveringCursor
end

function Module:ResetRotation()
    if self._element then self._element.rotation = 0 end
end

function Module:Click()
    if not self._element or not SettingsModule:Get("graphics.cursorAnimationsEnabled") then return end

    if self._clickTween then
        self._clickTween:Cancel()
    end

    local baseScale = CONSTANTS.CURSOR_SCALE
    local squashScale = CONSTANTS.CURSOR_CLICK_SQUASH

    self._element.scaleX = baseScale * squashScale
    self._element.scaleY = baseScale * squashScale

    self._clickTween = TweenHandlerModule.new(
        self._element,
        { scaleX = baseScale, scaleY = baseScale },
        CONSTANTS.CURSOR_CLICK_RECOVERY_DURATION,
        CONSTANTS.CURSOR_CLICK_EASING
    )
end

function Module:SetDragging(dragging, element, mouseX, mouseY)
    if not self._element then return end

    self._dragging = dragging
    self:SetSprite(dragging and "grabbing" or nil, true)

    if not dragging then
        self._dragOffsetX, self._dragOffsetY = 0, 0
        self._lastDragX, self._lastDragY = 0, 0
        self._element.anchorX = 0

        _hideDragLine()
        return
    end

    self._dragOffsetX = mouseX - element.x
    self._dragOffsetY = mouseY - element.y

    self._element.x = mouseX
    self._element.y = mouseY

    self._lastDragX = element.x
    self._lastDragY = element.y

    self._element.anchorX = .5
    self._dragLineAnchorX, self._dragLineAnchorY = _getDragLineOrigin(SettingsModule:Get("graphics.cursorAnimationsEnabled"))

    _hideDragLine()
end

function Module:UpdateDragging(element, deltaTime)
    if not self._dragging or not element or not self._element then return end

    self._element.x = element.x + self._dragOffsetX
    self._element.y = element.y + self._dragOffsetY

    local animationsEnabled = SettingsModule:Get("graphics.cursorAnimationsEnabled")

    if animationsEnabled then
        local mouseX, mouseY = RenderUtilsModule.GetScaledMousePosition()
        local directionX = self._element.x - mouseX
        local directionY = self._element.y - mouseY

        if directionX ~= 0 or directionY ~= 0 then
            local targetRotation = math.deg(math.atan2(directionY, directionX)) + 90
            local lerpFactor = 1 - math.exp(-CONSTANTS.CURSOR_ROTATION_LERP_SPEED * deltaTime)

            self._element.rotation = _lerpAngle(self._element.rotation, targetRotation, lerpFactor)
        end
    end

    self._lastDragX = element.x
    self._lastDragY = element.y

    _updateDragLine(animationsEnabled)
end

function Module:Update(deltaTime)
    if not self._element then return end

    if not self._dragging then
        local targetSprite = self._spriteOverride or self._hoverCursor or CONSTANTS.CURSOR_DEFAULT_NAME
        self:SetSprite(targetSprite, true)
    end

    self._hoverCursor = nil

    local mouseDown = love.mouse.isDown(1)
    if mouseDown and not self._wasMouseDown then
        self:Click()
    end
    self._wasMouseDown = mouseDown

    if self._dragging then return end

    local targetX, targetY = RenderUtilsModule.GetScaledMousePosition()
    local animationsEnabled = SettingsModule:Get("graphics.cursorAnimationsEnabled")

    if not animationsEnabled then
        self._element.x = targetX
        self._element.y = targetY

        self._element.rotation = 0
        self._element.anchorX = 0

        return
    end

    local lerpFactor = 1 - math.exp(-CONSTANTS.CURSOR_ROTATION_LERP_SPEED * deltaTime)
    local velocityX = targetX - self._element.x
    local velocityY = targetY - self._element.y

    local targetRotation = math.clamp(
        (velocityX + velocityY) * CONSTANTS.CURSOR_TILT_MULTIPLIER,
        -CONSTANTS.CURSOR_MAX_TILT,
        CONSTANTS.CURSOR_MAX_TILT
    )

    self._element.x = self._element.x + velocityX * lerpFactor
    self._element.y = self._element.y + velocityY * lerpFactor

    self._element.rotation = _lerpAngle(self._element.rotation, targetRotation, lerpFactor)
    self._element.anchorX = 0
end

function Module.Init()
    love.mouse.setVisible(false)
    _loadSprites()

    local defaultSprite = Module._sprites[CONSTANTS.CURSOR_DEFAULT_NAME]
    if not defaultSprite then return end

    Module._spriteName = CONSTANTS.CURSOR_DEFAULT_NAME

    Module._element = RenderElementModule.new({
        name = "cursor",
        type = "sprite",

        spritePath = CONSTANTS.CURSOR_SPRITE_PATH .. CONSTANTS.CURSOR_DEFAULT_NAME .. ".png",

        x = 0,
        y = 0,

        anchorX = 0,
        anchorY = 0,

        scaleX = CONSTANTS.CURSOR_SCALE,
        scaleY = CONSTANTS.CURSOR_SCALE,

        zIndex = CONSTANTS.CURSOR_Z_INDEX,
        render = true
    })

    Module._element.drawable = defaultSprite
end

return Module