-- ~/code/data/ui/scenes/shared.lua

local RenderUtilsModule = require("code.engine.render.utils")

local BOX_CONSTANTS = require("code.game.boxes.constants")
local CONSTANTS = require("code.game.ui.constants")

local UILayoutData = require("code.data.ui.layout")

return {
    settingsButtonHitbox = {
        spritePath = "assets/sprites/ui/buttoncog74x74.png",

        type = "sprite",

        x = UILayoutData.shared.settingsButton.x,
        y = UILayoutData.shared.settingsButton.y,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderUtilsModule.CreateColorFromTable(CONSTANTS.COLOR_GRAY),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    discordButtonHitbox = {
        spritePath = "assets/sprites/ui/buttondiscord74x74.png",

        type = "sprite",

        x = UILayoutData.shared.discordButton.x,
        y = UILayoutData.shared.discordButton.y,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    sidebarBackground = {
        spritePath = "assets/sprites/ui/sidebar.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        x = BOX_CONSTANTS.AREA_WIDTH,

        color = RenderUtilsModule.CreateColorFromTable(CONSTANTS.COLOR_DARK),

        zIndex = CONSTANTS.Z_UI_BACKGROUND,
    },

    shopBackButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = UILayoutData.game.spawnButton.x,
        y = UILayoutData.game.spawnButton.y + UILayoutData.game.spawnButtonRowOffset,

        color = RenderUtilsModule.CreateColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    shopBackButtonLabel = {
        text = "Back",

        type = "text",

        x = UILayoutData.game.spawnButton.x,
        y = UILayoutData.game.spawnButton.y + UILayoutData.game.spawnButtonRowOffset,

        color = RenderUtilsModule.CreateColorFromTable(CONSTANTS.COLOR_WHITE),
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

        color = RenderUtilsModule.CreateColorFromTable(CONSTANTS.COLOR_YELLOW),

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

        color = RenderUtilsModule.CreateColorFromTable(CONSTANTS.COLOR_PURPLE),

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

        x = UILayoutData.shared.settingsButton.x - CONSTANTS.MASSIVE_PADDING,
        y = UILayoutData.shared.settingsButton.y,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderUtilsModule.CreateColorFromTable(CONSTANTS.COLOR_GRAY),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    dialoguePortrait = {
        type = "sprite",

        anchorX = 0,
        anchorY = 1,

        x = UILayoutData.shared.dialogue.portraitX,
        y = UILayoutData.shared.dialogue.portraitY,

        scaleX = CONSTANTS.SPRITE_LARGE_SCALE,
        scaleY = CONSTANTS.SPRITE_LARGE_SCALE,

        color = RenderUtilsModule.CreateColorFromTable(CONSTANTS.COLOR_DARK),

        zIndex = CONSTANTS.Z_UI_BACKGROUND,
    },

    dialogueBox = {
        spritePath = "assets/sprites/ui/button220x75.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 1,

        x = 0,
        y = RESOLUTION_HEIGHT,

        scaleX = CONSTANTS.SPRITE_HUGE_SCALE,
        scaleY = CONSTANTS.SPRITE_HUGE_SCALE,

        color = RenderUtilsModule.CreateColorFromTable(CONSTANTS.COLOR_DARK),

        zIndex = CONSTANTS.Z_UI_BACKGROUND,
    },

    dialogueBoxText = {
        type = "text",

        anchorX = 0,
        anchorY = 1,

        x = 0,
        y = RESOLUTION_HEIGHT,

        zIndex = CONSTANTS.Z_UI_BACKGROUND,
    },
}