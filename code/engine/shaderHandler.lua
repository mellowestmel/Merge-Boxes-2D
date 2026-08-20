-- ~/code/engine/shaderHandler.lua
-- Loads and caches all shaders from code/data/shaders by filename.

local Module = {}
Module.shaders = {}

local SHADER_DIRECTORY = "code/data/shaders"

function Module:Load(name, path)
    local shader = self.shaders[name]

    if not shader then
        shader = love.graphics.newShader(path)
        self.shaders[name] = shader
    end

    return shader
end

function Module:LoadAll()
    for _, fileName in ipairs(love.filesystem.getDirectoryItems(SHADER_DIRECTORY)) do
        if fileName:sub(-5) == ".glsl" then
            self:Load(fileName:sub(1, -6), SHADER_DIRECTORY .. "/" .. fileName)
        end
    end
end

function Module:Get(name)
    return self.shaders[name]
end

function Module:Has(name)
    return self.shaders[name] ~= nil
end

-- Sends a uniform to a loaded shader; no-op if the shader doesn't exist.
function Module:Send(name, uniform, value, ...)
    local shader = self.shaders[name]

    if shader and shader:hasUniform(uniform) then
        shader:send(uniform, value, ...)
    end
end

function Module.Init()
    Module:LoadAll()
end

return Module