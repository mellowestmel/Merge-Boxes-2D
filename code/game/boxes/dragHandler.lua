local SignalHandlerModule = require("code.engine.events.signalHandler")
local RenderUtilsModule = require("code.engine.render.utils")

local CONSTANTS = require("code.game.boxes.constants")
local BoxesObjectModule = require("code.game.boxes.object")
local UICursorModule = require("code.game.ui.cursor")

local Module = {}
Module._wasMouseDown = false
Module.draggedBox = nil

local lastDraggedBoxAlpha = 0

function Module:Update(deltaTime)
	local mouseDown = love.mouse.isDown(1)
	local mouseX, mouseY = RenderUtilsModule.GetScaledMousePosition()

	local boxesArray = BoxesObjectModule:GetSortedArray()

	if mouseDown and not self.draggedBox then
		local hoveredDraggableBox = nil

		for index = 1, #boxesArray do
			local box = boxesArray[index]

			if box.data.draggable then
				box.element:SetZIndex(CONSTANTS.BASE_BOX_ZINDEX)

				if box.element:IsPointInside(mouseX, mouseY) then
					hoveredDraggableBox = box
					break
				end
			end
		end

		if hoveredDraggableBox then
			local box = hoveredDraggableBox

			SignalHandlerModule.Get("game.boxes.dragstarted"):Fire(box)

			self.draggedBox = box
			self.draggedBox.dragging = true

			lastDraggedBoxAlpha = box.element.color.alpha
			box.element.color.alpha = CONSTANTS.DRAGGED_BOX_ALPHA

			box.element:SetZIndex(CONSTANTS.BASE_BOX_ZINDEX + 2)

			UICursorModule:SetDragging(true, box, mouseX, mouseY)
		end
	elseif not mouseDown and self.draggedBox then
		SignalHandlerModule.Get("game.boxes.dragended"):Fire(self.draggedBox)

		self.draggedBox.element.color.alpha = lastDraggedBoxAlpha
		self.draggedBox.element:SetZIndex(CONSTANTS.BASE_BOX_ZINDEX + 1)

		self.draggedBox.dragging = false

		UICursorModule:SetDragging(false)

		self.draggedBox = nil
	end

	if self.draggedBox then
		UICursorModule:UpdateDragging(self.draggedBox, deltaTime)
	else
		local hoveringDraggableBox = false

		for index = 1, #boxesArray do
			local box = boxesArray[index]

			if box.data.draggable
				and box.element:IsPointInside(mouseX, mouseY) then

				hoveringDraggableBox = true
				break
			end
		end

		if hoveringDraggableBox then
			UICursorModule:ChangeSprite("grabbable")
		else
			UICursorModule:ChangeSprite("default")
		end
	end

	self._wasMouseDown = mouseDown
end

return Module