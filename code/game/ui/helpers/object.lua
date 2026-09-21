-- ~/code/game/ui/helpers/object.lua

local RenderElementModule = require("code.engine.render.element")

local UIScrollingFrameObjectModule = require("code.game.ui.objects.scrollingFrame")
local UIButtonObjectModule = require("code.game.ui.objects.button")

local Module = {}

function Module.CreateElement(elementData, scene)
    local data = {}

    for key, value in pairs(elementData) do
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