-- ~/code/data/ui/scenes/blackMarket.lua

--// UI \\--
local CONSTANTS = require("code.game.ui.constants")
local UI_LAYOUT = require("code.data.ui.layout")

return {
    background = {
        spritePath = "assets/sprites/backgrounds/menubg.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = CONSTANTS.Z_BACKGROUND,
    },

    shopkeeper = {
        spritePath = "assets/sprites/boxes/box10.png",

        type = "sprite",

        x = UI_LAYOUT.SHOP.SHOPKEEPER_X,
        y = UI_LAYOUT.SHOP.SHOPKEEPER_Y,

        anchorX = UI_LAYOUT.SHOP.SHOPKEEPER_ANCHOR_X,
        anchorY = UI_LAYOUT.SHOP.SHOPKEEPER_ANCHOR_Y,

        scaleX = CONSTANTS.SPRITE_LARGE_SCALE,
        scaleY = CONSTANTS.SPRITE_LARGE_SCALE,

        zIndex = CONSTANTS.Z_WORLD,
    },
}