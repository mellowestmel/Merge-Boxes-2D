-- ~/code/engine/saves/constants.lua

local SETTINGS_SCHEMA = {
    {
        key = "audio",
        settings = {
            { key = "masterVolume", name = "Master volume", default = .5 },
            { key = "soundVolume", name = "Sound volume", default = 1 },
            { key = "trackVolume", name = "Music volume", default = 1 },
            { key = "muteGame", name = "Mute game?", default = false }
        }
    },
    {
        key = "graphics",
        settings = {
            { key = "contrast", name = "Contrast", default = 1 },
            { key = "gamma", name = "Gamma", default = 1 },
            { key = "fullscreen", name = "Fullscreen?", default = true },
            { key = "vsync", name = "VSync?", default = true },
            { key = "uiAnimationsEnabled", name = "Enable UI animations?", default = true },
            { key = "cursorAnimationsEnabled", name = "Enable cursor animations?", default = true },
            { key = "transitionsEnabled", name = "Enable transitions?", default = true },
            { key = "particlesEnabled", name = "Enable particles?", default = true }
        }
    },
    {
        key = "accessibility",
        settings = {
            { key = "colorblindMode", name = "Colorblindness mode", default = "none" },
            { key = "screenFlashEnabled", name = "Enable screen flashes?", default = true }
        }
    }
}

local function _buildDefaultsFromSchema(schema)
    local defaults = {}

    for _, category in pairs(schema) do
        local values = {}

        for _, item in pairs(category.settings or category.fields or {}) do
            if item.fields then
                local nested = _buildDefaultsFromSchema({
                    { key = item.key, fields = item.fields }
                })

                values[item.key] = nested[item.key]
            else
                values[item.key] = item.default
            end
        end

        defaults[category.key] = values
    end

    return defaults
end

local SAVE_SCHEMA = {
    { key = "currencies", fields = { { key = "credits", default = 50 } } },
    { key = "stats", fields = {
        { key = "highestBoxTier", default = 0 },
        { key = "playtime", default = 0 },

        { key = "upgradeable", fields = {
            { key = "extraSpawnTierChance", default = 0 },

            { key = "spawnCooldown", default = 1.4 },
            { key = "spawnCount", default = 1 },
            { key = "spawnTier", default = 1 },

            { key = "autoSpawnUnlocked", default = false },
            { key = "dragMultiplier", default = 1 }
        }}
    }},

    { key = "boxes", fields = {} },

    { key = "upgrades", fields = {
        { key = "luckyRoll", default = 0 },

        { key = "spawnCooldown", default = 0 },
        { key = "multiSpawn", default = 0 },
        { key = "spawnTier", default = 0 },

        { key = "autoSpawn", default = 0 },
        { key = "pullPower", default = 0 }
    }},
    { key = "trinkets", fields = {} }
}

local DEFAULT_DATA = {
    version = 3,
    slot = 1,
}
-- Merge schema defaults into DEFAULT_DATA
for key, value in pairs(_buildDefaultsFromSchema(SAVE_SCHEMA)) do
    DEFAULT_DATA[key] = value
end

return {
    SAVE_FILE_EXTENSION = ".mbsave",
    SAVE_FILE_PREFIX = "slot-",
    MAX_SAVE_SLOTS = 3,

    DEFAULT_DATA = DEFAULT_DATA,
    SAVE_SCHEMA = SAVE_SCHEMA,

    SETTINGS_FILE_NAME = "settings.conf",
    SETTINGS_SCHEMA = SETTINGS_SCHEMA,
    DEFAULT_SETTINGS = _buildDefaultsFromSchema(SETTINGS_SCHEMA),

    NUMBER_SETTING_RANGES = {
        masterVolume = { min = 0, max = 1.5 },
        soundVolume = { min = 0, max = 1.5 },
        trackVolume = { min = 0, max = 1.5 },
        contrast = { min = .5, max = 2 },
        gamma = { min = .5, max = 2 }
    },

    COLORBLIND_MODES = {
        "none",
        "protanopia",
        "deuteranopia",
        "tritanopia"
    }
}