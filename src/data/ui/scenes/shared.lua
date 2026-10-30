local CONSTANTS = require("src.data.constants")
local COMMON_VALUES = require("src.data.ui.commonValues")

local UILayoutData = require("src.data.ui.layout")

return {
    settingsButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttoncog74x74.png",

        type = "sprite",

        x = UILayoutData.shared.settingsButton.x,
        y = UILayoutData.shared.settingsButton.y,

        scaleX = COMMON_VALUES.ICON_SMALL_SCALE,
        scaleY = COMMON_VALUES.ICON_SMALL_SCALE,

        color = COMMON_VALUES.COLOR_GRAY,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    discordButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttondiscord74x74.png",

        type = "sprite",

        x = UILayoutData.shared.discordButton.x,
        y = UILayoutData.shared.discordButton.y,

        scaleX = COMMON_VALUES.ICON_SMALL_SCALE,
        scaleY = COMMON_VALUES.ICON_SMALL_SCALE,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    sidebarBackground = {
        spritePath = "assets/sprites/ui/backgrounds/sidebar.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        x = CONSTANTS.BOX.AREA.WIDTH,

        color = COMMON_VALUES.COLOR_DARK,

        zIndex = COMMON_VALUES.Z_UI_BACKGROUND,
    },

    shopBackButtonHitbox = {
        spritePath = COMMON_VALUES.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = UILayoutData.boxRanch.spawnButton.x,
        y = UILayoutData.boxRanch.spawnButton.y + UILayoutData.boxRanch.spawnButton.rowOffset,

        color = COMMON_VALUES.COLOR_RED,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    shopBackButtonLabel = {
        textKey = "common.back",

        type = "text",

        x = UILayoutData.boxRanch.spawnButton.x,
        y = UILayoutData.boxRanch.spawnButton.y + UILayoutData.boxRanch.spawnButton.rowOffset,

        color = COMMON_VALUES.COLOR_WHITE,
        font = love.graphics.newFont(
            COMMON_VALUES.DEFAULT_FONT_PATH,
            COMMON_VALUES.FONT_LARGE
        ),

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    creditsLabel = {
        type = "text",

        font = love.graphics.newFont(
            COMMON_VALUES.DEFAULT_FONT_PATH,
            COMMON_VALUES.FONT_SMALL
        ),

        anchorX = 0,
        anchorY = 0,

        x = COMMON_VALUES.SMALL_PADDING,
        y = COMMON_VALUES.MEDIUM_PADDING + COMMON_VALUES.SMALL_PADDING,

        color = COMMON_VALUES.COLOR_YELLOW,

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    sessionPlaytimeLabel = {
        type = "text",

        font = love.graphics.newFont(
            COMMON_VALUES.DEFAULT_FONT_PATH,
            COMMON_VALUES.FONT_SMALL
        ),

        anchorX = 0,
        anchorY = 0,

        x = COMMON_VALUES.SMALL_PADDING,
        y = -COMMON_VALUES.SMALL_PADDING,

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    backToMenuButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttonmenu74x74.png",

        type = "sprite",

        x = UILayoutData.shared.settingsButton.x - UILayoutData.shared.backButtonOffset,
        y = UILayoutData.shared.settingsButton.y,

        scaleX = COMMON_VALUES.ICON_SMALL_SCALE,
        scaleY = COMMON_VALUES.ICON_SMALL_SCALE,

        color = COMMON_VALUES.COLOR_GRAY,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    mapButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttonmap74x74.png",

        type = "sprite",

        x = UILayoutData.shared.settingsButton.x,
        y = UILayoutData.shared.settingsButton.y - COMMON_VALUES.MASSIVE_PADDING,

        scaleX = COMMON_VALUES.ICON_SMALL_SCALE,
        scaleY = COMMON_VALUES.ICON_SMALL_SCALE,

        color = COMMON_VALUES.COLOR_GREEN,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    almanacButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttonalmanac74x74.png",

        type = "sprite",

        x = UILayoutData.shared.settingsButton.x - COMMON_VALUES.MASSIVE_PADDING,
        y = UILayoutData.shared.settingsButton.y - COMMON_VALUES.MASSIVE_PADDING,

        scaleX = COMMON_VALUES.ICON_SMALL_SCALE,
        scaleY = COMMON_VALUES.ICON_SMALL_SCALE,

        color = COMMON_VALUES.COLOR_GOLD,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    inventoryButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttoninventory74x74.png",

        type = "sprite",

        x = UILayoutData.shared.settingsButton.x - (COMMON_VALUES.MASSIVE_PADDING * 2),
        y = UILayoutData.shared.settingsButton.y - COMMON_VALUES.MASSIVE_PADDING,

        scaleX = COMMON_VALUES.ICON_SMALL_SCALE,
        scaleY = COMMON_VALUES.ICON_SMALL_SCALE,

        color = COMMON_VALUES.COLOR_BLUE,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    dialoguePortrait = {
        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        x = UILayoutData.shared.dialogue.portraitX,
        y = UILayoutData.shared.dialogue.portraitY,

        scaleX = COMMON_VALUES.SPRITE_HUGE_SCALE,
        scaleY = COMMON_VALUES.SPRITE_HUGE_SCALE,

        zIndex = COMMON_VALUES.Z_UI_BACKGROUND,
    },

    dialogueBackground = {
        spritePath = "assets/sprites/ui/buttons/button220x75.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 1,

        x = 0,
        y = RESOLUTION_HEIGHT,

        scaleX = COMMON_VALUES.SPRITE_HUGE_SCALE,
        scaleY = COMMON_VALUES.SPRITE_HUGE_SCALE,

        color = COMMON_VALUES.COLOR_DARK,

        zIndex = COMMON_VALUES.Z_UI_BACKGROUND,
    },

    dialogueNext = {
        spritePath = "assets/sprites/ui/buttons/buttonarrowr74x74.png",

        type = "sprite",

        x = UILayoutData.shared.dialogue.arrowX,
        y = UILayoutData.shared.dialogue.arrowY,

        color = COMMON_VALUES.COLOR_DARK,

        zIndex = COMMON_VALUES.Z_UI_BACKGROUND,
    },

    dialogueText = {
        type = "text",

        anchorX = 0,
        anchorY = 1,

        x = UILayoutData.shared.dialogue.textPaddingX,
        y = RESOLUTION_HEIGHT - UILayoutData.shared.dialogue.textPaddingY,

        zIndex = COMMON_VALUES.Z_UI_BACKGROUND,
    },
}