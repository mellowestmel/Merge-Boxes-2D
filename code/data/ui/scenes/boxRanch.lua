-- ~/code/data/ui/scenes/boxRanch.lua

local COMMON_VALUES = require("code.data.ui.commonValues")
local UILayoutData = require("code.data.ui.layout")

return {
    spawnButtonHitbox = {
        spritePath = COMMON_VALUES.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = UILayoutData.game.spawnButton.x,
        y = UILayoutData.game.spawnButton.y,

        color = COMMON_VALUES.COLOR_YELLOW,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    spawnButtonLabel = {
        text = "Spawn Box!",

        type = "text",

        x = UILayoutData.game.spawnButton.x,
        y = UILayoutData.game.spawnButton.y,

        color = COMMON_VALUES.COLOR_WHITE,
        font = love.graphics.newFont(COMMON_VALUES.STANBERRY_FONT_PATH, COMMON_VALUES.FONT_LARGE),

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    autoSpawnButtonHitbox = {
        spritePath = COMMON_VALUES.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = UILayoutData.game.spawnButton.x,
        y = UILayoutData.game.spawnButton.y - UILayoutData.game.spawnButtonRowOffset,

        scaleY = UILayoutData.game.autoSpawnButtonHeightScale,

        color = COMMON_VALUES.COLOR_RED,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    autoSpawnButtonLabel = {
        text = "Auto Spawn (OFF)",

        type = "text",

        x = UILayoutData.game.spawnButton.x,
        y = UILayoutData.game.spawnButton.y - UILayoutData.game.spawnButtonRowOffset,

        scaleX = UILayoutData.game.autoSpawnLabelScale,
        scaleY = UILayoutData.game.autoSpawnLabelScale,

        color = COMMON_VALUES.COLOR_WHITE,
        font = love.graphics.newFont(COMMON_VALUES.STANBERRY_FONT_PATH, COMMON_VALUES.FONT_LARGE),

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    playAreaBackground = {
        spritePath = "assets/sprites/backgrounds/areabg.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = COMMON_VALUES.Z_BACKGROUND,
    },

    upgradeShopButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttoncart74x74.png",

        type = "sprite",

        x = UILayoutData.game.spawnButton.x - COMMON_VALUES.BUTTON_HORIZONTAL_GAP,
        y = UILayoutData.game.spawnButton.y + COMMON_VALUES.BUTTON_HORIZONTAL_GAP,

        scaleX = COMMON_VALUES.ICON_MEDIUM_SCALE,
        scaleY = COMMON_VALUES.ICON_MEDIUM_SCALE,

        color = COMMON_VALUES.COLOR_BLUE,

        zIndex = COMMON_VALUES.Z_UI_ICON_OVERLAY,
    },

    blackMarketButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttonbm74x74.png",

        type = "sprite",

        x = UILayoutData.game.spawnButton.x,
        y = UILayoutData.game.spawnButton.y + COMMON_VALUES.BUTTON_HORIZONTAL_GAP,

        scaleX = COMMON_VALUES.ICON_MEDIUM_SCALE,
        scaleY = COMMON_VALUES.ICON_MEDIUM_SCALE,

        color = COMMON_VALUES.COLOR_GOLD,

        zIndex = COMMON_VALUES.Z_UI_ICON_OVERLAY,
    },

    sacrificeButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttonsac74x74.png",

        type = "sprite",

        x = UILayoutData.game.spawnButton.x + COMMON_VALUES.BUTTON_HORIZONTAL_GAP,
        y = UILayoutData.game.spawnButton.y + COMMON_VALUES.BUTTON_HORIZONTAL_GAP,

        scaleX = COMMON_VALUES.ICON_MEDIUM_SCALE,
        scaleY = COMMON_VALUES.ICON_MEDIUM_SCALE,

        color = COMMON_VALUES.COLOR_RED,

        zIndex = COMMON_VALUES.Z_UI_ICON_OVERLAY,
    },
}