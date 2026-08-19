-- ~/code/game/box/object.lua

local RenderElementModule = require("code.engine.render.element")
local IdManagerModule = require("code.engine.idManager")

local table = require("code.engine.helpers.table")

local CONSTANTS = require("code.game.boxes.constants")

local BoxesData = require("code.data.boxes")

local Box = {}
Box.__index = Box

local Module = {}

Module.renderBoxes = true
Module.boxes = {}

Module._sortedCache = {}
Module._dirty = true

local manager = IdManagerModule.new()

function Box:Remove()
    Module.boxes[self.id] = nil
    Module._dirty = true

    self.element:Remove()
    manager:Release(self.id)
end

function Box:SetZIndex(zIndex)
    if self.element.zIndex == zIndex then
        return
    end

    self.element.zIndex = zIndex
    Module._dirty = true
end

function Box:SetDragging(dragging)
    self.dragging = dragging
end

function Module.GetBoxDataByTier(tier)
    local boxData

    for _, data in pairs(BoxesData) do
        if data.tier == tier then
            boxData = data
            break
        end
    end

    return table.clone(boxData)
end

function Module.GetBoxDataByType(type)
    local boxData = BoxesData[type]
    if not boxData then return end

    return table.clone(boxData)
end

function Module.newElement(data)
    return RenderElementModule.new({
        name = data.name,

        x = data.x or 0,
        y = data.y or 0,

        spritePath = data.spritePath,
        type = "sprite",

        scaleX = data.scale or 1,
        scaleY = data.scale or 1,

        zIndex = data.zIndex or CONSTANTS.BASE_BOX_ZINDEX,

        reflectionPath = data.reflectionPath,
        reflective = data.reflective
    })
end

function Module.new(data)
    if not data then return end

    local element = Module.newElement(data)

    local box = setmetatable({
        id = manager:Get(),
        data = data,

        element = element,

        velocityX = 0,
        velocityY = 0,

        trinkets = {},

        dragging = false,
        merging = false
    }, Box)

    Module.boxes[box.id] = box
    Module._dirty = true

    return box
end

function Module:GetSortedArray()
    if not self._dirty then
        return self._sortedCache
    end

    local array = {}

    for _, box in pairs(self.boxes) do
        table.insert(array, box)
    end

    table.sort(array, function(a, b)
        return a.element.zIndex > b.element.zIndex
    end)

    self._sortedCache = array
    self._dirty = false

    return array
end

function Module:ClearBoxes()
    for _, box in pairs(self:GetSortedArray()) do
        box:Remove()
    end
end

function Module:Update(deltaTime)
    for _, box in pairs(self:GetSortedArray()) do
        if box.onUpdate then
            box.onUpdate(box, deltaTime)
        end

        box.element.render = self.renderBoxes
    end
end

return Module