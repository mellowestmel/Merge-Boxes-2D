-- ~/code/game/box/object.lua

local RenderElementModule = require("code.engine.render.element")
local IdManagerModule = require("code.engine.idManager")

local table = require("code.engine.helpers.table")

local CONSTANTS = require("code.game.box.constants")

local BoxesData = require("code.data.boxes")

local Box = {
    id = 0,
    element = {},

    dragging = false,
    merging = false,

    description = "",
    quote = "",
    name = "",

    screenFlashColor = nil,
    screenFlashFadeDuration = 2,
    flashScreen = false,

    onUpdateCosmetic = nil,
    onUpdate = nil,

    mergeSoundData = {},

    reflectionPath = "",
    reflective = false,

    weight = 0,
    tier = 1,

    velocityX = 0,
    velocityY = 0,
}
Box.__index = Box

local Module = {}
Module.renderBoxes = true
Module.boxes = {}

Module._sortedCache = {}
Module._dirty = true

local manager = IdManagerModule:CreateManager()

function Box:Remove()
    local id = self.id

    Module.boxes[id] = nil
    Module._dirty = true
    manager:Release(id)

    self.element:Remove()
end

function Module:GetBoxDataByTier(tier)
    local data = BoxesData[tier]
    if not BoxesData[tier] then return end

    local clonedData = table.clone(data)
    return clonedData
end

function Module:CreateBoxElement(data)
    if not data then return end

    local element = RenderElementModule.new({
        x = data.x or 0,
        y = data.y or 0,
        spritePath = data.spritePath,
        type = "sprite",
        scaleX = data.scale,
        scaleY = data.scale,
        zIndex = CONSTANTS.BASE_BOX_ZINDEX,
        reflective = data.reflective,
        reflectionPath = data.reflectionPath
    })

    return element
end

function Module.new(data)
    if not data then return end

    local element = Module:CreateBoxElement(data)

    local box = setmetatable({
        id = manager:Get(),
        element = element,

        dragging = false,
        merging = false,

        description = data.description,
        quote = data.quote,
        name = data.name,

        screenFlashColor = data.screenFlashColor or nil,
        screenFlashFadeDuration = data.screenFlashFadeDuration or 2,
        flashScreen = data.flashScreen or false,

        onUpdateCosmetic = data.onUpdateCosmetic or nil,
        onUpdate = data.onUpdate or nil,

        mergeSoundData = data.mergeSoundData or {soundPath = "assets/sounds/merge/default.wav"},

        mergeReward = data.mergeReward or 50,

        weight = data.weight,
        tier = data.tier,

        velocityX = 0,
        velocityY = 0,
    }, Box)

    Module.boxes[box.id] = box
    Module._dirty = true

    box._scaleTween = {
        startX = data.scale * CONSTANTS.SPAWN_SCALE_MULTIPLIER,
        startY = data.scale * CONSTANTS.SPAWN_SCALE_MULTIPLIER,
        targetX = data.scale,
        targetY = data.scale,
        timeSinceStart = 0,
        duration = CONSTANTS.BASE_SCALE_TWEEN_DURATION
    }

    return box
end

function Module:GetSortedArray()
    if not self._dirty then return self._sortedCache end

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
    local array = self:GetSortedArray()

    for _, box in pairs(array) do
        if box.onUpdateCosmetic then box.onUpdateCosmetic(box.element, deltaTime) end
        if box.onUpdate then box.onUpdate(box, deltaTime) end

        box.element.render = self.renderBoxes
    end
end

return Module