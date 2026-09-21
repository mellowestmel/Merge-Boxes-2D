-- ~/code/game/box/object.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")

local RenderElementModule = require("code.engine.render.element")
local IdManagerModule = require("code.engine.idManager")



local CONSTANTS = require("code.data.constants")

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
    SignalHandlerModule.Get("game.boxes.removed"):Fire(self)

    Module.boxes[self.id] = nil
    Module._dirty = true

    self.element:Remove()
    manager:Release(self.id)
end

function Box:SetDragging(dragging)
    self.dragging = dragging
end

function Module.GetBoxDataByTier(tier)
    for _, data in pairs(BoxesData) do
        if data.tier == tier then
            return table.clone(data)
        end
    end

    error("No box data found for tier: " .. tostring(tier))
end

function Module.GetBoxDataByType(type)
    local boxData = BoxesData[type]

    assert(boxData, "No box data found for type: " .. tostring(type))

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

        zIndex = data.zIndex or CONSTANTS.BOX.BASE_ZINDEX,

        shaders = data.shaders
    })
end

function Module.new(data)
    assert(data, "Box.new requires data")

    local element = Module.newElement(data)

    local box = setmetatable({
        id = manager:Get(),
        data = data,

        element = element,

        velocityX = 0,
        velocityY = 0,

        items = {},

        dragging = false,

        dragOffsetX = 0,
        dragOffsetY = 0,

        merging = false
    }, Box)

    SignalHandlerModule.Get("game.boxes.spawned"):Fire(box)

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

function Module.Init()
    SignalHandlerModule.Get("engine.saves.fileloaded"):Connect(function(loadedFile)
        local loadedBoxesData = loadedFile.boxes

        if not loadedBoxesData then
            return
        end

        for _, savedBoxData in pairs(loadedBoxesData) do
            local boxData = Module.GetBoxDataByType(savedBoxData.type)

            local box = Module.new(boxData)

            box.element.x = savedBoxData.x
            box.element.y = savedBoxData.y

            box.element.rotation = savedBoxData.rotation

            box.velocityX = savedBoxData.velocityX
            box.velocityY = savedBoxData.velocityY

            box.items = savedBoxData.items
        end
    end)
end

return Module