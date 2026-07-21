-- ~/code/data/ui/scenes/shared.lua

local RenderModule = require("code.engine.render")

local BOX_CONSTANTS = require("code.game.box.constants")
local CONSTANTS = require("code.game.ui.constants")

local UI_LAYOUT = require("code.data.ui.layout")

return {
    settingsButtonHitbox = {
        spritePath = "assets/sprites/ui/buttoncog74x74.png",

        type = "sprite",

        x = UI_LAYOUT.SETTINGS_BUTTON.x,
        y = UI_LAYOUT.SETTINGS_BUTTON.y,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GRAY),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    sidebarBackground = {
        spritePath = "assets/sprites/ui/sidebar.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        x = BOX_CONSTANTS.AREA_WIDTH,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_DARK),

        zIndex = CONSTANTS.Z_UI_BACKGROUND,
    },

    shopBackButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = UI_LAYOUT.SPAWN_BUTTON.x,
        y = UI_LAYOUT.SPAWN_BUTTON.y + 65,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    shopBackButtonLabel = {
        text = "Back",

        type = "text",

        x = UI_LAYOUT.SPAWN_BUTTON.x,
        y = UI_LAYOUT.SPAWN_BUTTON.y + 65,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_LARGE
        ),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    creditsLabel = {
        text = "Credits:",

        type = "text",

        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_SMALL
        ),

        anchorX = 0,
        anchorY = 0,

        x = CONSTANTS.SMALL_PADDING,
        y = CONSTANTS.LARGE_PADDING,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_YELLOW),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    holyCatnipLabel = {
        text = "Holy Catnip:",

        type = "text",

        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_SMALL
        ),

        anchorX = 0,
        anchorY = 0,

        x = CONSTANTS.SMALL_PADDING,
        y = CONSTANTS.LARGE_PADDING * 1.75,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_PURPLE),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    sessionPlaytimeLabel = {
        text = "Session Time: ",

        type = "text",

        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_SMALL
        ),

        anchorX = 0,
        anchorY = 0,

        x = CONSTANTS.SMALL_PADDING,
        y = CONSTANTS.SMALL_PADDING,

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    backToMenuButtonHitbox = {
        spritePath = "assets/sprites/ui/buttonmenu74x74.png",

        type = "sprite",

        x = UI_LAYOUT.SETTINGS_BUTTON.x - 55,
        y = UI_LAYOUT.SETTINGS_BUTTON.y,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GRAY),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    dialogueBox = {
        spritePath = "assets/sprites/ui/button220x75.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 1,

        x = 0,
        y = _G.WINDOW_HEIGHT,

        scaleX = 2.5,
        scaleY = 2.5,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_DARK),

        zIndex = CONSTANTS.Z_UI_BACKGROUND,
    },

    dialogueBoxText = {
        type = "text",

        anchorX = 0,
        anchorY = 1,

        x = 0,
        y = _G.WINDOW_HEIGHT,

        zIndex = CONSTANTS.Z_UI_BACKGROUND,
    },
}