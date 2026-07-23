-- ~/code/data/ui/scenes/settings.lua

local RenderModule = require("code.engine.render")

local CONSTANTS = require("code.game.ui.constants")
local UILayoutData = require("code.data.ui.layout")

return {
    background = {
        spritePath = "assets/sprites/backgrounds/settingsmenubg.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = CONSTANTS.Z_BACKGROUND,
    },

    cancelButtonHitbox = {
        spritePath = "assets/sprites/ui/buttonx74x74.png",

        type = "sprite",

        x = UILayoutData.shared.settingsButton.x,
        y = UILayoutData.shared.settingsButton.y,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    currentCategoryLabel = {
        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UILayoutData.settings.categoryRowY,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),

        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_LARGE
        ),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    settingNameLabel = {
        type = "text",

        x = CONSTANTS.CENTER_X + UILayoutData.settings.settingNameLabelOffsetX,
        y = UILayoutData.shared.settingsButton.y,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),

        anchorX = 0,

        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_LARGE
        ),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    booleanSettingToggleHitbox = {
        spritePath = "assets/sprites/ui/button74x74.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X + UILayoutData.settings.settingToggleOffsetX,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GRAY),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    decreaseSettingHitbox = {
        spritePath = "assets/sprites/ui/button74x74.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X + UILayoutData.settings.settingDecreaseOffsetX,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    increaseSettingHitbox = {
        spritePath = "assets/sprites/ui/button74x74.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X + UILayoutData.settings.settingIncreaseOffsetX,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GREEN),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    settingValueLabel = {
        type = "text",

        x = CONSTANTS.CENTER_X + UILayoutData.settings.settingValueLabelOffsetX,

        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_MEDIUM
        ),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    scrollLeftButtonHitbox = {
        spritePath = "assets/sprites/ui/buttonarrowl74x74.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X - UILayoutData.settings.categoryScrollOffsetX,
        y = UILayoutData.settings.categoryRowY,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    scrollRightButtonHitbox = {
        spritePath = "assets/sprites/ui/buttonarrowr74x74.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X + UILayoutData.settings.categoryScrollOffsetX,
        y = UILayoutData.settings.categoryRowY,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GREEN),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    }
}