-- ~/code/engine/renderer/render.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")
local ShaderModule = require("code.engine.shader")
local SettingsModule = require("code.engine.saves.settings")
local ColorblindData = require("code.data.colorblind")
local RenderElementModule = require("code.engine.render.element")

local Module = {}
Module._sortedCache = {}

-- Calculates sort order based on zIndex and element ID ties
local function _getSortOrder(element)
    return element.zIndex + ((element.id / 1000) % 1)
end

function Module:Draw()
    -- Rebuild sorted cache only when element hierarchy changes
    if RenderElementModule._dirty then
        local sortedElements = {}
        for _, element in pairs(RenderElementModule._elements) do
            table.insert(sortedElements, element)
        end

        table.sort(sortedElements, function(a, b)
            return _getSortOrder(a) < _getSortOrder(b)
        end)

        self._sortedCache = sortedElements
        RenderElementModule._dirty = false
    end

    -- Compute resolution scale & letterbox offsets
    local currentWindowWidth, currentWindowHeight = love.graphics.getDimensions()
    local baseWindowWidth, baseWindowHeight = RESOLUTION_WIDTH, RESOLUTION_HEIGHT

    local windowScaleX = currentWindowWidth / baseWindowWidth
    local windowScaleY = currentWindowHeight / baseWindowHeight
    local windowScaleFactor = math.min(windowScaleX, windowScaleY)

    local windowOffsetX = (currentWindowWidth - baseWindowWidth * windowScaleFactor) / 2
    local windowOffsetY = (currentWindowHeight - baseWindowHeight * windowScaleFactor) / 2

    -- Clip rendering to letterbox viewport
    love.graphics.setScissor(windowOffsetX, windowOffsetY, baseWindowWidth * windowScaleFactor, baseWindowHeight * windowScaleFactor)

    -- Update accessibility shaders
    local accessibility = SettingsModule.loadedFile.accessibility
    local graphics = SettingsModule.loadedFile.graphics

    ShaderModule:Send("accessibility", "contrast", graphics.contrast)
    ShaderModule:Send("accessibility", "gamma", graphics.gamma)
    ShaderModule:Send("accessibility", "enableColorblind", accessibility.colorblindMode ~= "none")

    if accessibility.colorblindMode ~= "none" then
        ShaderModule:Send("accessibility", "colorMatrix", ColorblindData[accessibility.colorblindMode])
    end

    -- Render scene through accessibility shader
    ShaderModule:With("accessibility", function()
        for _, element in pairs(self._sortedCache) do
            element:Draw(windowScaleFactor, windowOffsetX, windowOffsetY)
        end
    end)

    -- Clear scissor and reset global color to default
    love.graphics.setScissor()
    love.graphics.setColor(1, 1, 1, 1)
end

function Module:Update()
    local fullscreen = SettingsModule.loadedFile.graphics.fullscreen
    local vsync = SettingsModule.loadedFile.graphics.vsync

    love.window.setFullscreen(fullscreen)
    love.window.setVSync(vsync)
end

function Module.Init()
    SignalHandlerModule.Get("love.update"):Connect(function()
        Module:Update()
    end)

    SignalHandlerModule.Get("love.draw"):Connect(function()
        Module:Draw()
    end)

    ShaderModule:Load(
        "accessibility",
        "code/data/shaders/accessibility.glsl"
    )
end

return Module