-- ~/code/data/constants.lua

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
        { key = "upgradeable", fields = {
            { key = "extraSpawnTierChance", default = 0 },

            { key = "spawnCooldown", default = 1.4 },
            { key = "spawnCount", default = 1 },
            { key = "spawnTier", default = 1 },

            { key = "autoSpawnUnlocked", default = false },
            { key = "dragMultiplier", default = 1 }
        }}
    }},

    { key = "tracking", fields = {
        { key = "highestBoxTier", default = 0 },
        { key = "playtime", default = 0 },
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
    version = 4,
    slot = 1,
}
-- Merge schema defaults into DEFAULT_DATA
for key, value in pairs(_buildDefaultsFromSchema(SAVE_SCHEMA)) do
    DEFAULT_DATA[key] = value
end

return {
    SAVES = {
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
    },

    BOX = {
        SPAWNER = {
            MIN_SPAWN_VELOCITY = -1,
            MAX_SPAWN_VELOCITY = 1,
        },

        AREA = {
            WIDTH = 550,
            HEIGHT = 600,
        },

        PHYSICS = {
            ELASTICITY = .8,
            FRICTION = .0016,

            BASE_WEIGHT = 60,

            FREE_ROTATION_VELOCITY_DIVISOR = 3.5,
        },

        DRAG = {
            VELOCITY_MULTIPLIER = .05,
            ROTATION_MULTIPLIER = 5,

            BASE_TILT_SPEED = 1,
            MAX_TILT = 90,

            HELD_BOX_ALPHA = .8,
        },

        MERGE = {
            VELOCITY_DURATION_FACTOR = .35,

            BASE_SPEED = 400,
            BASE_RANGE = 150,

            MIN_DURATION = .001,
        },

        ANIMATION = {
            SPAWN_SCALE_MULTIPLIER = 1.25,
            BASE_SCALE_TWEEN_DURATION = .3,
            WEIGHT_ANIM_DURATION_DIVISOR = 100,
        },

        BASE_ZINDEX = 2,
    },

    SHOP = {
        UPGRADE_DATA = {
            REQUIRE_DIRECTORY = "code.data.shop.upgrades.",
            DIRECTORY = "code/data/shop/upgrades"
        },

        UPGRADE_SHOP = {
            UNLOCK_REQUIREMENT = 5,
            ID = "upgradeShop"
        },
        BLACK_MARKET = {
            UNLOCK_REQUIREMENT = 10,
            ID = "blackMarket"
        },
        SACRIFICIAL_GROUNDS = {
            UNLOCK_REQUIREMENT = 15,
            ID = "sacrificialGrounds"
        }
    },

    UI = {
        SAVES = {
            RESET_BUTTON_WARN_TIME_OUT = .5,
        },

        SETTINGS = {
            NUMBER_SETTING_CHANGE_INCREMENT = .1,
        },

        DIALOGUE = {
            LETTER_INTREVAL = .01,
        },

        CURSOR = {
            LERP_SPEED = 40,

            TILT_MULTIPLIER = .3,
            MAX_TILT = 25,

            Z_INDEX = 999999,
            SCALE = .75,

            SPRITE_PATH = "assets/sprites/ui/cursors/",
            DEFAULT_NAME = "default",

            CLICK_RECOVERY_DURATION = .1,
            CLICK_SCALE = .9,

            CLICK_EASING = "easeInOutQuad",

            DRAG_LINE_SPRITE_PATH = "assets/sprites/ui/cursors/dot.png",
            DRAG_LINE_SPACING = 45,
            DRAG_LINE_MIN_DOTS = 1
        }
    },

    VFX = {
        BASE_SCREEN_FLASH_COLOR = {255, 227, 17, .8},
        BASE_SCREEN_FLASH_SPEED = 2,
    },

    QUADTREE = {
        MAX_DEPTH = 8,

        DEFAULT_WIDTH = 100,
        DEFAULT_HEIGHT = 100,
        DEFAULT_CAPACITY = 4
    },

    SHADERS = {
        SOURCES = {
            { directory = "code/data/shaders", prefix = "" },
            {
                directory = "code/data/particles",
                prefix = "particles/",
                prelude = "code/data/particles/prelude.glsl"
            }
        }
    },

    TWEEN = {
        COMPLETION_EPSILON = 1e-6
    },
}