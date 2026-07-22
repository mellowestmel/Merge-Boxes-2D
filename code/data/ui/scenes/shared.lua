-- ~/code/data/ui/scenes/shared.lua

local RenderModule = require("code.engine.render")

local BOX_CONSTANTS = require("code.game.box.constants")
local CONSTANTS = require("code.game.ui.constants")

local UI_LAYOUT = require("code.data.ui.layout")

return {
    settingsButtonHitbox = {
        spritePath = "assets/sprites/ui/buttoncog74x74.png",

        type = "sprite",

        x = UI_LAYOUT.SHARED.SETTINGS_BUTTON.X,
        y = UI_LAYOUT.SHARED.SETTINGS_BUTTON.Y,

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

        x = UI_LAYOUT.GAME.SPAWN_BUTTON.X,
        y = UI_LAYOUT.GAME.SPAWN_BUTTON.Y + UI_LAYOUT.GAME.SPAWN_BUTTON_ROW_OFFSET,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    shopBackButtonLabel = {
        text = "Back",

        type = "text",

        x = UI_LAYOUT.GAME.SPAWN_BUTTON.X,
        y = UI_LAYOUT.GAME.SPAWN_BUTTON.Y + UI_LAYOUT.GAME.SPAWN_BUTTON_ROW_OFFSET,

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
        y = CONSTANTS.LARGE_PADDING * CONSTANTS.CURRENCY_LABEL_ROW_SPACING_MULTIPLIER,

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

        x = UI_LAYOUT.SHARED.SETTINGS_BUTTON.X - CONSTANTS.MASSIVE_PADDING,
        y = UI_LAYOUT.SHARED.SETTINGS_BUTTON.Y,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GRAY),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    dialoguePortrait = {
        type = "sprite",

        anchorX = 0,
        anchorY = 1,

        x = UI_LAYOUT.SHARED.DIALOGUE.PORTRAIT_X,
        y = UI_LAYOUT.SHARED.DIALOGUE.PORTRAIT_Y,

        scaleX = CONSTANTS.SPRITE_LARGE_SCALE,
        scaleY = CONSTANTS.SPRITE_LARGE_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_DARK),

        zIndex = CONSTANTS.Z_UI_BACKGROUND,
    },

    dialogueBox = {
        spritePath = "assets/sprites/ui/button220x75.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 1,

        x = 0,
        y = _G.RESOLUTION_HEIGHT,

        scaleX = CONSTANTS.SPRITE_HUGE_SCALE,
        scaleY = CONSTANTS.SPRITE_HUGE_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_DARK),

        zIndex = CONSTANTS.Z_UI_BACKGROUND,
    },

    dialogueBoxText = {
        type = "text",

        anchorX = 0,
        anchorY = 1,

        x = 0,
        y = _G.RESOLUTION_HEIGHT,

        zIndex = CONSTANTS.Z_UI_BACKGROUND,
    },
}