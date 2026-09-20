-- ~/code/data/constructors/boxConstructor.lua

local Module = {}

function Module.new(type, gameplayData, flavorData, cosmeticData)
	assert(flavorData, "Missing flavor data for " .. type)
	assert(cosmeticData, "Missing cosmetic data for " .. type)

	return {
		-- Identity
		type = type,
        name = flavorData.name or gameplayData.type,

        description = flavorData.description or "",
        quote = flavorData.quote,

        -- Gameplay
        tier = gameplayData.tier,

        mergeable = gameplayData.mergeable ~= false,
        mergeReward = gameplayData.mergeReward or 0,

        draggable = gameplayData.draggable ~= false,
        weight = gameplayData.weight or 0,

        saveable = gameplayData.saveable ~= false,

        next = gameplayData.next,

        -- Visuals
        spritePath = cosmeticData.spritePath,
        scale = cosmeticData.scale or 1,

        shaders = cosmeticData.shaders or {},

        -- Merge effects
        mergeSoundData = cosmeticData.mergeSoundData,
        flashScreen = cosmeticData.flashScreen or false,
        screenFlashFadeDuration = cosmeticData.screenFlashFadeDuration,

        -- Cosmetic behavior
        onUpdate = cosmeticData.onUpdate,

        -- Crafting
        craftingMaterialDrop = gameplayData.craftingMaterial,
        trinketChance = gameplayData.trinketChance,
	}
end

return Module