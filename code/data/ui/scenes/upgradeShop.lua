-- ~/code/data/ui/scenes/upgradeShop.lua

--// ENGINE \\--
local RenderModule = require("code.engine.render")

--// UI \\--
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

        x = 230,
        y = 125,

        zIndex = CONSTANTS.Z_UI_BUTTON,
    }
}