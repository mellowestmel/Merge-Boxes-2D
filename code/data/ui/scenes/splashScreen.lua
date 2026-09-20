-- ~/code/data/ui/scenes/splashScreen.lua

local COMMON_VALUES = require("code.data.ui.commonValues")

return {
    splashScreenLogo1 = {
        spritePath = "assets/sprites/ui/splashscreenlogo1.png",

        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = COMMON_VALUES.CENTER_Y,

        zIndex = COMMON_VALUES.Z_BACKGROUND,
    },

    splashScreenLogo2 = {
        spritePath = "assets/sprites/ui/splashscreenlogo2.png",

        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = COMMON_VALUES.CENTER_Y,

        zIndex = COMMON_VALUES.Z_BACKGROUND,
    },
}