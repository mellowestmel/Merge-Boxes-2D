-- ~/code/data/ui/layout.lua

local BOX_CONSTANTS = require("code.game.boxes.constants")

return {
    mainMenu = {
        startButton = {
            y = 375,
        },

        logoPrimaryOffsetY = 225,
        logoSecondaryOffsetY = 100,

        logoPrimaryScale = 0.5,
        logoSecondaryScale = 0.35,
    },

    shared = {
        settingsButton = {
            x = RESOLUTION_WIDTH - 35,
            y = 35
        },

        discordButton = {
            x = RESOLUTION_WIDTH - 35,
            y = RESOLUTION_HEIGHT - 35
        },

        backButtonOffset = 50,

        dialogue = {
            portraitX = 400,
            portraitY = 425,
        },

        backgroundBoxesPathPrefix = "assets/sprites/ui/background_boxes/",
        backgroundBoxes = {
            { x = 372, y = 416 },
            { x = 307, y = 431 },
            { x = 226, y = 427 },
            { x = 136, y = 427 },
            { x = 28, y = 427 },
            { x = 242, y = 323 },
            { x = 427, y = 339 },
            { x = 482, y = 368 },
            { x = 583, y = 302 },
            { x = 700, y = 308 },
            { x = 324, y = 305 },
            { x = 0, y = 0 },
            { x = 614, y = 137 },
            { x = 99, y = 202 },
            { x = 0, y = 0 },
            { x = 0, y = 0 },
            { x = 0, y = 0 },
            { x = 0, y = 0 },
            { x = 0, y = 0 },
            { x = 0, y = 0 },
            { x = 0, y = 0 },
            { x = 0, y = 0 },
            { x = 0, y = 0 },
            { x = 0, y = 0 },
            { x = 0, y = 0 },
        }
    },

    settings = {
        categoryRowY = 500,
        categoryScrollOffsetX = 125,

        settingNameLabelOffsetX = -225,

        settingToggleOffsetX = 200,

        settingDecreaseOffsetX = 100,
        settingIncreaseOffsetX = 300,

        settingValueLabelOffsetX = 200,
    },

    game = {
        spawnButton = {
            x = BOX_CONSTANTS.AREA_WIDTH + (RESOLUTION_WIDTH - BOX_CONSTANTS.AREA_WIDTH) / 2,
            y = 475,
        },

        spawnButtonRowOffset = 65,

        autoSpawnButtonHeightScale = 0.6,
        autoSpawnLabelScale = 0.75,
    },

    saveFiles = {
        slotOffset = 325,
        yDivider = 1.6,
        loadButtonOffset = 60,
        resetButtonOffset = 10,
        templateRotation = 90,
        templateScaleX = 1.5,
        templateSmallScale = 0.55,

        highestTierLabelOffset = 40,
        playtimeLabelOffset = 65,
    },

    upgradeShop = {
        birb = {
            x = 230,
            y = 125,
        },

        backgroundFrame = {
            scaleX = 0.9,
            scaleY = 0.6,
            offsetY = -225,
        },

        scrollWheel = {
            scaleX = 0.1,
        },

        textOffsetRatio = 0.3
    },
}