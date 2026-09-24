-- ~/code/data/ui/scenes/saveFiles.lua

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

    backToMenuButtonHitbox = {
        spritePath = COMMON_VALUES.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y + COMMON_VALUES.BUTTON_VERTICAL_GAP,

        color = COMMON_VALUES.COLOR_RED,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    backToMenuButtonLabel = {
        textKey = "common.back",

        type = "text",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y + COMMON_VALUES.BUTTON_VERTICAL_GAP,

        color = COMMON_VALUES.COLOR_WHITE,
        font = love.graphics.newFont(COMMON_VALUES.DEFAULT_FONT_PATH, COMMON_VALUES.FONT_LARGE),

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    templateSaveFileBackground = {
        spritePath = COMMON_VALUES.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y / UILayoutData.saveFiles.yDivider,

        rotation = UILayoutData.saveFiles.templateRotation,
        scaleX = UILayoutData.saveFiles.templateScaleX,
        scaleY = COMMON_VALUES.SPRITE_LARGE_SCALE,

        color = {
            COMMON_VALUES.COLOR_DARK[1],
            COMMON_VALUES.COLOR_DARK[2],
            COMMON_VALUES.COLOR_DARK[3],
            COMMON_VALUES.HIGH_ALPHA
        },

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    templateSaveFileLabel = {
        type = "text",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.saveFiles.slotOffset,

        color = COMMON_VALUES.COLOR_WHITE,
        font = love.graphics.newFont(COMMON_VALUES.DEFAULT_FONT_PATH, COMMON_VALUES.FONT_LARGE),

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    templateSaveFileLoadButtonHitbox = {
        spritePath = COMMON_VALUES.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.saveFiles.loadButtonOffset,

        scaleX = UILayoutData.saveFiles.templateSmallScale,
        scaleY = UILayoutData.saveFiles.templateSmallScale,

        color = COMMON_VALUES.COLOR_GREEN,

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    templateSaveFileLoadButtonLabel = {
        textKey = "saveFiles.loadFile",

        type = "text",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.saveFiles.loadButtonOffset,

        scaleX = UILayoutData.saveFiles.templateSmallScale,
        scaleY = UILayoutData.saveFiles.templateSmallScale,

        color = COMMON_VALUES.COLOR_WHITE,
        font = love.graphics.newFont(COMMON_VALUES.DEFAULT_FONT_PATH, COMMON_VALUES.FONT_LARGE),

        zIndex = COMMON_VALUES.Z_UI_TEXT_OVERLAY,
    },

    templateSaveFileResetButtonHitbox = {
        spritePath = COMMON_VALUES.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.saveFiles.resetButtonOffset,

        scaleX = UILayoutData.saveFiles.templateSmallScale,
        scaleY = UILayoutData.saveFiles.templateSmallScale,

        color = COMMON_VALUES.COLOR_RED,

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    templateSaveFileResetButtonLabel = {
        textKey = "saveFiles.resetFile",

        type = "text",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.saveFiles.resetButtonOffset,

        scaleX = UILayoutData.saveFiles.templateSmallScale,
        scaleY = UILayoutData.saveFiles.templateSmallScale,

        color = COMMON_VALUES.COLOR_WHITE,
        font = love.graphics.newFont(COMMON_VALUES.DEFAULT_FONT_PATH, COMMON_VALUES.FONT_LARGE),

        zIndex = COMMON_VALUES.Z_UI_TEXT_OVERLAY,
    },

    templateSaveFileBoxPreview = {
        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y / UILayoutData.saveFiles.yDivider - COMMON_VALUES.LARGE_PADDING,

        scaleX = COMMON_VALUES.SPRITE_DEFAULT_SCALE,
        scaleY = COMMON_VALUES.SPRITE_DEFAULT_SCALE,

        zIndex = COMMON_VALUES.Z_UI_ICON_OVERLAY,
    },

    templateSaveFilePlusIcon = {
        spritePath = "assets/sprites/ui/buttons/buttonplus100x100.png",

        type = "sprite",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y / UILayoutData.saveFiles.yDivider - COMMON_VALUES.LARGE_PADDING,

        scaleX = COMMON_VALUES.SPRITE_DEFAULT_SCALE,
        scaleY = COMMON_VALUES.SPRITE_DEFAULT_SCALE,

        zIndex = COMMON_VALUES.Z_UI_ICON_OVERLAY,
    },

    templateSaveHighestTier = {
        type = "text",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.saveFiles.slotOffset + UILayoutData.saveFiles.highestTierLabelOffset,

        color = COMMON_VALUES.COLOR_WHITE,
        font = love.graphics.newFont(COMMON_VALUES.DEFAULT_FONT_PATH, COMMON_VALUES.FONT_SMALL),

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    templateSavePlaytime = {
        text = "0:00:00",

        type = "text",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.mainMenu.startButton.y - UILayoutData.saveFiles.slotOffset + UILayoutData.saveFiles.playtimeLabelOffset,

        color = COMMON_VALUES.COLOR_WHITE,
        font = love.graphics.newFont(COMMON_VALUES.DEFAULT_FONT_PATH, COMMON_VALUES.FONT_MEDIUM),

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },
}