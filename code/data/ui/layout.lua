-- ~/code/data/ui/layout.lua

local BOX_CONSTANTS = require("code.game.box.constants")

return {
    MAIN_MENU = {
        START_BUTTON = {
            Y = 375,
        },

        LOGO_PRIMARY_OFFSET_Y = 225,
        LOGO_SECONDARY_OFFSET_Y = 100,

        LOGO_PRIMARY_SCALE = 0.5,
        LOGO_SECONDARY_SCALE = 0.35,
    },

    SHARED = {
        SETTINGS_BUTTON = {
            X = _G.RESOLUTION_WIDTH - 35,
            Y = 35
        },

        DISCORD_BUTTON = {
            X = _G.RESOLUTION_WIDTH - 35,
            Y = _G.RESOLUTION_HEIGHT - 35
        },

        BACK_BUTTON_OFFSET = 50,

        DIALOGUE = {
            PORTRAIT_X = 400,
            PORTRAIT_Y = 425,
        }
    },

    SETTINGS = {
        CATEGORY_ROW_Y = 500,
        CATEGORY_SCROLL_OFFSET_X = 125,

        SETTING_NAME_LABEL_OFFSET_X = -225,

        SETTING_TOGGLE_OFFSET_X = 200,

        SETTING_DECREASE_OFFSET_X = 100,
        SETTING_INCREASE_OFFSET_X = 300,

        SETTING_VALUE_LABEL_OFFSET_X = 200,
    },

    GAME = {
        SPAWN_BUTTON = {
            X = BOX_CONSTANTS.AREA_WIDTH + (_G.RESOLUTION_WIDTH - BOX_CONSTANTS.AREA_WIDTH) / 2,
            Y = 475,
        },

        SPAWN_BUTTON_ROW_OFFSET = 65,

        AUTO_SPAWN_BUTTON_HEIGHT_SCALE = 0.6,
        AUTO_SPAWN_LABEL_SCALE = 0.75,
    },

    SAVE_FILES = {
        SLOT_OFFSET = 325,
        Y_DIVIDER = 1.6,
        LOAD_BUTTON_OFFSET = 60,
        RESET_BUTTON_OFFSET = 10,
        TEMPLATE_ROTATION = math.rad(90),
        TEMPLATE_SCALE_X = 1.5,
        TEMPLATE_SMALL_SCALE = 0.55,

        HIGHEST_TIER_LABEL_OFFSET = 40,
        PLAYTIME_LABEL_OFFSET = 65,
    },

    UPGRADE_SHOP = {
        BIRB = {
            X = 230,
            Y = 125,
        },

        BACKGROUND_FRAME = {
            SCALE_X = 0.9,
            SCALE_Y = 0.6,
            OFFSET_Y = -225,
        },

        SCROLL_WHEEL = {
            SCALE_X = 0.1,
        },

        TEXT_OFFSET_RATIO = 0.3
    },
}