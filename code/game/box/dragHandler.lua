-- ~/code/game/box/dragHandler.lua

local RenderUtilsModule = require("code.engine.render.utils")

local CONSTANTS = require("code.game.box.constants")
local BoxesObjectModule = require("code.game.box.object")

local Module = {}
Module._wasMouseDown = false
Module.draggedBox = nil

local lastDraggedBoxAlpha = 0

function Module:Update()
    local mouseDown = love.mouse.isDown(1)
    local mouseX, mouseY = RenderUtilsModule.GetMousePos()

    local boxesArray = BoxesObjectModule:GetSortedArray()

    if mouseDown and not self.draggedBox then
        for index = 1, #boxesArray do
            local box = boxesArray[index]
            box.element.zIndex = CONSTANTS.BASE_BOX_ZINDEX

            if box.element:IsPointInside(mouseX, mouseY) then
                self.draggedBox = box
                self.draggedBox.dragging = true

                lastDraggedBoxAlpha = box.element.color.alpha
                box.element.color.alpha = CONSTANTS.DRAGGED_BOX_ALPHA

                box.element.zIndex = CONSTANTS.BASE_BOX_ZINDEX + 2
                break
            end
        end
    elseif not mouseDown and self.draggedBox then
        self.draggedBox.element.color.alpha = lastDraggedBoxAlpha
        self.draggedBox.element.zIndex = CONSTANTS.BASE_BOX_ZINDEX + 1

        self.draggedBox.dragging = false
        self.draggedBox = nil
    end

    self._wasMouseDown = mouseDown
end

return Module