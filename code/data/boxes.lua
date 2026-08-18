-- ~/code/data/boxes.lua
--
-- Assembles per-tier box definitions out of three separate data files:
--   boxes/flavor.lua   -> name, description, quote
--   boxes/cosmetic.lua -> sprite, scale, sound, flash, reflections, onUpdateCosmetic
--   boxes/gameplay.lua -> mergeReward, weight, craftingMaterial, trinketChance

-- This file's only job is to zip those three by tier and hand the merged
-- table over to BoxConstructor, so the rest of the game keeps seeing the same
-- flat box data it always has

local BoxConstructor = require("code.data.constructors.boxConstructor")

local flavor = require("code.data.boxes.flavorData")
local cosmetic = require("code.data.boxes.cosmeticData")
local gameplay = require("code.data.boxes.gameplayData")

local function indexByTier(list, label)
    local byTier = {}

    for _, entry in ipairs(list) do
        assert(entry.tier, label .. " entry is missing a tier")
        assert(not byTier[entry.tier], label .. " has a duplicate tier " .. tostring(entry.tier))
        byTier[entry.tier] = entry
    end

    return byTier
end

local flavorByTier = indexByTier(flavor, "flavor")
local cosmeticByTier = indexByTier(cosmetic, "cosmetic")
local gameplayByTier = indexByTier(gameplay, "gameplay")

local boxes = {}

-- gameplay.lua is treated as the source of truth for which tiers exist
for tier, gameplayData in ipairs(gameplayByTier) do
    local flavorData = flavorByTier[tier]
    local cosmeticData = cosmeticByTier[tier]

    assert(flavorData, "Missing flavor data for tier " .. tier)
    assert(cosmeticData, "Missing cosmetic data for tier " .. tier)

    local mergedData = {
        tier = tier,

        -- Flavor
        description = flavorData.description,
        name = flavorData.name,

        quote = flavorData.quote,

        -- Cosmetic
        spritePath = cosmeticData.spritePath,
        scale = cosmeticData.scale,

        mergeSoundData = cosmeticData.mergeSoundData,

        reflectionPath = cosmeticData.reflectionPath,
        reflective = cosmeticData.reflective,

        screenFlashFadeDuration = cosmeticData.screenFlashFadeDuration,
        flashScreen = cosmeticData.flashScreen,

        -- Gameplay
        craftingMaterial = gameplayData.craftingMaterial,

        baseCraftingMaterialChance = gameplayData.baseCraftingMaterialChance,
        baseTrinketChance = gameplayData.baseTrinketChance,

        mergeReward = gameplayData.mergeReward,
        weight = gameplayData.weight,
    }

    boxes[tier] = BoxConstructor.new(mergedData)
end

return boxes