-- ~/code/engine/saves/helpers.lua

local Module = {}

function Module.GetPath(givenTable, path)
    local current = givenTable

    for segment in path:gmatch("[^%.]+") do
        if type(current) ~= "table" then return end
        current = current[segment]
    end

    return current
end

function Module.SetPath(givenTable, path, value)
    local current = givenTable
    local segments = {}

    for segment in path:gmatch("[^%.]+") do
        table.insert(segments, segment)
    end

    for index = 1, #segments - 1 do
        local segment = segments[index]
        if type(current[segment]) ~= "table" then
            current[segment] = {}
        end

        current = current[segment]
    end

    current[segments[#segments]] = value
end

return Module