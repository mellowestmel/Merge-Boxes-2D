-- ~/code/data/constructors/trinketConstructor.lua

local Module = {}

function Module.new(data)
    assert(data.name, "Trinket requires a name")
    assert(data.rarity, "Trinket requires a rarity")
    assert(data.effect, "Trinket requires an effect function")

    return {
        -- Identity
        name = data.name,
        description = data.description or "",

        rarity = data.rarity,

        -- Effect
        effect = data.effect,

        -- Upgrading
        upgradeMaterials = data.upgradeMaterials or {},
    }
end

return Module