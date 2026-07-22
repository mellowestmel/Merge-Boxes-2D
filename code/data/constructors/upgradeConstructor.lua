-- ~/code/data/constructors/upgradeConstructor.lua

local Module = {}

function Module.new(data)
    assert(data.name, "Upgrade requires a name")
    assert(data.description, "Upgrade requires a description")
    assert(data.maxStacks, "Upgrade requires maxStacks")
    assert(data.cost, "Upgrade requires cost function")
    assert(data.effect, "Upgrade requires effect function")

    return {
        name = data.name,
        description = data.description,

        maxStacks = data.maxStacks,

        cost = data.cost,
        effect = data.effect,
    }
end

return Module