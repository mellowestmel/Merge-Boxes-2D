local RenderElementModule = require("code.engine.render.element")
local RenderUtilsModule = require("code.engine.render.utils")

local SettingsModule = require("code.engine.saves.settings")

local CURSOR_PATH = "assets/sprites/ui/cursors/"
local DEFAULT_CURSOR = "default"

local Module = {
    updateCursor = true,

    _sprites = {},

    _dragging = false,

    _dragOffsetX = 0,
    _dragOffsetY = 0,

    _lastDragX = 0,
    _lastDragY = 0
}

-- Helper function to lerp angles via the shortest path
local function lerpAngle(current, target, factor)
    local diff = (target - current) % 360
    if diff > 180 then
        diff = diff - 360
    end
    return current + diff * factor
end

local function _loadSprites()
    for _, file in ipairs(love.filesystem.getDirectoryItems(CURSOR_PATH)) do
        local spriteName = file:match("^(.-)%.png$")
        if spriteName then
            local image = love.graphics.newImage(CURSOR_PATH .. file)
            image:setFilter("nearest", "nearest")
            Module._sprites[spriteName] = image
        end
    end
end

function Module:ChangeSprite(spriteName)
    spriteName = spriteName or DEFAULT_CURSOR
    local drawable = self._sprites[spriteName] or self._sprites[DEFAULT_CURSOR]

    if not drawable then return end

    self._spriteName = spriteName
    self._element.drawable = drawable
    self._element.spritePath = CURSOR_PATH .. spriteName .. ".png"
end

function Module:ResetRotation()
    if self._element then
        self._element.rotation = 0
    end
end

function Module:SetDragging(dragging, box, mouseX, mouseY)
    if not self._element then return end

    self._dragging = dragging
    self:ChangeSprite(dragging and "grabbing" or "default")

    if dragging then
        local boxElement = box.element
        self._dragOffsetX = mouseX - boxElement.x
        self._dragOffsetY = mouseY - boxElement.y

        self._element.x, self._element.y = mouseX, mouseY
        self._lastDragX, self._lastDragY = boxElement.x, boxElement.y

        self._element.anchorX = .5
    else
        self._dragOffsetX, self._dragOffsetY = 0, 0
        self._lastDragX, self._lastDragY = 0, 0

        self._element.anchorX = 0
    end
end

function Module:UpdateDragging(box, deltaTime)
    if not (self._dragging and box and self._element) then return end

    local boxElement = box.element
    self._element.x = boxElement.x + self._dragOffsetX
    self._element.y = boxElement.y + self._dragOffsetY

    local deltaX = boxElement.x - self._lastDragX
    local deltaY = boxElement.y - self._lastDragY

    if deltaX ~= 0 or deltaY ~= 0 then
        local targetRotation = math.deg(math.atan2(deltaY, deltaX)) - 90
        local animationsEnabled = SettingsModule.loadedFile.graphics.cursorAnimationsEnabled

        if animationsEnabled then
            local lerpFactor = 1 - math.exp(-25 * deltaTime)
            self._element.rotation = lerpAngle(self._element.rotation, targetRotation, lerpFactor)
        else
            self._element.rotation = targetRotation
        end
    end

    self._lastDragX = boxElement.x
    self._lastDragY = boxElement.y
end

function Module:Update(deltaTime)
    if not (self.updateCursor and self._element) or self._dragging then return end

    local targetX, targetY = RenderUtilsModule.GetScaledMousePosition()
    local animationsEnabled = SettingsModule.loadedFile.graphics.cursorAnimationsEnabled

    if animationsEnabled then
        local lerpFactor = 1 - math.exp(-25 * deltaTime)

        -- Calculate horizontal and vertical velocities
        local velX = targetX - self._element.x
        local velY = targetY - self._element.y

        -- Combine them: moving right (+X) or down (+Y) tilts right/clockwise
        -- Moving left (-X) or up (-Y) tilts left/counter-clockwise
        local combinedVelocity = velX + velY
        local targetRotation = math.max(-25, math.min(25, combinedVelocity * 0.3))

        -- Lerp Position (using the velocities we just calculated)
        self._element.x = self._element.x + velX * lerpFactor
        self._element.y = self._element.y + velY * lerpFactor

        -- Lerp Rotation towards the tilt target
        self._element.rotation = lerpAngle(self._element.rotation, targetRotation, lerpFactor)
    else
        -- If animations are disabled, snap instantly to position and stay upright
        self._element.x = targetX
        self._element.y = targetY
        self._element.rotation = 0
    end

    self._element.anchorX = 0
end

function Module.Init()
    love.mouse.setVisible(false)
    _loadSprites()

    local defaultSprite = Module._sprites[DEFAULT_CURSOR]
    if not defaultSprite then return end

    Module._spriteName = DEFAULT_CURSOR

    Module._element = RenderElementModule.new({
        name = "cursor",
        type = "sprite",

        spritePath = CURSOR_PATH .. DEFAULT_CURSOR .. ".png",

        x = 0,
        y = 0,

        anchorX = 0,
        anchorY = 0,

        scaleX = .75,
        scaleY = .75,

        zIndex = 999999,

        render = true
    })

    Module._element.drawable = defaultSprite
end

return Module