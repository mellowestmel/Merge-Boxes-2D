local COMMON_VALUES = require("src.data.ui.commonValues")
local UILayoutData = require("src.data.ui.layout")

return {
    background = {
        spritePath = "assets/sprites/ui/backgrounds/mainmenubg.png",
        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = COMMON_VALUES.Z_BACKGROUND,
    },

    logo = {
        spritePath = "assets/sprites/ui/logos/mergeboxes.png",
        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.mainMenu.logo.primary.offsetY,

        scaleX = UILayoutData.mainMenu.logo.primary.scale,
        scaleY = UILayoutData.mainMenu.logo.primary.scale,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    logo2 = {
        spritePath = "assets/sprites/ui/logos/2d.png",
        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.mainMenu.logo.secondary.offsetY,

        scaleX = UILayoutData.mainMenu.logo.secondary.scale,
        scaleY = UILayoutData.mainMenu.logo.secondary.scale,

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