-- ~/code/engine/shaderHandler.lua

-- Handles all shader work: loading .glsl files, sending uniforms and drawing.
--
-- Names: "reflection" (code/data/shaders), "particles/box16" (code/data/particles).
-- Empty .glsl files are skipped, so :Get() returns nil for them.
--
-- Entry: a shader name, or { name = "reflection", someTexture = "a.png", power = 2 }
-- Context: { x, y, width, height, rotation (radians), alpha }, all optional
--
-- Sent automatically if the shader declares them: time, canvasSize, texelSize,
-- elementCenter, elementSize, elementRotation, elementAlpha.
--
-- Elements: :DrawChain(entries, context, drawFn, ...)
-- Particles: :Begin(entry, context), draw, then :End()

local Module = {}
Module.shaders = {}

Module._textures = {}
Module._canvases = {}
Module._previousShaders = {}

local CONSTANTS = require("code.data.constants")

-- Loads and caches a shader. Returns nil for empty files.
function Module:Load(name, path)
    local shader = self.shaders[name]

    if shader then
        return shader
    end

    local source = love.filesystem.read(path)

    if not source or source:match("^%s*$") then
        return nil
    end

    local success, result = pcall(love.graphics.newShader, source)

    if not success then
        error(
            string.format(
                "Failed to compile shader '%s' (%s): %s",
                name,
                path,
                tostring(result)
            ),
            0
        )
    end

    self.shaders[name] = result

    return result
end

-- Loads every .glsl in a folder as prefix .. filename.
function Module:LoadDirectory(directory, prefix)
    prefix = prefix or ""

    for _, fileName in ipairs(love.filesystem.getDirectoryItems(directory)) do
        if fileName:sub(-5) == ".glsl" then
            self:Load(
                prefix .. fileName:sub(1, -6),
                directory .. "/" .. fileName
            )
        end
    end
end

function Module:LoadAll()
    for _, source in ipairs(CONSTANTS.SHADERS.SOURCES) do
        self:LoadDirectory(source.directory, source.prefix)
    end
end

function Module:Get(name)
    return self.shaders[name]
end

function Module:Has(name)
    return self.shaders[name] ~= nil
end

-- Sends a uniform to a loaded shader.
function Module:Send(name, uniform, value, ...)
    local shader = self.shaders[name]

    if shader and shader:hasUniform(uniform) then
        shader:send(uniform, value, ...)
    end
end

-- Reused so no new table is made on every send.
local _vector = { 0, 0 }

Module._uniformProviders = {
    time = function()
        return love.timer.getTime()
    end,

    canvasSize = function()
        _vector[1], _vector[2] = RESOLUTION_WIDTH, RESOLUTION_HEIGHT
        return _vector
    end,

    texelSize = function()
        _vector[1], _vector[2] = 1 / RESOLUTION_WIDTH, 1 / RESOLUTION_HEIGHT
        return _vector
    end,

    elementCenter = function(context)
        _vector[1], _vector[2] = context.x or 0, context.y or 0
        return _vector
    end,

    elementSize = function(context)
        _vector[1], _vector[2] = context.width or 0, context.height or 0
        return _vector
    end,

    elementRotation = function(context)
        return context.rotation or 0
    end,

    elementAlpha = function(context)
        return context.alpha or 1
    end
}

-- Adds a standard uniform. provider(context) returns its value.
function Module:RegisterUniform(name, provider)
    assert(type(name) == "string", "Uniform name expected to be a string")
    assert(type(provider) == "function", "Uniform provider expected to be a function")

    self._uniformProviders[name] = provider
end

local function _loadTexture(path)
    local texture = Module._textures[path]

    if not texture then
        texture = love.graphics.newImage(path)
        Module._textures[path] = texture
    end

    return texture
end

local function _getEntryName(entry)
    if type(entry) == "table" then
        return entry.name
    end

    return entry
end

-- Sends the standard uniforms, then the entry's own values.
function Module:SendParams(shader, entry, context)
    context = context or {}

    for name, getValue in pairs(self._uniformProviders) do
        if shader:hasUniform(name) then
            shader:send(name, getValue(context))
        end
    end

    if type(entry) ~= "table" then
        return
    end

    for name, value in pairs(entry) do
        if type(name) == "string" and name ~= "name" and shader:hasUniform(name) then
            if type(value) == "string" and name:match("Texture$") then
                value = _loadTexture(value)
            end

            shader:send(name, value)
        end
    end
end

-- Two scratch canvases used to pass a drawing between shaders.
local function _getCanvases()
    local canvases = Module._canvases

    if canvases.width ~= RESOLUTION_WIDTH
        or canvases.height ~= RESOLUTION_HEIGHT
        or not canvases.a
        or not canvases.b
    then
        if canvases.a then canvases.a:release() end
        if canvases.b then canvases.b:release() end

        canvases.a = love.graphics.newCanvas(RESOLUTION_WIDTH, RESOLUTION_HEIGHT)
        canvases.b = love.graphics.newCanvas(RESOLUTION_WIDTH, RESOLUTION_HEIGHT)

        canvases.width = RESOLUTION_WIDTH
        canvases.height = RESOLUTION_HEIGHT
    end

    return canvases.a, canvases.b
end

-- Draws drawFn(...) through each shader in order. Missing shaders are skipped.
function Module:DrawChain(entries, context, drawFn, ...)
    local inputCanvas, outputCanvas = _getCanvases()

    local previousCanvas = love.graphics.getCanvas()
    local previousShader = love.graphics.getShader()

    love.graphics.setCanvas(inputCanvas)
    love.graphics.clear(0, 0, 0, 0)

    love.graphics.setShader()

    drawFn(...)

    for _, entry in ipairs(entries) do
        local shader = self.shaders[_getEntryName(entry)]

        if shader then
            love.graphics.setCanvas(outputCanvas)
            love.graphics.clear(0, 0, 0, 0)

            love.graphics.setShader(shader)

            love.graphics.setColor(1, 1, 1, 1)

            self:SendParams(shader, entry, context)
            love.graphics.draw(inputCanvas, 0, 0)

            inputCanvas, outputCanvas = outputCanvas, inputCanvas
        end
    end

    love.graphics.setCanvas(previousCanvas)
    love.graphics.setShader(previousShader)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(inputCanvas, 0, 0)
end

-- Sets a shader for the draws that follow. Returns nil if it doesn't exist.
-- Always pair with :End().
function Module:Begin(entry, context)
    table.insert(self._previousShaders, love.graphics.getShader() or false)

    local shader = self.shaders[_getEntryName(entry)]

    if not shader then
        return nil
    end

    love.graphics.setShader(shader)
    self:SendParams(shader, entry, context)

    return shader
end

-- Restores the shader that was active before :Begin().
function Module:End()
    local previousShader = table.remove(self._previousShaders)

    if previousShader then
        love.graphics.setShader(previousShader)
    else
        love.graphics.setShader()
    end
end

function Module.Init()
    Module:LoadAll()
end

return Module