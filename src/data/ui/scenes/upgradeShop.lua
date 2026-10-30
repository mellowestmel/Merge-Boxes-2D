local COMMON_VALUES = require("src.data.ui.commonValues")
local UILayoutData = require("src.data.ui.layout")

return {
    background = {
        spritePath = "assets/sprites/ui/backgrounds/upgradeshopbg.png",
        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = COMMON_VALUES.Z_BACKGROUND,
    },

    upgradesFrameBackground = {
        spritePath = "assets/sprites/ui/backgrounds/sidebar.png",
        type = "sprite",

        scaleX = UILayoutData.upgradeShop.backgroundFrame.scaleX,
        scaleY = UILayoutData.upgradeShop.backgroundFrame.scaleY,

        x = UILayoutData.boxRanch.spawnButton.x,
        y = UILayoutData.boxRanch.spawnButton.y + UILayoutData.upgradeShop.backgroundFrame.offsetY,

        color = COMMON_VALUES.COLOR_DARK,

        zIndex = COMMON_VALUES.Z_UI_BACKGROUND + .1,
    },

    upgradesFrameScrollWheel = {
        spritePath = "assets/sprites/ui/misc/scroller.png",
        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = COMMON_VALUES.CENTER_Y,

        color = COMMON_VALUES.COLOR_GRAY,

        zIndex = COMMON_VALUES.Z_UI_OVERLAY,
    },

    upgradeBuyHitbox = {
        spritePath = "assets/sprites/ui/buttons/button220x75.png",
        type = "sprite",

        scaleX = UILayoutData.upgradeShop.upgradeButton.scaleX,

        color = COMMON_VALUES.COLOR_GRAY,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    upgradeName = {
        type = "text",

        font = love.graphics.newFont(
            COMMON_VALUES.DEFAULT_FONT_PATH,
            COMMON_VALUES.FONT_MEDIUM
        ),

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    upgradeCost = {
        type = "text",

        font = love.graphics.newFont(
            COMMON_VALUES.DEFAULT_FONT_PATH,
            COMMON_VALUES.FONT_SMALL
        ),

        color = COMMON_VALUES.COLOR_YELLOW,

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    upgradeStackCounter = {
        spritePath = "assets/sprites/ui/misc/light10x10.png",
        type = "sprite",

        color = COMMON_VALUES.COLOR_DARK,

        zIndex = COMMON_VALUES.Z_UI_OVERLAY,
    },

    upgradeDescriptionBackground = {
        spritePath = "assets/sprites/ui/buttons/button220x75.png",
        type = "sprite",

        color = COMMON_VALUES.COLOR_DARK,
        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    upgradeDescriptionText = {
        type = "text",

        zIndex = COMMON_VALUES.Z_UI_TEXT,

        font = love.graphics.newFont(
            COMMON_VALUES.DEFAULT_FONT_PATH,
            COMMON_VALUES.FONT_MEDIUM
        ),
    },

    birdSecret = {
        spritePath = "assets/sprites/ui/misc/familiarbird.png",
        type = "sprite",

        x = UILayoutData.upgradeShop.birdSecret.x,
        y = UILayoutData.upgradeShop.birdSecret.y,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },
}