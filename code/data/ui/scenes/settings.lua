-- ~/code/data/ui/scenes/settings.lua

local COMMON_VALUES = require("code.data.ui.commonValues")
local UILayoutData = require("code.data.ui.layout")

return {
    background = {
        spritePath = "assets/sprites/backgrounds/settingsmenubg.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = COMMON_VALUES.Z_BACKGROUND,
    },

    cancelButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttonx74x74.png",

        type = "sprite",

        x = UILayoutData.shared.settingsButton.x,
        y = UILayoutData.shared.settingsButton.y,

        scaleX = COMMON_VALUES.ICON_SMALL_SCALE,
        scaleY = COMMON_VALUES.ICON_SMALL_SCALE,

        color = COMMON_VALUES.COLOR_RED,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    currentCategoryLabel = {
        type = "text",

        x = COMMON_VALUES.CENTER_X,
        y = UILayoutData.settings.categoryRowY,

        color = COMMON_VALUES.COLOR_WHITE,

        font = love.graphics.newFont(
            COMMON_VALUES.DEFAULT_FONT_PATH,
            COMMON_VALUES.FONT_LARGE
        ),

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    settingNameLabel = {
        type = "text",

        x = COMMON_VALUES.CENTER_X + UILayoutData.settings.settingNameLabelOffsetX,
        y = UILayoutData.shared.settingsButton.y,

        color = COMMON_VALUES.COLOR_WHITE,

        anchorX = 0,

        font = love.graphics.newFont(
            COMMON_VALUES.DEFAULT_FONT_PATH,
            COMMON_VALUES.FONT_LARGE
        ),

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    booleanSettingToggleHitbox = {
        spritePath = "assets/sprites/ui/buttons/button74x74.png",

        type = "sprite",

        x = COMMON_VALUES.CENTER_X + UILayoutData.settings.settingToggleOffsetX,

        scaleX = COMMON_VALUES.ICON_SMALL_SCALE,
        scaleY = COMMON_VALUES.ICON_SMALL_SCALE,

        color = COMMON_VALUES.COLOR_GRAY,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    decreaseSettingHitbox = {
        spritePath = "assets/sprites/ui/buttons/button74x74.png",

        type = "sprite",

        x = COMMON_VALUES.CENTER_X + UILayoutData.settings.settingDecreaseOffsetX,

        scaleX = COMMON_VALUES.ICON_SMALL_SCALE,
        scaleY = COMMON_VALUES.ICON_SMALL_SCALE,

        color = COMMON_VALUES.COLOR_RED,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    increaseSettingHitbox = {
        spritePath = "assets/sprites/ui/buttons/button74x74.png",

        type = "sprite",

        x = COMMON_VALUES.CENTER_X + UILayoutData.settings.settingIncreaseOffsetX,

        scaleX = COMMON_VALUES.ICON_SMALL_SCALE,
        scaleY = COMMON_VALUES.ICON_SMALL_SCALE,

        color = COMMON_VALUES.COLOR_GREEN,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    settingValueLabel = {
        type = "text",

        x = COMMON_VALUES.CENTER_X + UILayoutData.settings.settingValueLabelOffsetX,

        font = love.graphics.newFont(
            COMMON_VALUES.DEFAULT_FONT_PATH,
            COMMON_VALUES.FONT_MEDIUM
        ),

        zIndex = COMMON_VALUES.Z_UI_TEXT,
    },

    scrollLeftButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttonarrowl74x74.png",

        type = "sprite",

        x = COMMON_VALUES.CENTER_X - UILayoutData.settings.categoryScrollOffsetX,
        y = UILayoutData.settings.categoryRowY,

        scaleX = COMMON_VALUES.ICON_SMALL_SCALE,
        scaleY = COMMON_VALUES.ICON_SMALL_SCALE,

        color = COMMON_VALUES.COLOR_RED,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    },

    scrollRightButtonHitbox = {
        spritePath = "assets/sprites/ui/buttons/buttonarrowr74x74.png",

        type = "sprite",

        x = COMMON_VALUES.CENTER_X + UILayoutData.settings.categoryScrollOffsetX,
        y = UILayoutData.settings.categoryRowY,

        scaleX = COMMON_VALUES.ICON_SMALL_SCALE,
        scaleY = COMMON_VALUES.ICON_SMALL_SCALE,

        color = COMMON_VALUES.COLOR_GREEN,

        zIndex = COMMON_VALUES.Z_UI_BUTTON,
    }
}