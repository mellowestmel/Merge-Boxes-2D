-- ~/code/game/ui/cursor.lua

local RenderElementModule = require("code.engine.render.element")
local RenderUtilsModule = require("code.engine.render.utils")
local SettingsModule = require("code.engine.saves.settings")
local TweenHandlerModule = require("code.engine.tweenHandler")

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

    _hoverCursor = nil
}

-- Interpolates between angles using the shortest rotation.
local function _lerpAngle(current, target, factor)
	local difference = (target - current) % 360

	if difference > 180 then
		difference = difference - 360
	end

	return current + difference * factor
end

-- Loads every cursor sprite in the cursor directory.
local function _loadSprites()
	for _, file in ipairs(love.filesystem.getDirectoryItems(CONSTANTS.CURSOR_SPRITE_PATH)) do
		local spriteName = file:match("^(.-)%.png$")

		if spriteName then
			local image = love.graphics.newImage(
				CONSTANTS.CURSOR_SPRITE_PATH .. file
			)

			image:setFilter("nearest", "nearest")
			Module._sprites[spriteName] = image
		end
	end
end

-- Swaps the cursor sprite, falling back to the default if missing.
function Module:ChangeSprite(spriteName)
	spriteName = spriteName or CONSTANTS.CURSOR_DEFAULT_NAME

	-- Already showing this sprite, nothing to do.
	if self._spriteName == spriteName then return end

	local drawable = self._sprites[spriteName]
		or self._sprites[CONSTANTS.CURSOR_DEFAULT_NAME]

	if not drawable then
		return
	end

	self._spriteName = spriteName
	self._element.drawable = drawable
	self._element.spritePath =
		CONSTANTS.CURSOR_SPRITE_PATH .. spriteName .. ".png"
end

-- Stores the requested hover sprite for this frame.
function Module:SetHovering(hoveringCursor)
    self._hoverCursor = hoveringCursor
end

-- Resets cursor rotation back to zero.
function Module:ResetRotation()
	if self._element then
		self._element.rotation = 0
	end
end

-- Punches the cursor down, then tweens it back to normal size.
function Module:Click()
	if not self._element then return end

	local animationsEnabled = SettingsModule:Get("graphics.cursorAnimationsEnabled")
	if not animationsEnabled then return end

	if self._clickTween then
		self._clickTween:Cancel()
	end

	local baseScale = CONSTANTS.CURSOR_SCALE
	local squash = CONSTANTS.CURSOR_CLICK_SQUASH

	self._element.scaleX = baseScale * squash
	self._element.scaleY = baseScale * squash

	self._clickTween = TweenHandlerModule.new(
		self._element,
		{ scaleX = baseScale, scaleY = baseScale },
		CONSTANTS.CURSOR_CLICK_RECOVERY_DURATION,
		CONSTANTS.CURSOR_CLICK_EASING
	)
end

-- Toggles drag state and anchors the cursor to the dragged point.
function Module:SetDragging(dragging, element, mouseX, mouseY)
	if not self._element then return end

	self._dragging = dragging

	self:ChangeSprite(dragging and "grabbing" or CONSTANTS.CURSOR_DEFAULT_NAME)

	if dragging then
		-- Keep the cursor's offset from the grabbed element fixed.
		self._dragOffsetX = mouseX - element.x
		self._dragOffsetY = mouseY - element.y

		self._element.x = mouseX
		self._element.y = mouseY

		self._lastDragX = element.x
		self._lastDragY = element.y

		self._element.anchorX = 0.5
	else
		self._dragOffsetX = 0
		self._dragOffsetY = 0
		self._lastDragX = 0
		self._lastDragY = 0

		self._element.anchorX = 0
	end
end

-- Follows the dragged element and tilts the cursor based on drag velocity.
function Module:UpdateDragging(element, deltaTime)
	if not (self._dragging and element and self._element) then return end

	self._element.x = element.x + self._dragOffsetX
	self._element.y = element.y + self._dragOffsetY

	local deltaX = element.x - self._lastDragX
	local deltaY = element.y - self._lastDragY

	if deltaX ~= 0 or deltaY ~= 0 then
		local targetRotation = math.deg(math.atan2(deltaY, deltaX)) - 90
		local animationsEnabled =
			SettingsModule:Get("graphics.cursorAnimationsEnabled")

		if animationsEnabled then
			local lerpFactor = 1 - math.exp(
				-CONSTANTS.CURSOR_ROTATION_LERP_SPEED * deltaTime
			)

			self._element.rotation = _lerpAngle(
				self._element.rotation,
				targetRotation,
				lerpFactor
			)
		end
	end

	self._lastDragX = element.x
	self._lastDragY = element.y
end

-- Moves the cursor toward the mouse and tilts it while idle (not dragging).
function Module:Update(deltaTime)
    if not self._element then return end

    -- If we aren't dragging, apply the requested hover cursor (or fall back to default)
    if not self._dragging then
        self:ChangeSprite(self._hoverCursor or CONSTANTS.CURSOR_DEFAULT_NAME)
    end
    -- Reset the request for the next frame
    self._hoverCursor = nil

    -- Detect a fresh click for the squash animation, even mid-drag.
    local mouseDown = love.mouse.isDown(1)

	if mouseDown and not self._wasMouseDown then
		self:Click()
	end

	self._wasMouseDown = mouseDown

	if self._dragging then return end

	local targetX, targetY = RenderUtilsModule.GetScaledMousePosition()
	local animationsEnabled =
		SettingsModule:Get("graphics.cursorAnimationsEnabled")

	if animationsEnabled then
		local lerpFactor = 1 - math.exp(
			-CONSTANTS.CURSOR_ROTATION_LERP_SPEED * deltaTime
		)

		local velocityX = targetX - self._element.x
		local velocityY = targetY - self._element.y

		-- Tilt is driven by movement speed, clamped to a max angle.
		local targetRotation = math.max(
			-CONSTANTS.CURSOR_MAX_TILT,
			math.min(
				CONSTANTS.CURSOR_MAX_TILT,
				(velocityX + velocityY) * CONSTANTS.CURSOR_TILT_MULTIPLIER
			)
		)

		self._element.x = self._element.x + velocityX * lerpFactor
		self._element.y = self._element.y + velocityY * lerpFactor

		self._element.rotation = _lerpAngle(
			self._element.rotation,
			targetRotation,
			lerpFactor
		)
	else
		self._element.x = targetX
		self._element.y = targetY
		self._element.rotation = 0
	end

	self._element.anchorX = 0
end

-- Sets up the cursor sprite and render element, hiding the OS cursor.
function Module.Init()
	love.mouse.setVisible(false)
	_loadSprites()

	local defaultSprite = Module._sprites[CONSTANTS.CURSOR_DEFAULT_NAME]
	if not defaultSprite then return end

	Module._spriteName = CONSTANTS.CURSOR_DEFAULT_NAME

	Module._element = RenderElementModule.new({
		name = "cursor",
		type = "sprite",

		spritePath = CONSTANTS.CURSOR_SPRITE_PATH
			.. CONSTANTS.CURSOR_DEFAULT_NAME
			.. ".png",

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