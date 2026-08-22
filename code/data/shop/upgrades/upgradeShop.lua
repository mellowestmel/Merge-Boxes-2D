-- ~/code/data/shop/upgrades/upgradeShop.lua

local UpgradeConstructor = require("code.data.constructors.upgradeConstructor")

local rawUpgrades = {
    {
        id = "spawnCooldown",

        name = "Spawn Cooldown",
        description = "Decrease spawn cooldown by .1 seconds per stack.",

        maxStacks = 8,

        cost = function(stacks)
            return 250 * (stacks + 1)^3
        end,

        effect = function(stacks)
            return {
                spawnCooldown = -(stacks * .1)
            }
        end
    },

    {
        id = "spawnTier",

        name = "Spawn Tier",
        description = "Increase spawn tier by 1 per stack.",

        maxStacks = 9,

        cost = function(stacks)
            local exponent = 4 + stacks * .15
            return 2000 * (stacks + 1)^exponent
        end,

        effect = function(stacks)
            return {
                spawnTier = stacks
            }
        end
    },

    {
        id = "autoSpawn",

        name = "Auto Spawn",
        description = "Automatically spawn boxes. (Doesn't work while in shops or the settings menu.)",

        maxStacks = 1,

        cost = function()
            return 12000
        end,

        effect = function(stacks)
            return {
                autoSpawnUnlocked = stacks > 0
            }
        end
    },

    {
        id = "luckyRoll",

        name = "Lucky Roll",
        description = "Each spawned box has a chance to spawn one tier higher. Each stack increases the chance by 10%.",

        maxStacks = 5,

        cost = function(stacks)
            return 8000 * (stacks + 1)^2.5
        end,

        effect = function(stacks)
            return {
                extraSpawnTierChance = stacks * .1
            }
        end
    },

    {
        id = "multiSpawn",

        name = "Multi Spawn",
        description = "Spawn an extra box per stack.",

        maxStacks = 6,

        cost = function(stacks)
            local exponent = 3.5 + stacks * .3
            return 15000 * (stacks + 1)^exponent
        end,

        effect = function(stacks)
            return {
                spawnCount = stacks
            }
        end
    },

    {
        id = "pullPower",

        name = "Pull Power",
        description = "Increases the strength of your pull. Useful for pulling large boxes. Each stack increases power by 100%.",

        maxStacks = 10,

        cost = function(stacks)
            return math.floor(150 * (stacks + 1)^2.2)
        end,

        effect = function(stacks)
            return {
                dragMultiplier = stacks
            }
        end
    }
}

local upgrades = {}

for _, upgradeData in pairs(rawUpgrades) do
    upgrades[upgradeData.id] = UpgradeConstructor.new(upgradeData)
end

return upgrades