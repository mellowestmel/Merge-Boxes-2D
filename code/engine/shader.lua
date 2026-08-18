local Module = {}

Module.shaders = {}

function Module:Load(name, path)
    local shader = love.graphics.newShader(path)
    self.shaders[name] = shader

    return shader
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

function Module:Apply(name)
    local shader = self.shaders[name]
    if shader then
        love.graphics.setShader(shader)
    end
end

function Module:With(name, callback)
    local shader = self.shaders[name]

    if shader then
        love.graphics.setShader(shader)
    end

    callback()

    love.graphics.setShader()
end

function Module:Clear()
    love.graphics.setShader()
end

return Module