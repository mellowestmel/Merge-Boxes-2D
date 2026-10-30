local COMMON_VALUES = require("src.data.ui.commonValues")
local UILayoutData = require("src.data.ui.layout")

return {
    spawnButtonHitbox = {
        spritePath = COMMON_VALUES.DEFAULT_BUTTON_PATH,
        type = "sprite",

        x = UILayoutData.boxRanch.spawnButton.x,
        y = UILayoutData.boxRanch.spawnButton.y,

        color = COMMON_VALUES.COLOR_YELLOW,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    spawnButtonLabel = {
        textKey = "boxRanch.spawnBox",
        type = "text",

        x = UILayoutData.boxRanch.spawnButton.x,
        y = UILayoutData.boxRanch.spawnButton.y,

        color = COMMON_VALUES.COLOR_WHITE,
        font = love.graphics.newFont(
            COMMON_VALUES.DEFAULT_FONT_PATH,
            COMMON_VALUES.FONT_LARGE
        ),

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    autoSpawnButtonHitbox = {
        spritePath = COMMON_VALUES.DEFAULT_BUTTON_PATH,
        type = "sprite",

        x = UILayoutData.boxRanch.spawnButton.x,
        y = UILayoutData.boxRanch.spawnButton.y - UILayoutData.boxRanch.spawnButton.rowOffset,

        scaleY = UILayoutData.boxRanch.autoSpawnButton.heightScale,

        color = COMMON_VALUES.COLOR_RED,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    autoSpawnButtonLabel = {
        textKey = "boxRanch.autoSpawn",
        type = "text",

        x = UILayoutData.boxRanch.spawnButton.x,
        y = UILayoutData.boxRanch.spawnButton.y - UILayoutData.boxRanch.spawnButton.rowOffset,

        scaleX = UILayoutData.boxRanch.autoSpawnButton.labelScale,
        scaleY = UILayoutData.boxRanch.autoSpawnButton.labelScale,

        color = COMMON_VALUES.COLOR_WHITE,
        font = love.graphics.newFont(
            COMMON_VALUES.DEFAULT_FONT_PATH,
            COMMON_VALUES.FONT_LARGE
        ),

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    playAreaBackground = {
        spritePath = "assets/sprites/ui/backgrounds/areabg.png",
        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = COMMON_VALUES.Z_BACKGROUND,
    },

    upgradeShopButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttoncart74x74.png",
        type = "sprite",

        x = UILayoutData.boxRanch.spawnButton.x - COMMON_VALUES.BUTTON_HORIZONTAL_GAP,
        y = UILayoutData.boxRanch.spawnButton.y + COMMON_VALUES.BUTTON_HORIZONTAL_GAP,

        scaleX = COMMON_VALUES.ICON_MEDIUM_SCALE,
        scaleY = COMMON_VALUES.ICON_MEDIUM_SCALE,

        color = COMMON_VALUES.COLOR_BLUE,

        zIndex = COMMON_VALUES.Z_UI_ICON_OVERLAY,
    },

    blackMarketButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttonbm74x74.png",
        type = "sprite",

        x = UILayoutData.boxRanch.spawnButton.x,
        y = UILayoutData.boxRanch.spawnButton.y + COMMON_VALUES.BUTTON_HORIZONTAL_GAP,

        scaleX = COMMON_VALUES.ICON_MEDIUM_SCALE,
        scaleY = COMMON_VALUES.ICON_MEDIUM_SCALE,

        color = COMMON_VALUES.COLOR_GOLD,

        zIndex = COMMON_VALUES.Z_UI_ICON_OVERLAY,
    },

    sacrificeButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttonsac74x74.png",
        type = "sprite",

        x = UILayoutData.boxRanch.spawnButton.x + COMMON_VALUES.BUTTON_HORIZONTAL_GAP,
        y = UILayoutData.boxRanch.spawnButton.y + COMMON_VALUES.BUTTON_HORIZONTAL_GAP,

        scaleX = COMMON_VALUES.ICON_MEDIUM_SCALE,
        scaleY = COMMON_VALUES.ICON_MEDIUM_SCALE,

        color = COMMON_VALUES.COLOR_RED,

        zIndex = COMMON_VALUES.Z_UI_ICON_OVERLAY,
    },
}