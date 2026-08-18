-- ~/code/game/ui/objects/scrollingFrame.lua

local RenderUtilsModule = require("code.engine.render.utils")
local IdManagerModule = require("code.engine.idManager")
local SettingsModule = require("code.engine.saves.settings")

local math = require("code.engine.helpers.math")

local ScrollingFrame = {
    id = 0,

    hitboxElement = {},
    elements = {},

    scrollBarElement = {},
    scrollTrackElement = {},

    padding = 0,

    scrollOffset = 0,
    targetScrollOffset = 0,
    contentHeight = 0,

    scrollSpeed = 30,
    smoothness = 14,

    _isDraggingTrack = false,
    _dragStartY = 0,
    _initialOffsetOnDrag = 0,
    _lastOffset = 0
}
ScrollingFrame.__index = ScrollingFrame

local Module = {}
Module._scrollingFrames = {}

local manager = IdManagerModule:CreateManager()

--- Gets unscaled native height of a sprite/text element for scaling math
local function getUnscaledHeight(element)
    if not element then return 1 end
    if element.type == "sprite" and element.drawable then
        return element.drawable:getHeight()
    elseif element.type == "text" and element.text then
        local font = element.font or love.graphics.getFont()
        return font:getHeight()
    end
    return 1
end

--- Resizes scrollBarElement scaleY based on content vs scrollingFrame view ratio
function ScrollingFrame:_updateScrollBarScale()
    if not (self.scrollBarElement and self.scrollTrackElement and self.hitboxElement) then return end

    local frameHeight = self.hitboxElement:getHeight()
    local trackHeight = self.scrollTrackElement:getHeight()

    if self.contentHeight <= 0 or frameHeight <= 0 then return end

    local visibleRatio = math.min(1, frameHeight / self.contentHeight)
    local targetThumbHeight = trackHeight * visibleRatio
    local unscaledHeight = getUnscaledHeight(self.scrollBarElement)

    if unscaledHeight > 0 then
        self.scrollBarElement.scaleY = targetThumbHeight / unscaledHeight
    end
end

--- Automatically calculates content height from child elements including top & bottom padding
function ScrollingFrame:RecalculateContentHeight(padding)
    self.padding = padding or self.padding or 0
    if #self.elements == 0 then
        self.contentHeight = 0
        self:_updateScrollBarScale()
        return 0
    end

    local minY = math.huge
    local maxY = -math.huge

    for _, element in pairs(self.elements) do
        if element and element.y then
            local elemHeight = element:getHeight()
            local elemTop = element.y
            local elemBottom = element.y + elemHeight

            if elemTop < minY then minY = elemTop end
            if elemBottom > maxY then maxY = elemBottom end
        end
    end

    if minY == math.huge or maxY == -math.huge then
        self.contentHeight = 0
    else
        -- Total content height now adds padding for top AND bottom
        self.contentHeight = (maxY - minY) + (self.padding * 2)
    end

    self:_updateScrollBarScale()
    return self.contentHeight
end

function ScrollingFrame:Remove()
    Module._scrollingFrames[self.id] = nil
    manager:release(self.id)
end

--- Clamps the target scroll offset so it stays within valid bounds [0, maxScroll].
local function clampOffset(self, offset)
    local frameHeight = self.hitboxElement:getHeight()
    local maxScroll = math.max(0, self.contentHeight - frameHeight)

    if offset < 0 then return 0 end
    if offset > maxScroll then return maxScroll end
    return offset
end

--- Internal method to sync child element positions with current scroll offset.
function ScrollingFrame:_updatePositions()
    local delta = self._lastOffset - self.scrollOffset

    -- Calculate screen clipping area of the hitbox/background scrollingFrame
    local frameWidth = self.hitboxElement:getWidth()
    local frameHeight = self.hitboxElement:getHeight()
    local frameAnchorX = self.hitboxElement.anchorX or 0.5
    local frameAnchorY = self.hitboxElement.anchorY or 0.5

    local clipArea = {
        x = self.hitboxElement.x - (frameWidth * frameAnchorX),
        y = self.hitboxElement.y - (frameHeight * frameAnchorY),
        width = frameWidth,
        height = frameHeight
    }

    -- Shift child elements vertically and apply the scissor rectangle
    for _, element in pairs(self.elements) do
        if element then
            if delta ~= 0 and element.y then
                element.y = element.y + delta
            end
            element.scissor = clipArea
        end
    end

    -- Update scrollbar thumb position
    if self.scrollBarElement and self.scrollTrackElement then
        local frameHeight = self.hitboxElement:getHeight()
        local maxScroll = math.max(1, self.contentHeight - frameHeight)
        local progress = self.scrollOffset / maxScroll

        local trackX = self.scrollTrackElement.x
        local trackY = self.scrollTrackElement.y
        local trackWidth = self.scrollTrackElement:getWidth()
        local trackHeight = self.scrollTrackElement:getHeight()

        local thumbWidth = self.scrollBarElement:getWidth()
        local thumbHeight = self.scrollBarElement:getHeight()

        local trackAnchorX = self.scrollTrackElement.anchorX or 0.5
        local trackAnchorY = self.scrollTrackElement.anchorY or 0.5

        local trackTop = trackY - (trackHeight * trackAnchorY)
        local trackRight = trackX + (trackWidth * (1 - trackAnchorX))

        local thumbAnchorX = self.scrollBarElement.anchorX or 0.5
        local thumbAnchorY = self.scrollBarElement.anchorY or 0.5

        self.scrollBarElement.x = trackRight - (thumbWidth * (1 - thumbAnchorX))

        local travelDistance = math.max(0, trackHeight - thumbHeight)
        local topY = trackTop + (thumbHeight * thumbAnchorY)

        self.scrollBarElement.y = topY + (progress * travelDistance)
    end

    self._lastOffset = self.scrollOffset
end

function ScrollingFrame:WheelMoved(x, y)
    local mouseX, mouseY = RenderUtilsModule.GetMousePos()
    if not self.hitboxElement:IsPointInside(mouseX, mouseY) then return end

    self.targetScrollOffset = clampOffset(self, self.targetScrollOffset - (y * self.scrollSpeed))
end

function ScrollingFrame:MousePressed(x, y, button)
    if button ~= 1 then return end

    if self.scrollBarElement and self.scrollBarElement:IsPointInside(x, y) then
        self._isDraggingTrack = true
        self._dragStartY = y
        self._initialOffsetOnDrag = self.scrollOffset
    end
end

function ScrollingFrame:MouseReleased(x, y, button)
    if button == 1 then
        self._isDraggingTrack = false
    end
end

function ScrollingFrame:Update(deltaTime)
    if not self.hitboxElement then self:Remove() return end

    if self._isDraggingTrack and self.scrollTrackElement and self.scrollBarElement then
        local _, mouseY = RenderUtilsModule.GetMousePos()
        local dragDelta = mouseY - self._dragStartY

        local _, trackHeight = self.scrollTrackElement:GetDimensions()
        local _,  thumbHeight = self.scrollBarElement:GetDimensions()
        local travelDistance = math.max(1, trackHeight - thumbHeight)

        local _, frameHeight = self.hitboxElement:GetDimensions()
        local maxScroll = math.max(0, self.contentHeight - frameHeight)

        local scrollDelta = (dragDelta / travelDistance) * maxScroll
        self.targetScrollOffset = clampOffset(self, self._initialOffsetOnDrag + scrollDelta)
    end

    local animationsEnabled = SettingsModule.loadedFile and
        SettingsModule.loadedFile.graphics and
        SettingsModule.loadedFile.graphics.animationsEnabled

    if animationsEnabled then
        local lerpFactor = math.min(1, self.smoothness * deltaTime)
        self.scrollOffset = self.scrollOffset + (self.targetScrollOffset - self.scrollOffset) * lerpFactor
    else
        self.scrollOffset = self.targetScrollOffset
    end

    self:_updatePositions()
end

function Module:CreateScrollingFrame(data)
    if not data or not data.hitboxElement then return end

    local padding = data.padding or 0

    local scrollingFrame = setmetatable({
        id = manager:Get(),

        hitboxElement = data.hitboxElement,
        elements = data.elements or {},

        scrollBarElement = data.scrollBarElement,
        scrollTrackElement = data.scrollTrackElement,

        padding = padding,

        scrollOffset = 0,
        targetScrollOffset = 0,
        _lastOffset = 0,

        contentHeight = data.contentHeight or 0,
        scrollSpeed = data.scrollSpeed or 35,
        smoothness = data.smoothness or 14
    }, ScrollingFrame)

    -- Offset all initial element positions down by top padding
    if padding > 0 then
        for _, element in pairs(scrollingFrame.elements) do
            if element and element.y then
                element.y = element.y + padding
            end
        end
    end

    if not data.contentHeight then
        scrollingFrame:RecalculateContentHeight(padding)
    else
        scrollingFrame:_updateScrollBarScale()
    end

    Module._scrollingFrames[scrollingFrame.id] = scrollingFrame
    return scrollingFrame
end

function Module:WheelMoved(x, y)
    for _, scrollingFrame in pairs(self._scrollingFrames) do
        scrollingFrame:WheelMoved(x, y)
    end
end

function Module:MousePressed(x, y, button)
    for _, scrollingFrame in pairs(self._scrollingFrames) do
        scrollingFrame:MousePressed(x, y, button)
    end
end

function Module:MouseReleased(x, y, button)
    for _, scrollingFrame in pairs(self._scrollingFrames) do
        scrollingFrame:MouseReleased(x, y, button)
    end
end

function Module:UpdateAll(deltaTime)
    for _, scrollingFrame in pairs(self._scrollingFrames) do
        scrollingFrame:Update(deltaTime)
    end
end

return Module