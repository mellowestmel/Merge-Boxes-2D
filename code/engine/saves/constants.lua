-- ~/code/engine/saves/constants.lua

return {
    SAVE_FILE_EXTENSION = ".mbsave",
    SAVE_FILE_PREFIX = "slot-",

    MAX_SAVE_SLOTS = 3,
    
    DEFAULT_DATA = {
        slot = 1,

        currencies = {
            credits = 50,
        },

        stats = {
            highestBoxTier = 0,

            boxSpawnCooldown = 1.2,
            boxSpawnTier = 1,

            playtimeAtSessionStart = 0,
            playtime = 0
        },

        boxes = {}
    },

    SETTINGS_FILE_NAME = "settings.conf",

    DEFAULT_SETTINGS = {
        masterVolume = 0.5,

        soundVolume = 1,
        trackVolume = 1,
    }
}