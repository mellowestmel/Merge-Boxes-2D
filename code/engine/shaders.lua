local Module = {}

Module.shaders = {}

function Module:load(name, path)
    self.shaders[name] = love.graphics.newShader(path)
    return self.shaders[name]
end

function Module:get(name)
    return self.shaders[name]
end

function Module:apply(name)
    local shader = self.shaders[name]

    if shader then
        love.graphics.setShader(shader)
    end
end

function Module:clear()
    love.graphics.setShader()
end

return Module