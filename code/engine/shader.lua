local Module = {}

Module.shaders = {}

function Module:load(name, path)
    local shader = love.graphics.newShader(path)
    self.shaders[name] = shader

    return shader
end

function Module:get(name)
    return self.shaders[name]
end

function Module:send(name, uniform, value, ...)
    local shader = self.shaders[name]
    if shader then
        shader:send(uniform, value, ...)
    end
end

function Module:apply(name)
    local shader = self.shaders[name]
    if shader then
        love.graphics.setShader(shader)
    end
end

function Module:with(name, callback)
    local shader = self.shaders[name]

    if shader then
        love.graphics.setShader(shader)
    end

    callback()

    love.graphics.setShader()
end

function Module:clear()
    love.graphics.setShader()
end

return Module