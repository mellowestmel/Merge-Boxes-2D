-- ~/code/data/constructors/boxConstructor.lua

local Module = {}

function Module.new(data)
    assert(data.tier, "Box requires a tier")

    return {
        -- Identity
        name = data.name,
        description = data.description or "",
        quote = data.quote,

        -- Visuals
        spritePath = data.spritePath,
        scale = data.scale or 1,

        reflectionPath = data.reflectionPath,
        reflective = data.reflective or false,

        -- Progression
        tier = data.tier,
        mergeReward = data.mergeReward or 0,
        weight = data.weight or 0,

        -- Merge effects
        mergeSoundData = data.mergeSoundData,

        flashScreen = data.flashScreen or false,
        screenFlashFadeDuration = data.screenFlashFadeDuration,

        -- Cosmetic behavior
        onUpdateCosmetic = data.onUpdateCosmetic,

        -- Crafting
        craftingMaterialDrop = data.craftingMaterial,
        trinketChance = data.trinketChance
    }
end

return Module