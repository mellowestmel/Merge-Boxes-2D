-- ~/code/game/boxes/dragHandler.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")
local RenderUtilsModule = require("code.engine.render.utils")

local CONSTANTS = require("code.game.boxes.constants")
local BoxesObjectModule = require("code.game.boxes.object")
local UICursorModule = require("code.game.ui.cursor")

local Module = {}

Module._wasMouseDown = false
Module.draggedBox = nil

-- Alpha to restore to a box once it's released.
local _lastDraggedBoxAlpha = 0

-- Returns the topmost draggable box under (x, y), or nil.
local function _findDraggableBoxAt(boxesArray, x, y)
	for index = 1, #boxesArray do
		local box = boxesArray[index]

		if box.data.draggable then
			-- Reset stacking order before hit-testing.
			box.element:SetZIndex(CONSTANTS.BASE_BOX_ZINDEX)

			if box.element:IsPointInside(x, y) then
				return box
			end
		end
	end
end

-- Returns true if any draggable box is under (x, y).
local function _isHoveringDraggableBox(boxesArray, x, y)
	for index = 1, #boxesArray do
		local box = boxesArray[index]

		if box.data.draggable and box.element:IsPointInside(x, y) then
			return true
		end
	end

	return false
end

-- Begins dragging the given box.
function Module:_StartDrag(box, mouseX, mouseY)
	SignalHandlerModule.Get("game.boxes.dragstarted"):Fire(box)

	self.draggedBox = box
	self.draggedBox.dragging = true

	-- Preserve the exact point where the box was grabbed.
	box.dragOffsetX = mouseX - box.element.x
	box.dragOffsetY = mouseY - box.element.y

	_lastDraggedBoxAlpha = box.element.color.alpha
	box.element.color.alpha = CONSTANTS.DRAGGED_BOX_ALPHA

	-- Bring the dragged box above everything else.
	box.element:SetZIndex(CONSTANTS.BASE_BOX_ZINDEX + 2)

	UICursorModule:SetDragging(true, box.element, mouseX, mouseY)
end

-- Ends dragging and restores the box's original state.
function Module:_EndDrag()
	local box = self.draggedBox

	SignalHandlerModule.Get("game.boxes.dragended"):Fire(box)

	box.element.color.alpha = _lastDraggedBoxAlpha
	box.element:SetZIndex(CONSTANTS.BASE_BOX_ZINDEX + 1)
	box.dragging = false

	UICursorModule:SetDragging(false)

	self.draggedBox = nil
end

function Module:Update(deltaTime)
	local mouseDown = love.mouse.isDown(1)
	local mouseX, mouseY = RenderUtilsModule.GetScaledMousePosition()
	local boxesArray = BoxesObjectModule:GetSortedArray()

	-- Start a new drag on mouse-down over a draggable box.
	if mouseDown and not self.draggedBox then
		local hoveredBox = _findDraggableBoxAt(boxesArray, mouseX, mouseY)

		if hoveredBox then
			self:_StartDrag(hoveredBox, mouseX, mouseY)
		end

	-- Release the current drag on mouse-up.
	elseif not mouseDown and self.draggedBox then
		self:_EndDrag()
	end

	if self.draggedBox then
        UICursorModule:UpdateDragging(self.draggedBox.element, deltaTime)
    else
        local hovering = _isHoveringDraggableBox(boxesArray, mouseX, mouseY)

        if hovering then
            UICursorModule:SetHovering("grabable")
        end
    end

	self._wasMouseDown = mouseDown
end

return Module