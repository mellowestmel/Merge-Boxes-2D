-- ~/code/data/ui/layout.lua

local BOX_CONSTANTS = require("code.game.box.constants")

return {
    MAIN_MENU = {
        BUTTON_Y = 375,

        LOGO_PRIMARY_OFFSET_Y = 225,
        LOGO_SECONDARY_OFFSET_Y = 100,
    },

    SETTINGS_BUTTON = {
        x = _G.WINDOW_WIDTH - 35,
        y = 35,
    },

    SPAWN_BUTTON = {
        x = BOX_CONSTANTS.AREA_WIDTH + (_G.WINDOW_WIDTH - BOX_CONSTANTS.AREA_WIDTH) / 2,
        y = 475,
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

    SHOP = {
        SHOPKEEPER_X = 25,
        SHOPKEEPER_Y = 425,

        SHOPKEEPER_ANCHOR_X = 0,
        SHOPKEEPER_ANCHOR_Y = 1,
    }
}