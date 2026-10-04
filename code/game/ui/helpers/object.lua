-- ~/code/game/ui/helpers/object.lua

local RenderElementModule = require("code.engine.render.element")

local UIScrollingFrameObjectModule = require("code.game.ui.objects.scrollingFrame")
local UIButtonObjectModule = require("code.game.ui.objects.button")

local Module = {}

-- Creates an element from data and registers it with the scene.
-- `overrides` (optional) is applied on top of a copy of the data.
function Module.CreateElement(elementData, scene, overrides)
    local data = {}

    for key, value in pairs(elementData) do
        data[key] = value
    end

    for key, value in pairs(overrides or {}) do
        data[key] = value
    end

    local element = RenderElementModule.new(data)
    table.insert(scene._elements, element)

    return element
end

function Module.CreateButton(scene, elements, hitboxElement, onClick)
    local button = UIButtonObjectModule.new({
        elements = elements,
        hitboxElement = hitboxElement,
        mouseButton = 1,
        onClick = onClick
    })

    table.insert(scene._objects, button)

    return button
end

-- Creates a hitbox element, an optional label element, and a button using both.
-- `overrides` (optional) is applied to both elements.
-- Returns button, hitbox, label.
function Module.CreateElementButton(scene, hitboxData, labelData, onClick, overrides)
    local hitbox = Module.CreateElement(hitboxData, scene, overrides)
    local label = labelData and Module.CreateElement(labelData, scene, overrides)

    local button = Module.CreateButton(
        scene,
        label and {hitbox, label} or {hitbox},
        hitbox,
        onClick
    )

    return button, hitbox, label
end

function Module.CreateScrollingFrame(scene, background, scrollBar, elements, padding)
    local scrollingFrame = UIScrollingFrameObjectModule.new({
        hitboxElement = background,
        scrollTrackElement = background,
        scrollBarElement = scrollBar,

        elements = elements,
        padding = padding
    })

    table.insert(scene._objects, scrollingFrame)

    return scrollingFrame
end

function Module.CleanScene(scene)
    for _, element in pairs(scene._elements) do
        element:Remove()
    end

    for _, object in pairs(scene._objects) do
        object:Remove()
    end

    scene._elements = {}
    scene._objects = {}
end

return Module