-- ~/code/data/boxDefinitions/gameplay.lua

local gameplay
gameplay = {
    -- Special
    ["goldenGerald"] = { mergeable = false, draggable = false, saveable = false },

    -- Normal
    ["gerald"] = { tier = 1, mergeReward = 0, weight = 60, next = "jimbo" },
    ["jimbo"] = { tier = 2, mergeReward = 10, weight = 70, next = "glumbo" },
    ["glumbo"] = { tier = 3, mergeReward = 25, weight = 85, next = "jeremy" },
    ["jeremy"] = { tier = 4, mergeReward = 50, weight = 105, next = "muncher" },
    ["muncher"] = { tier = 5, mergeReward = 100, weight = 130, next = "dylan" },

    ["dylan"] = { tier = 6, mergeReward = 200, weight = 160, next = "carlos" },
    ["carlos"] = { tier = 7, mergeReward = 400, weight = 200, next = "goobsterGoobingtonIII" },
    ["goobsterGoobingtonIII"] = { tier = 8, mergeReward = 800, weight = 250, next = "mark" },
    ["mark"] = { tier = 9, mergeReward = 1500, weight = 320, next = "frigidWendyhot" },
    ["frigidWendyhot"] = { tier = 10, mergeReward = 3000, weight = 400, next = "dizzy" },

    ["dizzy"] = { tier = 11, mergeReward = 6000, weight = 500, next = "gochged" },
    ["gochged"] = { tier = 12, mergeReward = 12000, weight = 650, next = "mtBox" },
    ["mtBox"] = { tier = 13, mergeReward = 20000, weight = 850, next = "unstable" },
    ["unstable"] = { tier = 14, mergeReward = 35000, weight = 1100, next = "transcended" },
    ["transcended"] = { tier = 15, mergeReward = 75000, weight = 1400, next = "omnibox" },

    ["omnibox"] = { tier = 16, mergeReward = 150000, weight = 1800, next = "devoided" },
    ["devoided"] = { tier = 17, mergeReward = 300000, weight = -60, next = "boxOMatter" },
    ["boxOMatter"] = { tier = 18, mergeReward = 600000, weight = 3000, next = "greatOldGrumpyOne" },
    ["greatOldGrumpyOne"] = { tier = 19, mergeReward = 1200000, weight = 3900, next = "luckrollBox" },
    ["luckrollBox"] = { tier = 20, mergeReward = 2500000, weight = 5000, next = "mellowBox" },

    ["mellowBox"] = { tier = 21, mergeReward = 5000000, weight = 6500, next = "theCollector" },
    ["theCollector"] = { tier = 22, mergeReward = 10000000, weight = 8500, next = "glitcherson" },
    ["glitcherson"] = { tier = 23, mergeReward = 20000000, weight = 11000, next = "" },

    -- Box 18 fakes
    ["geraldo"] = {
        tier = gameplay["boxOMatter"].tier,

        mergeReward = gameplay["boxOMatter"].mergeReward,
        weight = gameplay["gerald"].weight,

        next = gameplay["boxOMatter"].next
    },

    ["jambo"] = {
        tier = gameplay["boxOMatter"].tier,

        mergeReward = gameplay["boxOMatter"].mergeReward,
        weight = gameplay["jimbo"].weight,

        next = gameplay["boxOMatter"].next
    },

    ["glungus"] = {
        tier = gameplay["boxOMatter"].tier,

        mergeReward = gameplay["boxOMatter"].mergeReward,
        weight = gameplay["glumbo"].weight,

        next = gameplay["boxOMatter"].next
    },
}

return gameplay