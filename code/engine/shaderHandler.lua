-- ~/code/engine/shaderHandler.lua

local Module = {}
Module.shaders = {}

function Module:Load(name, path)
    if self.shaders[name] then
        return self.shaders[name]
    end

    local shader = love.graphics.newShader(path)

    self.shaders[name] = shader

    return shader
end

function Module:LoadAll()
    local files = love.filesystem.getDirectoryItems("code/data/shaders")

    for _, fileName in ipairs(files) do
        if fileName:sub(-5) == ".glsl" then
            local name = fileName:sub(1, -6)
            local path = "code/data/shaders/" .. fileName

            self:Load(name, path)
        end
    end
end

function Module:Get(name)
    return self.shaders[name]
end

function Module:Send(name, uniform, value, ...)
    local shader = self.shaders[name]

    if shader then
        shader:send(uniform, value, ...)
    end
end

function Module:SendToChain(shaders, uniform, value, ...)
    for _, name in ipairs(shaders) do
        local shader = self.shaders[name]

        if shader then
            shader:send(uniform, value, ...)
        end
    end
end

function Module:Apply(name)
    local shader = self.shaders[name]

    if shader then
        love.graphics.setShader(shader)
    end
end

function Module:ApplyChain(shaders)
    for _, name in ipairs(shaders) do
        local shader = self.shaders[name]

        if shader then
            love.graphics.setShader(shader)
            return shader
        end
    end

    love.graphics.setShader()
end

function Module:With(name, callback)
    local shader = self.shaders[name]

    if shader then
        love.graphics.setShader(shader)
    end

    callback()

    love.graphics.setShader()
end

function Module:WithChain(shaders, callback)
    if #shaders == 1 then
        self:With(shaders[1], callback)
        return
    end

    callback()
end

function Module:Clear()
    love.graphics.setShader()
end

function Module:Has(name)
    return self.shaders[name] ~= nil
end

function Module:GetNames()
    local names = {}

    for name in pairs(self.shaders) do
        table.insert(names, name)
    end

    table.sort(names)

    return names
end

function Module.Init()
    Module:LoadAll()
end

return Module