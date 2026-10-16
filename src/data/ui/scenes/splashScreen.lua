-- ~/src/data/ui/scenes/splashScreen.lua

local COMMON_VALUES = require("src.data.ui.commonValues")

return {
    splashScreenLogo1 = {
        spritePath = "assets/sprites/ui/logos/splashscreenlogo1.png",

        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = COMMON_VALUES.CENTER_Y,

        zIndex = COMMON_VALUES.Z_BACKGROUND,
    },

    splashScreenLogo2 = {
        spritePath = "assets/sprites/ui/logos/splashscreenlogo2.png",

        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = COMMON_VALUES.CENTER_Y,

        zIndex = COMMON_VALUES.Z_BACKGROUND,
    },
}