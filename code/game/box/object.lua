-- ~/code/game/box/object.lua

--/// ENGINE \\\--
local RenderModule = require("code.engine.render")
local IdManagerModule = require("code.engine.idManager")

--// HELPERS \\--
local table = require("code.engine.helpers.table")

-- // BOX \\--
local CONSTANTS = require("code.game.box.constants")

--/// DATA \\\--
local BoxesData = require("code.data.boxes")

local Box = {
    id = 0,
    element = nil,

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

local manager = IdManagerModule:createManager()

function Box:remove()
    local id = self.id

    Module.boxes[id] = nil
    manager:release(id)

    self.element:remove()
end

function Module:getBoxDataByTier(tier)
    local data = BoxesData[tier]
    if not BoxesData[tier] then return end

    local clonedData = table.clone(data)
    return clonedData
end

function Module:createBoxElement(data)
    if not data then return end

    local element = RenderModule:createElement({
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

function Module:createBox(data)
    if not data then return end

    local element = self:createBoxElement(data)

    local box = setmetatable({
        id = manager:get(),
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

    self.boxes[box.id] = box

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

function Module:getSortedArray()
    local array = {}

    for _, box in pairs(self.boxes) do
        table.insert(array, box)
    end

    table.sort(array, function(a, b)
        return a.element.zIndex > b.element.zIndex
    end)

    return array
end

function Module:clearBoxes()
    for _, box in pairs(self:getSortedArray()) do
        box:remove()
    end
end

function Module:update(deltaTime)
    local array = self:getSortedArray()

    for _, box in pairs(array) do
        if box.onUpdateCosmetic then box.onUpdateCosmetic(box.element, deltaTime) end
        if box.onUpdate then box.onUpdate(box, deltaTime) end
        
        box.element.render = self.renderBoxes
    end
end

return Module