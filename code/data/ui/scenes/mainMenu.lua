-- ~/code/data/ui/scenes/mainMenu.lua

local RenderModule = require("code.engine.render")

local CONSTANTS = require("code.game.ui.constants")
local UILayoutData = require("code.data.ui.layout")

return {
    background = {
        spritePath = "assets/sprites/backgrounds/mainmenubg.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = CONSTANTS.Z_BACKGROUND,
    },

    logo = {
        spritePath = "assets/sprites/ui/logo.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.mainMenu.logoPrimaryOffsetY,

        scaleX = UILayoutData.mainMenu.logoPrimaryScale,
        scaleY = UILayoutData.mainMenu.logoPrimaryScale,

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    logo2 = {
        spritePath = "assets/sprites/ui/logo2.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.mainMenu.logoSecondaryOffsetY,

        scaleX = UILayoutData.mainMenu.logoSecondaryScale,
        scaleY = UILayoutData.mainMenu.logoSecondaryScale,

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    playGameButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GREEN),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    playGameButtonLabel = {
        text = "Play Game",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_LARGE
        ),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    quitButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y + CONSTANTS.BUTTON_VERTICAL_GAP,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    quitButtonLabel = {
        text = "Quit Game",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y + CONSTANTS.BUTTON_VERTICAL_GAP,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_LARGE
        ),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },
}