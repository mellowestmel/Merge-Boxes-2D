-- ~/code/data/ui/scenes/mainMenu.lua

local COMMON_VALUES = require("code.data.ui.commonValues")
local UILayoutData = require("code.data.ui.layout")

return {
    background = {
        spritePath = "assets/sprites/backgrounds/mainmenubg.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = COMMON_VALUES.Z_BACKGROUND,
    },

    logo = {
        spritePath = "assets/sprites/ui/logo.png",

        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.mainMenu.logoPrimaryOffsetY,

        scaleX = UILayoutData.mainMenu.logoPrimaryScale,
        scaleY = UILayoutData.mainMenu.logoPrimaryScale,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    logo2 = {
        spritePath = "assets/sprites/ui/logo2.png",

        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.mainMenu.logoSecondaryOffsetY,

        scaleX = UILayoutData.mainMenu.logoSecondaryScale,
        scaleY = UILayoutData.mainMenu.logoSecondaryScale,

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    playGameButtonHitbox = {
        spritePath = COMMON_VALUES.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y,

        color = COMMON_VALUES.COLOR_GREEN,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    playGameButtonLabel = {
        textKey = "mainMenu.play",

        type = "text",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y,

        color = COMMON_VALUES.COLOR_WHITE,
        font = love.graphics.newFont(
            COMMON_VALUES.DEFAULT_FONT_PATH,
            COMMON_VALUES.FONT_LARGE
        ),

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    quitButtonHitbox = {
        spritePath = COMMON_VALUES.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y + COMMON_VALUES.BUTTON_VERTICAL_GAP,

        color = COMMON_VALUES.COLOR_RED,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    quitButtonLabel = {
        textKey = "mainMenu.quit",

        type = "text",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y + COMMON_VALUES.BUTTON_VERTICAL_GAP,

        color = COMMON_VALUES.COLOR_WHITE,
        font = love.graphics.newFont(
            COMMON_VALUES.DEFAULT_FONT_PATH,
            COMMON_VALUES.FONT_LARGE
        ),

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },
}