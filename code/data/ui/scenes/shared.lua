-- ~/code/data/ui/scenes/shared.lua

local CONSTANTS = require("code.data.constants")
local COMMON_VALUES = require("code.data.ui.commonValues")

local UILayoutData = require("code.data.ui.layout")

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
        spritePath = "assets/sprites/ui/sidebar.png",

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

        x = UILayoutData.game.spawnButton.x,
        y = UILayoutData.game.spawnButton.y + UILayoutData.game.spawnButtonRowOffset,

        color = COMMON_VALUES.COLOR_RED,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    shopBackButtonLabel = {
        text = "Back",

        type = "text",

        x = UILayoutData.game.spawnButton.x,
        y = UILayoutData.game.spawnButton.y + UILayoutData.game.spawnButtonRowOffset,

        color = COMMON_VALUES.COLOR_WHITE,
        font = love.graphics.newFont(
            COMMON_VALUES.STANBERRY_FONT_PATH,
            COMMON_VALUES.FONT_LARGE
        ),

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    creditsLabel = {
        text = "Credits:",

        type = "text",

        font = love.graphics.newFont(
            COMMON_VALUES.STANBERRY_FONT_PATH,
            COMMON_VALUES.FONT_SMALL
        ),

        anchorX = 0,
        anchorY = 0,

        x = COMMON_VALUES.SMALL_PADDING,
        y = COMMON_VALUES.LARGE_PADDING,

        color = COMMON_VALUES.COLOR_YELLOW,

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    sessionPlaytimeLabel = {
        text = "Session Time: ",

        type = "text",

        font = love.graphics.newFont(
            COMMON_VALUES.STANBERRY_FONT_PATH,
            COMMON_VALUES.FONT_SMALL
        ),

        anchorX = 0,
        anchorY = 0,

        x = COMMON_VALUES.SMALL_PADDING,
        y = COMMON_VALUES.SMALL_PADDING,

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    backToMenuButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttonmenu74x74.png",

        type = "sprite",

        x = UILayoutData.shared.settingsButton.x - COMMON_VALUES.MASSIVE_PADDING,
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

        x = 0,
        y = RESOLUTION_HEIGHT,

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

        x = 0,
        y = RESOLUTION_HEIGHT,

        zIndex = COMMON_VALUES.Z_UI_BACKGROUND,
    },
}