-- Welcome to my magic number zone. In here, our numbers are magical.
-- Only masters of number magic are allowed to edit this file.

-- Basically this file is full of layout variables that deviate from COMMON_VALUES

local CONSTANTS = require("src.data.constants")
local COMMON_VALUES = require("src.data.ui.commonValues")

local layoutData = {}

-- MAIN MENU
layoutData.mainMenu = {
    startButton = {
        y = 375,
    },

    logo = {
        primary = {
            offsetY = 225,
            scale = .5,
        },

        secondary = {
            offsetY = 100,
            scale = .35,
        },
    },
}

-- SHARED UI
layoutData.shared = {
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

        arrowX = CONSTANTS.BOX.AREA.WIDTH - COMMON_VALUES.MASSIVE_PADDING,
        arrowY = RESOLUTION_HEIGHT - COMMON_VALUES.MASSIVE_PADDING
    },

    backgroundBoxesPathPrefix = "assets/sprites/boxes/background/",

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
}

-- SETTINGS
local iconHalfWidth = 74 * COMMON_VALUES.ICON_SMALL_SCALE / 2
local padding = COMMON_VALUES.MEDIUM_PADDING

layoutData.settings = {
    categoryRowY = 550,
    categoryScrollOffsetX = 125,

    settingNameLabelOffsetX = -225,
    settingToggleOffsetX = 200,

    settingDecreaseOffsetX = 100,
    settingIncreaseOffsetX = 300,

    settingValueLabelOffsetX = 200,

    textBounds = {
        categoryLabelMaxWidth =
            (125 - iconHalfWidth - padding) * 2,

        settingNameMaxWidth =
            100 - (-225) - iconHalfWidth - padding,

        settingValueMaxWidth =
            300 - 100 - iconHalfWidth * 2 - padding * 2,
    },
}

-- BOX RANCH
layoutData.boxRanch = {
    spawnButton = {
        x = CONSTANTS.BOX.AREA.WIDTH + (RESOLUTION_WIDTH - CONSTANTS.BOX.AREA.WIDTH) / 2,
        y = 475,

        rowOffset = 65,
    },

    autoSpawnButton = {
        heightScale = .6,
        labelScale = .75,
    }
}

-- SAVE FILES
layoutData.saveFiles = {
    slotOffset = 325,
    yDivider = 1.6,

    loadButtonOffset = 60,
    resetButtonOffset = 10,

    template = {
        rotation = 90,

        smallScale = .55,
        scaleX = 1.5,
    },

    highestTierLabelOffset = 40,
    playtimeLabelOffset = 65,
}

-- UPGRADE SHOP
layoutData.upgradeShop = {
    birdSecret = {
        x = 230,
        y = 125,
    },

    backgroundFrame = {
        scaleX = .9,
        scaleY = .7,
        offsetY = -200,
    },

    upgradeDescription = {
        padding = COMMON_VALUES.MEDIUM_PADDING,
    },

    upgradeButton = {
        scaleX = .9,

        textPadding = COMMON_VALUES.MEDIUM_PADDING,
        textOffsetRatio = .3,
    },

    stackIndicatorSpacing = COMMON_VALUES.MEDIUM_PADDING,
}

return layoutData