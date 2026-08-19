-- ~/code/data/shop/upgrades/catnipShop.lua

local UpgradeConstructor = require("code.data.constructors.upgradeConstructor")

local rawUpgrades = {
    {
        id = "spawnCooldown",

        name = "Spawn Cooldown",
        description = "Decrease spawn cooldown by 0.1 seconds per stack.",

        currency = "holyCatnip",
        maxStacks = 8,

        cost = function(stacks)
            return 1 * stacks
        end,

        effect = function(stacks)
            return stacks * 0.1
        end
    },
}

local upgrades = {}

for _, upgradeData in pairs(rawUpgrades) do
    upgrades[upgradeData.id] = UpgradeConstructor.new(upgradeData)
end

return upgrades