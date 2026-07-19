-- ~/code/data/ui/scenes/blackMarket.lua

--// UI \\--
local CONSTANTS = require("code.game.ui.constants")

return {
    background = {
        spritePath = "assets/sprites/backgrounds/menubg.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = 1,
    },

    shopkeeper = {
        spritePath = "assets/sprites/boxes/box10.png",

        type = "sprite",

        x = 300,
        y = 300,

        scaleX = CONSTANTS.SPRITE_LARGE_SCALE,
        scaleY = CONSTANTS.SPRITE_LARGE_SCALE,

        zIndex = 2,
    },
}