-- ~/code/data/ui/scenes/mainMenu.lua

local RenderModule = require("code.engine.render")

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
        y = UI_LAYOUT.MAIN_MENU.START_BUTTON.Y - UI_LAYOUT.MAIN_MENU.LOGO_PRIMARY_OFFSET_Y,

        scaleX = UI_LAYOUT.MAIN_MENU.LOGO_PRIMARY_SCALE,
        scaleY = UI_LAYOUT.MAIN_MENU.LOGO_PRIMARY_SCALE,

        zIndex = CONSTANTS.Z_UI_BACKGROUND,
    },

    logo2 = {
        spritePath = "assets/sprites/ui/logo2.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.START_BUTTON.Y - UI_LAYOUT.MAIN_MENU.LOGO_SECONDARY_OFFSET_Y,

        scaleX = UI_LAYOUT.MAIN_MENU.LOGO_SECONDARY_SCALE,
        scaleY = UI_LAYOUT.MAIN_MENU.LOGO_SECONDARY_SCALE,

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    discordButtonHitbox = {
        spritePath = "assets/sprites/ui/buttondiscord74x74.png",

        type = "sprite",

        x = UI_LAYOUT.SHARED.DISCORD_BUTTON.X,
        y = UI_LAYOUT.SHARED.DISCORD_BUTTON.Y,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    playGameButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.START_BUTTON.Y,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GREEN),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    playGameButtonLabel = {
        text = "Play Game",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.START_BUTTON.Y,

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
        y = UI_LAYOUT.MAIN_MENU.START_BUTTON.Y + CONSTANTS.BUTTON_VERTICAL_GAP,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    quitButtonLabel = {
        text = "Quit Game",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.START_BUTTON.Y + CONSTANTS.BUTTON_VERTICAL_GAP,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_LARGE
        ),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },
}