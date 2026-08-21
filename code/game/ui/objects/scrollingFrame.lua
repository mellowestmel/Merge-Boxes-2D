-- ~/code/game/ui/objects/scrollingFrame.lua

local RenderUtilsModule = require("code.engine.render.utils")
local IdManagerModule = require("code.engine.idManager")
local SettingsModule = require("code.engine.saves.settings")
local UICursorModule = require("code.game.ui.cursor")

local math = require("code.engine.helpers.math")

local ScrollingFrame = {}
ScrollingFrame.__index = ScrollingFrame

local Module = {}
Module._scrollingFrames = {}

local manager = IdManagerModule.new()

-- Gets an element's height without its scale.
local function _getUnscaledHeight(element)
	if not element then
		return 1
	end

	if element.type == "sprite" and element.drawable then
		return element.drawable:getHeight()
	end

	if element.type == "text" and element.text then
		return (element.font or love.graphics.getFont()):getHeight()
	end

	return 1
end

-- Keeps the scroll offset inside the content.
local function _clampOffset(self, offset)
	local maxScroll = math.max(
		0,
		self.contentHeight - self.hitboxElement:GetHeight()
	)

	return math.max(0, math.min(offset, maxScroll))
end

-- Updates the scrollbar thumb size.
local function _updateScrollBar(self)
	if not self.scrollBarElement or not self.scrollTrackElement then
		return
	end

	local frameHeight = self.hitboxElement:GetHeight()
	local trackHeight = self.scrollTrackElement:GetHeight()

	if frameHeight <= 0 or self.contentHeight <= 0 then
		return
	end

	local ratio = math.min(1, frameHeight / self.contentHeight)
	local thumbHeight = trackHeight * ratio
	local unscaledHeight = _getUnscaledHeight(self.scrollBarElement)

	if unscaledHeight > 0 then
		self.scrollBarElement.scaleY = thumbHeight / unscaledHeight
	end
end

-- Updates the content and scrollbar positions.
local function _updatePositions(self)
	local delta = self._lastOffset - self.scrollOffset

	local frameWidth = self.hitboxElement:GetWidth()
	local frameHeight = self.hitboxElement:GetHeight()

	local clipArea = {
		x = self.hitboxElement.x
			- frameWidth * (self.hitboxElement.anchorX or .5),

		y = self.hitboxElement.y
			- frameHeight * (self.hitboxElement.anchorY or .5),

		width = frameWidth,
		height = frameHeight
	}

	for _, element in pairs(self.elements) do
		if element then
			element.y = element.y + delta
			element.scissor = clipArea
		end
	end

	if self.scrollBarElement and self.scrollTrackElement then
		local maxScroll = math.max(1, self.contentHeight - frameHeight)
		local progress = self.scrollOffset / maxScroll

		local track = self.scrollTrackElement
		local thumb = self.scrollBarElement

		local trackHeight = track:GetHeight()
		local trackWidth = track:GetWidth()
		local thumbHeight = thumb:GetHeight()
		local thumbWidth = thumb:GetWidth()

		local trackTop = track.y - trackHeight * (track.anchorY or .5)
		local trackRight = track.x + trackWidth * (1 - (track.anchorX or .5))

		local travel = math.max(0, trackHeight - thumbHeight)

		thumb.x = trackRight - thumbWidth * (1 - (thumb.anchorX or .5))
		thumb.y = trackTop + thumbHeight * (thumb.anchorY or .5) + progress * travel
	end

	self._lastOffset = self.scrollOffset

	return delta
end

-- Puts the cursor into the grabbing state at the drag's starting point.
local function _startDrag(self, x, y)
	self._dragStartY = y
	self._initialOffsetOnDrag = self.scrollOffset

	self._dragCursorElement.x = x
	self._dragCursorElement.y = y

	UICursorModule:SetDragging(true, self._dragCursorElement, x, y)
end

-- Restores the cursor once dragging stops.
local function _stopDrag(self)
	UICursorModule:SetDragging(false)
end

-- Checks whether any child element is under (x, y).
local function _isHoveringElement(self, x, y)
	for _, element in pairs(self.elements) do
		if element and element:IsPointInside(x, y) then
			return true
		end
	end

	return false
end

-- Calculates how much space the content takes.
function ScrollingFrame:RecalculateContentHeight()
	if #self.elements == 0 then
		self.contentHeight = 0
		_updateScrollBar(self)

		return 0
	end

	local minY = math.huge
	local maxY = -math.huge

	for _, element in pairs(self.elements) do
		if element and element.y then
			minY = math.min(minY, element.y)
			maxY = math.max(maxY, element.y + element:GetHeight())
		end
	end

	self.contentHeight = (minY == math.huge)
		and 0
		or (maxY - minY + self.padding * 2)

	_updateScrollBar(self)

	return self.contentHeight
end

function ScrollingFrame:Remove()
	Module._scrollingFrames[self.id] = nil
	manager:Release(self.id)
end

function ScrollingFrame:WheelMoved(_, y)
	local mouseX, mouseY = RenderUtilsModule.GetScaledMousePosition()

	if not self.hitboxElement:IsPointInside(mouseX, mouseY) then
		return
	end

	self.targetScrollOffset = _clampOffset(
		self,
		self.targetScrollOffset - y * self.scrollSpeed
	)
end

function ScrollingFrame:MousePressed(_, _, button)
	if button ~= 1 then
		return
	end

	local mouseX, mouseY = RenderUtilsModule.GetScaledMousePosition()
	local isScrollable = self.contentHeight > self.hitboxElement:GetHeight()

	local canGrabBackground = isScrollable
		and self.hitboxElement:IsPointInside(mouseX, mouseY)
		and not _isHoveringElement(self, mouseX, mouseY)

	if canGrabBackground then
		self._isDragging = true
		_startDrag(self, mouseX, mouseY)
	end
end

function ScrollingFrame:MouseReleased(button)
	if button ~= 1 or not self._isDragging then
		return
	end

	self._isDragging = false
	_stopDrag(self)
end

function ScrollingFrame:Update(deltaTime)
	if not self.hitboxElement then
		self:Remove()
		return
	end

	local mouseX, mouseY = RenderUtilsModule.GetScaledMousePosition()

	if self._isDragging then
		local dragDelta = mouseY - self._dragStartY

		-- Background moves with the mouse; scroll offset follows the content.
		self.targetScrollOffset = _clampOffset(
			self,
			self._initialOffsetOnDrag - dragDelta
		)
	else
		local isScrollable = self.contentHeight > self.hitboxElement:GetHeight()

		local hoveringBackground = isScrollable
			and self.hitboxElement:IsPointInside(mouseX, mouseY)
			and not _isHoveringElement(self, mouseX, mouseY)

		if hoveringBackground then
			UICursorModule:SetHovering("grabable")
		end
	end

	local animationsEnabled = SettingsModule.loadedFile.graphics.uiAnimationsEnabled

	if animationsEnabled then
		local alpha = math.min(1, self.smoothness * deltaTime)

		self.scrollOffset = self.scrollOffset
			+ (self.targetScrollOffset - self.scrollOffset) * alpha
	else
		self.scrollOffset = self.targetScrollOffset
	end

	local appliedDelta = _updatePositions(self)

	if self._isDragging then
		-- Cursor follows the content directly, only moving with real scroll movement.
		self._dragCursorElement.y = self._dragCursorElement.y + appliedDelta
		UICursorModule:UpdateDragging(self._dragCursorElement, deltaTime)
	end
end

function Module.new(data)
	if not data or not data.hitboxElement then
		return
	end

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
		contentHeight = data.contentHeight or 0,

		scrollSpeed = data.scrollSpeed or 35,
		smoothness = data.smoothness or 14,

		_isDragging = false,
		_dragCursorElement = { x = 0, y = 0 },

		_dragStartY = 0,
		_initialOffsetOnDrag = 0,
		_lastOffset = 0
	}, ScrollingFrame)

	-- Apply the initial top padding.
	for _, element in pairs(scrollingFrame.elements) do
		if element then
			element.y = element.y + padding
		end
	end

	if data.contentHeight then
		_updateScrollBar(scrollingFrame)
	else
		scrollingFrame:RecalculateContentHeight()
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

function Module:MouseReleased(button)
	for _, scrollingFrame in pairs(self._scrollingFrames) do
		scrollingFrame:MouseReleased(button)
	end
end

function Module:Update(deltaTime)
	for _, scrollingFrame in pairs(self._scrollingFrames) do
		scrollingFrame:Update(deltaTime)
	end
end

return Module