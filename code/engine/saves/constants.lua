-- ~/code/engine/saves/constants.lua

local SETTINGS_SCHEMA = {
    {
        key = "audio",

        settings = {
            { key = "masterVolume", name = "Master volume", default = 0.5 },
            { key = "soundVolume", name = "Sound volume", default = 1 },
            { key = "trackVolume", name = "Track volume", default = 1 },
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
            { key = "animationsEnabled", name = "Enable animations?", default = true },
            { key = "particlesEnabled", name = "Enable particles?", default = true }
        }
    },
    {
        key = "accessibility",

        settings = {
            { key = "colorblindMode", name = "Colorblindness mode", default = "none" },
            { key = "language", name = "Language", default = "english" },
            { key = "screenFlashEnabled", name = "Enable screen flashes?", default = true }
        }
    }
}

local function buildDefaultSettingsFromSchema()
    local defaults = {}

    for _, category in ipairs(SETTINGS_SCHEMA) do
        local categoryDefaults = {}

        for _, setting in ipairs(category.settings) do
            categoryDefaults[setting.key] = setting.default
        end

        defaults[category.key] = categoryDefaults
    end

    return defaults
end

return {
    SAVE_FILE_EXTENSION = ".mbsave",
    SAVE_FILE_PREFIX = "slot-",

    MAX_SAVE_SLOTS = 3,

    DEFAULT_DATA = {
        version = 2,
        slot = 1,

        currencies = {
            holyCatnip = 0,
            credits = 50,
        },

        stats = {
            highestBoxTier = 0,

            playtimeAtSessionStart = 0,
            playtime = 0
        },

        boxes = {},

        upgrades = {
            spawnCooldown = 0,
            spawnTier = 0,
            autoSpawn = 0,
            luckyRoll = 0,
            multiSpawn = 0
        },
    },

    SETTINGS_FILE_NAME = "settings.conf",

    SETTINGS_SCHEMA = SETTINGS_SCHEMA,
    DEFAULT_SETTINGS = buildDefaultSettingsFromSchema(),

    NUMBER_SETTING_RANGES = {
        masterVolume = { min = 0, max = 1.5 },
        soundVolume = { min = 0, max = 1.5 },
        trackVolume = { min = 0, max = 1.5 },
        contrast = { min = 0.5, max = 2 },
        gamma = { min = 0.5, max = 2 }
    },

    COLORBLIND_MODES = {
        "none",
        "protanopia",
        "deuteranopia",
        "tritanopia"
    }
}