local COMMON_VALUES = require("src.data.ui.commonValues")

local SHOP = {
    UPGRADE_DATA = {
        REQUIRE_DIRECTORY = "src.data.shop.upgrades.",
        DIRECTORY = "src/data/shop/upgrades"
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
}

return {
    PLATFORM = {
        USE_STEAM_API = false, -- cloud saving, hook into the achievements system (the very real and currently implemented one) 
        DEVICE_TYPE = "pc", -- "pc" | "mobile" | "console" | "whateverthefuck"
    },

    DISPLAY = {
        RESOLUTION_WIDTH = 800,
        RESOLUTION_HEIGHT = 600,

        FPS_SCALE = 240,

        MIN_WINDOW_WIDTH = 400,
        MIN_WINDOW_HEIGHT = 300
    },

    SAVES = {
        SAVE_FILE_EXTENSION = ".mbsave",
        SAVE_FILE_PREFIX = "slot-",

        MAX_SAVE_SLOTS = 3,

        DEFAULT_DATA = {
            version = 1,

            currencies = {
                credits = 50
            },
            stats = {
                extraSpawnTierChance = 0,
                
                spawnCooldown = 1.4,
                spawnCount = 1,
                spawnTier = 1,

                dragMultiplier = 1
            },
            unlocks = {},
            tracking = {
                highestBoxTier = 0,
                playtime = 0
            },
            inventory = {},

            boxes = {},
        },

        SETTINGS_FILE_NAME = "settings.conf",
        DEFAULT_SETTINGS = {
            audio = {
                masterVolume = .5,

                soundVolume = 1,
                trackVolume = 1,

                muteGame = false
            },

            graphics = {
                contrast = 1,
                gamma = 1,

                fullscreen = true,
                vsync = true,

                uiAnimationsEnabled = true,
                cursorAnimationsEnabled = true,
                transitionsEnabled = true,

                particlesEnabled = true
            },

            accessibility = {
                language = "english",
                colorblindMode = "none",
                screenFlashEnabled = true
            }
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

    SHOP = SHOP,

    LOCALES = {
        DEFAULT_LANGUAGE = "english",

        REQUIRE_DIRECTORY = "src.data.locales.",
        DIRECTORY = "src/data/locales"
    },

    UI = {
        DEFAULT_BUTTON_TEXT_PADDING = COMMON_VALUES.MEDIUM_PADDING,

        SAVES = {
            RESET_BUTTON_WARN_TIME_OUT = .5,
            NEW_GAME_TRANSITION = { duration = 1.2 },
        },

        BOX_RANCH = {
            LOCKED_SHOP_BUTTON_SPRITE = "assets/sprites/ui/buttons/buttonlocked74x74.png",

            -- `hitboxKey` is the button's hitbox in the boxRanch scene data.
            SHOP_BUTTONS = {
                {
                    key = "upgradeShop",

                    hitboxKey = "upgradeShopButtonHitbox",
                    requirement = SHOP.UPGRADE_SHOP.UNLOCK_REQUIREMENT,

                    targetScene = "upgradeShop"
                },
                {
                    key = "blackMarket",

                    hitboxKey = "blackMarketButtonHitbox",
                    requirement = SHOP.BLACK_MARKET.UNLOCK_REQUIREMENT,

                    targetScene = "blackMarket"
                },
                {
                    key = "sacrifice",

                    hitboxKey = "sacrificeButtonHitbox",
                    requirement = SHOP.SACRIFICIAL_GROUNDS.UNLOCK_REQUIREMENT,

                    targetScene = "sacrificialGrounds"
                }
            }
        },

        SETTINGS = {
            NUMBER_SETTING_CHANGE_INCREMENT = .1,

            NUMBER_SETTING_RANGES = {
                masterVolume = { min = 0, max = 1.5 },
                soundVolume = { min = 0, max = 1.5 },
                trackVolume = { min = 0, max = 1.5 },
                contrast = { min = .5, max = 2 },
                gamma = { min = .5, max = 2 }
            },
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
        },

        DISCORD_URL = "https://www.discord.gg/pQShPG8XPf"
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
            { directory = "src/data/shaders", prefix = "" },
        }
    },

    TWEEN = {
        COMPLETION_EPSILON = 1e-6
    },
}