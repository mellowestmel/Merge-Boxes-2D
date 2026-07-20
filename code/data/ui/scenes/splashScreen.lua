-- ~/code/data/ui/scenes/splashScreen.lua

--// UI \\--
local CONSTANTS = require("code.game.ui.constants")

return {
    splashScreenLogo1 = {
        spritePath = "assets/sprites/ui/splashscreenlogo1.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = CONSTANTS.CENTER_Y,

        zIndex = CONSTANTS.Z_BACKGROUND,
    },

    splashScreenLogo2 = {
        spritePath = "assets/sprites/ui/splashscreenlogo2.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = CONSTANTS.CENTER_Y,

        zIndex = CONSTANTS.Z_BACKGROUND,
    },
}