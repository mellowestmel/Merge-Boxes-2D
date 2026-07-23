-- ~/code/data/ui/scenes/saveFiles.lua

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

    backToMenuButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y + CONSTANTS.BUTTON_VERTICAL_GAP,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    backToMenuButtonLabel = {
        text = "Back",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y + CONSTANTS.BUTTON_VERTICAL_GAP,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_LARGE),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    templateSaveFileBackground = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y / UILayoutData.saveFiles.yDivider,

        rotation = UILayoutData.saveFiles.templateRotation,
        scaleX = UILayoutData.saveFiles.templateScaleX,
        scaleY = CONSTANTS.SPRITE_LARGE_SCALE,

        color = RenderModule:createColor(
            CONSTANTS.COLOR_DARK[1],
            CONSTANTS.COLOR_DARK[2],
            CONSTANTS.COLOR_DARK[3],
            CONSTANTS.HIGH_ALPHA
        ),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    templateSaveFileLabel = {
        text = "Slot ",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.saveFiles.slotOffset,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_LARGE),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    templateSaveFileLoadButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.saveFiles.loadButtonOffset,

        scaleX = UILayoutData.saveFiles.templateSmallScale,
        scaleY = UILayoutData.saveFiles.templateSmallScale,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GREEN),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    templateSaveFileLoadButtonLabel = {
        text = "Load File",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.saveFiles.loadButtonOffset,

        scaleX = UILayoutData.saveFiles.templateSmallScale,
        scaleY = UILayoutData.saveFiles.templateSmallScale,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_LARGE),

        zIndex = CONSTANTS.Z_UI_TEXT_OVERLAY,
    },

    templateSaveFileResetButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.saveFiles.resetButtonOffset,

        scaleX = UILayoutData.saveFiles.templateSmallScale,
        scaleY = UILayoutData.saveFiles.templateSmallScale,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    templateSaveFileResetButtonLabel = {
        text = "Reset File",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.saveFiles.resetButtonOffset,

        scaleX = UILayoutData.saveFiles.templateSmallScale,
        scaleY = UILayoutData.saveFiles.templateSmallScale,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_LARGE),

        zIndex = CONSTANTS.Z_UI_TEXT_OVERLAY,
    },

    templateSaveFileBoxPreview = {
        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y / UILayoutData.saveFiles.yDivider - CONSTANTS.LARGE_PADDING,

        scaleX = CONSTANTS.SPRITE_DEFAULT_SCALE,
        scaleY = CONSTANTS.SPRITE_DEFAULT_SCALE,

        zIndex = CONSTANTS.Z_UI_ICON_OVERLAY,
    },

    templateSaveFilePlusIcon = {
        spritePath = "assets/sprites/ui/buttonplus100x100.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y / UILayoutData.saveFiles.yDivider - CONSTANTS.LARGE_PADDING,

        scaleX = CONSTANTS.SPRITE_DEFAULT_SCALE,
        scaleY = CONSTANTS.SPRITE_DEFAULT_SCALE,

        zIndex = CONSTANTS.Z_UI_ICON_OVERLAY,
    },

    templateSaveHighestTier = {
        text = "Highest Tier: 1",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.saveFiles.slotOffset + UILayoutData.saveFiles.highestTierLabelOffset,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_SMALL),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    templateSavePlaytime = {
        text = "0:00:00",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.saveFiles.slotOffset + UILayoutData.saveFiles.playtimeLabelOffset,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_MEDIUM),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },
}