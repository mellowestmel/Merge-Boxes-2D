-- ~/code/data/shop/upgrades/upgradeShop.lua

local UpgradeConstructor = require("code.data.constructors.upgradeConstructor")

local rawUpgrades = {
    {
        id = "spawnCooldown",
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
        maxStacks = 9,

        cost = function(stacks)
            local exponent = 4 + stacks * .1
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