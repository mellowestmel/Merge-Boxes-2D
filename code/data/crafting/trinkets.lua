-- ~/code/data/crafting/trinkets.lua

local TrinketConstructor = require("code.data.constructors.trinketConstructor")

local rawTrinkets = {
    {
        name = "Feather",
        rarity = "Common",

        effect = function(upgrades)
            return upgrades * 0.1
        end,

        upgradeMaterials = {
            {
                material = "Nose Hair",
                amount = function(upgrades)
                    return math.floor(5 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Airhorn",
        rarity = "Common",

        effect = function(upgrades)
            return upgrades * 0.1
        end,

        upgradeMaterials = {},
    },

    {
        name = "Toy Soldier Army",
        rarity = "Common",

        effect = function(upgrades)
            return upgrades * 0.05
        end,

        upgradeMaterials = {
            {
                material = "Toy Soldier",
                amount = function(upgrades)
                    return math.floor(5 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Notebook",
        rarity = "Common",

        effect = function(upgrades)
            return upgrades * 0.01
        end,

        upgradeMaterials = {
            {
                material = "Torn Pages",
                amount = function(upgrades)
                    return math.floor(5 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Cookie Jar",
        rarity = "Common",

        effect = function(upgrades)
            return upgrades * 0.25
        end,

        upgradeMaterials = {
            {
                material = "Cookies",
                amount = function(upgrades)
                    return math.floor(5 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Emo T-Shirt",
        rarity = "Rare",

        effect = function(upgrades)
            return upgrades * 0.25
        end,

        upgradeMaterials = {
            {
                material = "Fabric",
                amount = function(upgrades)
                    return math.floor(10 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Working Megaphone",
        rarity = "Rare",

        effect = function(upgrades)
            return upgrades * 0.05
        end,

        upgradeMaterials = {
            {
                material = "Megaphone Parts",
                amount = function(upgrades)
                    return math.floor(10 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Pink Sticky Hand",
        rarity = "Rare",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Glue",
                amount = function(upgrades)
                    return math.floor(10 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Crude Camera",
        rarity = "Rare",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Camera Parts",
                amount = function(upgrades)
                    return math.floor(10 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Crude Sunglasses",
        rarity = "Rare",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Sunglass Parts",
                amount = function(upgrades)
                    return math.floor(10 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Abnormal Clock",
        rarity = "Epic",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Bent Clock Hand",
                amount = function(upgrades)
                    return math.floor(25 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Granite Statue",
        rarity = "Epic",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Granite Chip",
                amount = function(upgrades)
                    return math.floor(25 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Baby Tooth Necklace",
        rarity = "Epic",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Lost Baby Tooth",
                amount = function(upgrades)
                    return math.floor(25 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Molten Core",
        rarity = "Epic",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Molten Scrap",
                amount = function(upgrades)
                    return math.floor(25 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Tome of Wisdom",
        rarity = "Epic",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Wisdom Shard",
                amount = function(upgrades)
                    return math.floor(25 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Prism Lens",
        rarity = "Legendary",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Prism",
                amount = function(upgrades)
                    return math.floor(50 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Devoided Crystal",
        rarity = "Legendary",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Negative Matter",
                amount = function(upgrades)
                    return math.floor(50 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Disguise Kit",
        rarity = "Legendary",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Fake Mustache",
                amount = function(upgrades)
                    return math.floor(50 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Starry Sleeping Mask",
        rarity = "Legendary",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Primordial Stardust",
                amount = function(upgrades)
                    return math.floor(50 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Tome of Luck",
        rarity = "Legendary",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Lucky Coin",
                amount = function(upgrades)
                    return math.floor(50 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Hair Clip Collection",
        rarity = "Mythic",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Daisy Hair Clip",
                amount = function(upgrades)
                    return math.floor(100 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Off-brand Gaming Console",
        rarity = "Mythic",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Game Cartridge",
                amount = function(upgrades)
                    return math.floor(100 * (1.1 ^ upgrades))
                end
            }
        },
    },

    {
        name = "Awful Painting",
        rarity = "Mythic",

        effect = function(upgrades)
            return upgrades
        end,

        upgradeMaterials = {
            {
                material = "Eyesore Shard",
                amount = function(upgrades)
                    return math.floor(100 * (1.1 ^ upgrades))
                end
            }
        },
    }
}

local trinkets = {}

for key, trinketData in pairs(rawTrinkets) do
    trinkets[key] = TrinketConstructor.new(trinketData)
end

return trinkets