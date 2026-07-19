-- ~/code/data/ui/scenes/mainMenu.lua

--/// ENGINE \\\--
local RenderModule = require("code.engine.render")

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

    logo = {
        spritePath = "assets/sprites/ui/logo.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y - UI_LAYOUT.MAIN_MENU.LOGO_PRIMARY_OFFSET_Y,

        scaleX = 0.5,
        scaleY = 0.5,

        zIndex = CONSTANTS.Z_WORLD,
    },

    logo2 = {
        spritePath = "assets/sprites/ui/logo2.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y - UI_LAYOUT.MAIN_MENU.LOGO_SECONDARY_OFFSET_Y,

        scaleX = 0.35,
        scaleY = 0.35,

        zIndex = CONSTANTS.Z_WORLD,
    },

    playGameButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GREEN),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    playGameButtonLabel = {
        text = "Play Game",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_BUTTON
        ),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    quitButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y + CONSTANTS.BUTTON_VERTICAL_GAP,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    quitButtonLabel = {
        text = "Quit Game",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y + CONSTANTS.BUTTON_VERTICAL_GAP,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_BUTTON
        ),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },
}