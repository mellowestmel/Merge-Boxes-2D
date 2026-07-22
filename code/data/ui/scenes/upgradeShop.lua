-- ~/code/data/ui/scenes/upgradeShop.lua

local CONSTANTS = require("code.game.ui.constants")
local UI_LAYOUT = require("code.data.ui.layout")

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

        x = UI_LAYOUT.UPGRADE_SHOP.BIRB.X,
        y = UI_LAYOUT.UPGRADE_SHOP.BIRB.Y,

        zIndex = CONSTANTS.Z_UI_BUTTON,
    }
}