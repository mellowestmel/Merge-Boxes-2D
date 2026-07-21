-- ~/code/engine/saves/constants.lua

return {
    SAVE_FILE_EXTENSION = ".mbsave",
    SAVE_FILE_PREFIX = "slot-",

    MAX_SAVE_SLOTS = 3,

    DEFAULT_DATA = {
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

    DEFAULT_SETTINGS = {
        audio = {
            masterVolume = 0.5,

            soundVolume = 1,
            trackVolume = 1,

            muteGame = false
        },

        graphics = {
            fullscreen = true,
            vsync = true,

            animationsEnabled = true,
            particlesEnabled = true,

            contrast = 1,
            gamma = 1,
        },

        accessibility = {
            screenFlashEnabled = true,
            colorblindMode = "none"
        }
    },

    MIN_CONTRAST = .5,
    MAX_CONTRAST = 2,

    MIN_GAMMA = .5,
    MAX_GAMMA = 2,

    COLORBLIND_MODES = {
        "none",
        "protanopia",
        "deuteranopia",
        "tritanopia"
    }
}