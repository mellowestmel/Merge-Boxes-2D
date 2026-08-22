-- ~/code/data/ui/layout.lua

local BOX_CONSTANTS = require("code.game.boxes.constants")
local CONSTANTS = require("code.game.ui.constants")

return {
    mainMenu = {
        startButton = {
            y = 375,
        },

        logoPrimaryOffsetY = 225,
        logoSecondaryOffsetY = 100,

        logoPrimaryScale = .5,
        logoSecondaryScale = .35,
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

            textPaddingX = 20,
            textPaddingY = 45,

            arrowX = BOX_CONSTANTS.AREA_WIDTH - CONSTANTS.MASSIVE_PADDING,
            arrowY = RESOLUTION_HEIGHT - CONSTANTS.MASSIVE_PADDING
        },

        backgroundBoxesPathPrefix = "assets/sprites/ui/background_boxes/",
        backgroundBoxes = {
            ["gerald"] = { x = 405, y = 445, zIndex = 8 },
            ["jimbo"] = { x = 341, y = 463, zIndex = 2 },
            ["glumbo"] = { x = 265, y = 465, zIndex = 3 },
            ["jeremy"] = { x = 180, y = 466, zIndex = 4 },
            ["muncher"] = { x = 74, y = 480, zIndex = 5 },
            ["dylan"] = { x = 296, y = 368, zIndex = 6 },
            ["carlos"] = { x = 487, y = 400, zIndex = 7 },
            ["goobsterGoobingtonIII"] = { x = 544, y = 439, zIndex = 8 },
            ["mark"] = { x = 643, y = 365, zIndex = 7 },
            ["frigidWendyhot"] = { x = 768, y = 376, zIndex = 8 },
            ["dizzy"] = { x = 388, y = 366, zIndex = 4 },
            ["gochged"] = { x = 551, y = 345, zIndex = 1 },
            ["mtBox"] = { x = 710, y = 279, zIndex = 1 },
            ["unstable"] = { x = 96, y = 335, zIndex = 2 },
            ["transcended"] = { x = 196, y = 326, zIndex = 3 },

            ["omnibox"] = {
                x = 331,
                y = 318,

                zIndex = 1,

                shaders = {
                    {
                        name = "box16"
                    }
                }
            },

            ["devoided"] = { x = 660, y = 95, zIndex = 1 },
            ["boxOMatter"] = { x = 0, y = 0, zIndex = 1 },
            ["greatOldGrumpyOne"] = { x = 0, y = 0, zIndex = 1 },
            ["luckrollBox"] = { x = 0, y = 0, zIndex = 1 },
            ["mellowBox"] = { x = 0, y = 0, zIndex = 1 },
            ["theCollector"] = { x = 0, y = 0, zIndex = 1 },
            ["glitcherson"] = { x = 0, y = 0, zIndex = 1 },
            ["b24"] = { x = 0, y = 0, zIndex = 1 },
            ["b25"] = { x = 0, y = 0, zIndex = 1 },
        }
    },

    settings = {
        categoryRowY = 550,
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

        autoSpawnButtonHeightScale = .6,
        autoSpawnLabelScale = .75,
    },

    saveFiles = {
        slotOffset = 325,
        yDivider = 1.6,
        loadButtonOffset = 60,
        resetButtonOffset = 10,
        templateRotation = 90,
        templateScaleX = 1.5,
        templateSmallScale = .55,

        highestTierLabelOffset = 40,
        playtimeLabelOffset = 65,
    },

    upgradeShop = {
        birb = {
            x = 230,
            y = 125,
        },

        backgroundFrame = {
            scaleX = .9,
            scaleY = .6,
            offsetY = -225,
        },

        scrollWheel = {
            scaleX = .1,
        },

        textOffsetRatio = .3
    },
}