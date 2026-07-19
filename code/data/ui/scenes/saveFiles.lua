-- ~/code/data/ui/scenes/saveFiles.lua

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

    backToMenuButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y + CONSTANTS.BUTTON_VERTICAL_GAP,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    backToMenuButtonLabel = {
        text = "Back",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y + CONSTANTS.BUTTON_VERTICAL_GAP,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_BUTTON),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    templateSaveFileBackground = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y / UI_LAYOUT.SAVE_FILES.Y_DIVIDER,

        rotation = UI_LAYOUT.SAVE_FILES.TEMPLATE_ROTATION,
        scaleX = UI_LAYOUT.SAVE_FILES.TEMPLATE_SCALE_X,
        scaleY = CONSTANTS.SPRITE_LARGE_SCALE,

        color = RenderModule:createColor(
            CONSTANTS.COLOR_DARK[1],
            CONSTANTS.COLOR_DARK[2],
            CONSTANTS.COLOR_DARK[3],
            0.8
        ),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    templateSaveFileLabel = {
        text = "Slot ",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y - UI_LAYOUT.SAVE_FILES.SLOT_OFFSET,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_BUTTON),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    templateSaveFileLoadButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y - UI_LAYOUT.SAVE_FILES.LOAD_BUTTON_OFFSET,

        scaleX = UI_LAYOUT.SAVE_FILES.TEMPLATE_SMALL_SCALE,
        scaleY = UI_LAYOUT.SAVE_FILES.TEMPLATE_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GREEN),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    templateSaveFileLoadButtonLabel = {
        text = "Load File",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y - UI_LAYOUT.SAVE_FILES.LOAD_BUTTON_OFFSET,

        scaleX = UI_LAYOUT.SAVE_FILES.TEMPLATE_SMALL_SCALE,
        scaleY = UI_LAYOUT.SAVE_FILES.TEMPLATE_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_BUTTON),

        zIndex = CONSTANTS.Z_UI_TEXT + 1,
    },

    templateSaveFileResetButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y - UI_LAYOUT.SAVE_FILES.RESET_BUTTON_OFFSET,

        scaleX = UI_LAYOUT.SAVE_FILES.TEMPLATE_SMALL_SCALE,
        scaleY = UI_LAYOUT.SAVE_FILES.TEMPLATE_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    templateSaveFileResetButtonLabel = {
        text = "Reset File",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y - UI_LAYOUT.SAVE_FILES.RESET_BUTTON_OFFSET,

        scaleX = UI_LAYOUT.SAVE_FILES.TEMPLATE_SMALL_SCALE,
        scaleY = UI_LAYOUT.SAVE_FILES.TEMPLATE_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_BUTTON),

        zIndex = CONSTANTS.Z_UI_TEXT + 1,
    },

    templateSaveFileBoxPreview = {
        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y / UI_LAYOUT.SAVE_FILES.Y_DIVIDER - CONSTANTS.LARGE_PADDING,

        scaleX = CONSTANTS.SPRITE_DEFAULT_SCALE,
        scaleY = CONSTANTS.SPRITE_DEFAULT_SCALE,

        zIndex = CONSTANTS.Z_UI_TEXT + 2,
    },

    templateSaveFilePlusIcon = {
        spritePath = "assets/sprites/ui/buttonplus100x100.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y / UI_LAYOUT.SAVE_FILES.Y_DIVIDER - CONSTANTS.LARGE_PADDING,

        scaleX = CONSTANTS.SPRITE_DEFAULT_SCALE,
        scaleY = CONSTANTS.SPRITE_DEFAULT_SCALE,

        zIndex = CONSTANTS.Z_UI_TEXT + 2,
    },

    templateSaveHighestTier = {
        text = "Highest Tier: 1",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y - UI_LAYOUT.SAVE_FILES.SLOT_OFFSET + 40,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_SMALL),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    templateSavePlaytime = {
        text = "0:00:00",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y - UI_LAYOUT.SAVE_FILES.SLOT_OFFSET + 65,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_MEDIUM),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },
}