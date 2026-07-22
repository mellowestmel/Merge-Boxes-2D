-- ~/code/data/ui/scenes/upgradeShop.lua

local CONSTANTS = require("code.game.ui.constants")

return {
    background = {
        spritePath = "assets/sprites/backgrounds/upgradeshopbg.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = CONSTANTS.Z_BACKGROUND,
    },

    theBirbsWord = {
        spritePath = "assets/sprites/birb.png",

        type = "sprite",

        x = 230,
        y = 125,

        zIndex = CONSTANTS.Z_UI_BUTTON,
    }
}