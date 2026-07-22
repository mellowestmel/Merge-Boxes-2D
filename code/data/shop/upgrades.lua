-- ~/code/data/upgrades.lua

local UpgradeConstructor = require("code.data.constructors.upgradeConstructor")

local rawUpgrades = {
    spawnCooldown = {
        name = "Spawn Cooldown",
        description = "Decrease spawn cooldown by 0.1 seconds per stack.",

        maxStacks = 8,

        cost = function(stacks)
            return 200 * (stacks + 1)^2.5
        end,

        effect = function(stacks)
            return stacks * 0.1
        end
    },

    spawnTier = {
        name = "Spawn Tier",
        description = "Increase spawn tier by 1 per stack.",

        maxStacks = 4,

        cost = function(stacks)
            return 25000 * (stacks + 1)^4
        end,

        effect = function(stacks)
            return stacks
        end
    },

    autoSpawn = {
        name = "Auto Spawn",
        description = "Automatically spawn boxes. (Doesn't work while in shops or the settings menu.)",

        maxStacks = 1,

        cost = function()
            return 70000
        end,

        effect = function(stacks)
            return stacks > 0
        end
    },

    luckyRoll = {
        name = "Lucky Roll",
        description = "Each spawned box has a chance to spawn one tier higher. Each stack increases the chance by 15%.",

        maxStacks = 5,

        cost = function(stacks)
            return 50000 * (stacks + 1)^3
        end,

        effect = function(stacks)
            return stacks * 0.15
        end
    },

    multiSpawn = {
        name = "Multi Spawn",
        description = "Spawn an extra box per stack.",

        maxStacks = 3,

        cost = function(stacks)
            return 75000 * (stacks + 1)^3
        end,

        effect = function(stacks)
            return stacks + 1
        end
    }
}

local upgrades = {}

for key, upgradeData in pairs(rawUpgrades) do
    upgrades[key] = UpgradeConstructor.new(upgradeData)
end

return upgrades