-- ~/code/data/ui/scenes/upgradeShop.lua

local RenderElementModule = require("code.engine.render.element")

local CONSTANTS = require("code.game.ui.constants")
local UILayoutData = require("code.data.ui.layout")

return {
    background = {
        spritePath = "assets/sprites/backgrounds/upgradeshopbg.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = CONSTANTS.Z_BACKGROUND,
    },

    upgradesFrameBackground = {
        spritePath = "assets/sprites/ui/sidebar.png",

        type = "sprite",

        scaleX = UILayoutData.upgradeShop.backgroundFrame.scaleX,
        scaleY = UILayoutData.upgradeShop.backgroundFrame.scaleY,

        x = UILayoutData.game.spawnButton.x,
        y = UILayoutData.game.spawnButton.y + UILayoutData.upgradeShop.backgroundFrame.offsetY,

        color = RenderModule:createColorFromTable(CONSTANTS.INVISIBLE_COLOR),

        zIndex = CONSTANTS.Z_UI_BACKGROUND,
    },

    upgradesFrameScrollWheel = {
        spritePath = "assets/sprites/ui/button74x74.png",

        type = "sprite",

        scaleX = UILayoutData.upgradeShop.scrollWheel.scaleX,

        x = CONSTANTS.CENTER_X,
        y = CONSTANTS.CENTER_Y,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GRAY),

        zIndex = CONSTANTS.Z_UI_OVERLAY,
    },

    upgradeBuyHitbox = {
        spritePath = "assets/sprites/ui/button220x75.png",

        type = "sprite",

        scaleX = 0.9,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GRAY),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    upgradeName = {
        type = "text",

        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_MEDIUM
        ),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    upgradeCost = {
        type = "text",

        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_SMALL
        ),

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_YELLOW),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    upgradeStackCounter = {
        spritePath = "assets/sprites/ui/light10x10.png",

        type = "sprite",

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_DARK),

        zIndex = CONSTANTS.Z_UI_OVERLAY,
    },

    theBirbsWord = {
        spritePath = "assets/sprites/birb.png",

        type = "sprite",

        x = UILayoutData.upgradeShop.birb.x,
        y = UILayoutData.upgradeShop.birb.y,

        zIndex = CONSTANTS.Z_UI_BUTTON,
    }
}