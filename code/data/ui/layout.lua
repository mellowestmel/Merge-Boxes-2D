-- ~/code/data/ui/layout.lua

local BOX_CONSTANTS = require("code.game.box.constants")

return {
    MAIN_MENU = {
        START_BUTTON = {
            Y = 375,
        },

        LOGO_PRIMARY_OFFSET_Y = 225,
        LOGO_SECONDARY_OFFSET_Y = 100,
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
        }
    },

    SAVE_FILES = {
        SLOT_OFFSET = 325,
        Y_DIVIDER = 1.6,
        LOAD_BUTTON_OFFSET = 60,
        RESET_BUTTON_OFFSET = 10,
        TEMPLATE_ROTATION = math.rad(90),
        TEMPLATE_SCALE_X = 1.5,
        TEMPLATE_SMALL_SCALE = 0.55,
    },
}