-- ~/code/data/constructors/upgradeConstructor.lua

local Module = {}

function Module.new(data)
    assert(data.id, "Upgrade requires an id")

    assert(data.maxStacks, "Upgrade requires maxStacks")
    assert(data.cost, "Upgrade requires cost function")
    assert(data.effect, "Upgrade requires effect function")

    return {
        id = data.id,

        maxStacks = data.maxStacks,

        currency = data.currency or "credits",
        cost = data.cost,

        effect = data.effect,
    }
end

return Module