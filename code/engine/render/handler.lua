local SignalHandlerModule = require("code.engine.events.signalHandler")
local ShaderHandlerModule = require("code.engine.shaderHandler")
local SettingsModule = require("code.engine.saves.settings")
local ColorblindData = require("code.data.colorblind")
local RenderElementModule = require("code.engine.render.element")

local Module = {}

Module._sortedCache = {}
Module._bypassCache = {}

Module._sceneCanvas = nil

-- Canvas used for sharp scaling at non-integer window sizes.
Module._prescaleCanvas = nil
Module._prescaleFactor = 0

local function _getSortOrder(element)
    return element.zIndex + ((element.id / 1000) % 1)
end

local function _sortBySortOrder(elements)
    table.sort(elements, function(a, b)
        return _getSortOrder(a) < _getSortOrder(b)
    end)
end

local function _getSceneCanvas()
    if not Module._sceneCanvas then
        Module._sceneCanvas = love.graphics.newCanvas(
            RESOLUTION_WIDTH,
            RESOLUTION_HEIGHT
        )

        Module._sceneCanvas:setFilter("nearest", "nearest")
    end

    return Module._sceneCanvas
end

-- Canvas that holds the scene upscaled by a whole-number factor.
-- Recreated only when the factor changes (e.g. the window is resized).
local function _getPrescaleCanvas(factor)
    if not Module._prescaleCanvas or Module._prescaleFactor ~= factor then
        if Module._prescaleCanvas then
            Module._prescaleCanvas:release()
        end

        Module._prescaleCanvas = love.graphics.newCanvas(
            RESOLUTION_WIDTH * factor,
            RESOLUTION_HEIGHT * factor
        )

        Module._prescaleCanvas:setFilter("linear", "linear")
        Module._prescaleFactor = factor
    end

    return Module._prescaleCanvas
end

function Module:Draw()
    -- Rebuild sorted caches only when element hierarchy changes.
    if RenderElementModule._dirty then
        local sceneElements = {}
        local bypassElements = {}

        for _, element in pairs(RenderElementModule._elements) do
            if element.bypassShaders then
                table.insert(bypassElements, element)
            else
                table.insert(sceneElements, element)
            end
        end

        _sortBySortOrder(sceneElements)
        _sortBySortOrder(bypassElements)

        self._sortedCache = sceneElements
        self._bypassCache = bypassElements
        RenderElementModule._dirty = false
    end

    -- Compute resolution scale & letterbox offsets.
    local currentWindowWidth, currentWindowHeight = love.graphics.getDimensions()

    local windowScaleX = currentWindowWidth / RESOLUTION_WIDTH
    local windowScaleY = currentWindowHeight / RESOLUTION_HEIGHT
    local windowScaleFactor = math.min(windowScaleX, windowScaleY)

    local windowOffsetX =
        (currentWindowWidth - RESOLUTION_WIDTH * windowScaleFactor) / 2

    local windowOffsetY =
        (currentWindowHeight - RESOLUTION_HEIGHT * windowScaleFactor) / 2

    local sceneCanvas = _getSceneCanvas()

    -- Render entire scene at virtual resolution.
    local previousCanvas = love.graphics.getCanvas()
    local previousShader = love.graphics.getShader()

    love.graphics.setCanvas(sceneCanvas)
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setShader()
    love.graphics.setScissor()

    for _, element in ipairs(self._sortedCache) do
        element:Draw()
    end

    -- Update accessibility shaders.
    ShaderHandlerModule:Send("accessibility", "contrast", SettingsModule:Get("graphics.contrast"))
    ShaderHandlerModule:Send("accessibility", "gamma", SettingsModule:Get("graphics.gamma"))

    local colorblindMode = SettingsModule:Get("accessibility.colorblindMode")
    ShaderHandlerModule:Send("accessibility", "enableColorblind", colorblindMode ~= "none")

    if colorblindMode ~= "none" then
        ShaderHandlerModule:Send("accessibility", "colorMatrix", ColorblindData[colorblindMode])
    end

    -- Restore the original render target.
    love.graphics.setCanvas(previousCanvas)
    love.graphics.setShader(previousShader)
    love.graphics.setScissor()

    love.graphics.setColor(1, 1, 1, 1)

    -- Sharp scaling: at whole-number window scales the scene is drawn directly
    -- with nearest filtering. Otherwise it is first upscaled by a whole number
    -- (nearest, so every pixel is the same size), then smoothed down to the
    -- window size (linear, so blur is limited to ~1 screen pixel at texel edges).
    local displayCanvas = sceneCanvas
    local displayScale = windowScaleFactor

    if windowScaleFactor % 1 ~= 0 then
        local factor = math.max(1, math.ceil(windowScaleFactor))
        local prescaleCanvas = _getPrescaleCanvas(factor)

        love.graphics.setCanvas(prescaleCanvas)
        love.graphics.clear(0, 0, 0, 0)
        love.graphics.setShader()

        -- Canvas-to-canvas copy needs premultiplied alpha to avoid darkening.
        love.graphics.setBlendMode("alpha", "premultiplied")
        love.graphics.draw(sceneCanvas, 0, 0, 0, factor, factor)
        love.graphics.setBlendMode("alpha")

        love.graphics.setCanvas(previousCanvas)

        displayCanvas = prescaleCanvas
        displayScale = windowScaleFactor / factor
    end

    -- Draw the scene into the letterboxed window.
    local accessibilityShader =
        ShaderHandlerModule:Get("accessibility")

    if accessibilityShader then
        love.graphics.setShader(accessibilityShader)
    end

    love.graphics.draw(
        displayCanvas,
        windowOffsetX,
        windowOffsetY,
        0,
        displayScale,
        displayScale
    )

    -- Elements flagged bypassShaders (screen transitions) are drawn after the
    -- accessibility pass, directly to the window, so no shader touches them.
    love.graphics.setShader()

    love.graphics.push()
    love.graphics.translate(windowOffsetX, windowOffsetY)
    love.graphics.scale(windowScaleFactor, windowScaleFactor)

    for _, element in ipairs(self._bypassCache) do
        element:Draw()
    end

    love.graphics.pop()

    love.graphics.setShader(previousShader)
    love.graphics.setColor(1, 1, 1, 1)
end

local _lastFullscreen = nil
local _lastVSync = nil

function Module:Update()
    local fullscreen = SettingsModule:Get("graphics.fullscreen")
    local vsync = SettingsModule:Get("graphics.vsync")

    -- Only apply if the fullscreen state changed
    if fullscreen ~= _lastFullscreen then
        love.window.setFullscreen(fullscreen, "desktop")
        _lastFullscreen = fullscreen
    end

    -- Only apply if the vsync state changed
    if vsync ~= _lastVSync then
        love.window.setVSync(vsync)
        _lastVSync = vsync
    end
end

function Module.Init()
    SignalHandlerModule.Get("love.update"):Connect(function()
        Module:Update()
    end)

    SignalHandlerModule.Get("love.draw"):Connect(function()
        Module:Draw()
    end)

    ShaderHandlerModule.Init()
end

return Module