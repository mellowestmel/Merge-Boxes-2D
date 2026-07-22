-- ~/code/data/ui/scenes/settings.lua

--/// ENGINE \\\--
local RenderModule = require("code.engine.render")

--// UI \\--
local CONSTANTS = require("code.game.ui.constants")
local UI_LAYOUT = require("code.data.ui.layout")

return {
    background = {
        spritePath = "assets/sprites/backgrounds/menubg.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = CONSTANTS.Z_BACKGROUND,
    },

    cancelButtonHitbox = {
        spritePath = "assets/sprites/ui/buttonx74x74.png",

        type = "sprite",

        x = UI_LAYOUT.SETTINGS.SETTINGS_BUTTON_X,
        y = UI_LAYOUT.SETTINGS.SETTINGS_BUTTON_Y,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    currentCategoryLabel = {
        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.SETTINGS.CATEGORY_ROW_Y,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),

        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_LARGE
        ),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    settingNameLabel = {
        type = "text",

        x = CONSTANTS.CENTER_X + UI_LAYOUT.SETTINGS.SETTING_NAME_LABEL_OFFSET_X,
        y = UI_LAYOUT.SETTINGS.SETTINGS_BUTTON_Y,

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

        x = CONSTANTS.CENTER_X + UI_LAYOUT.SETTINGS.SETTING_TOGGLE_OFFSET_X,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GRAY),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    decreaseSettingHitbox = {
        spritePath = "assets/sprites/ui/button74x74.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X + UI_LAYOUT.SETTINGS.SETTING_DECREASE_OFFSET_X,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    increaseSettingHitbox = {
        spritePath = "assets/sprites/ui/button74x74.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X + UI_LAYOUT.SETTINGS.SETTING_INCREASE_OFFSET_X,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GREEN),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    settingValueLabel = {
        type = "text",

        x = CONSTANTS.CENTER_X + UI_LAYOUT.SETTINGS.SETTING_VALUE_LABEL_OFFSET_X,

        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_MEDIUM
        ),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    scrollLeftButtonHitbox = {
        spritePath = "assets/sprites/ui/buttonarrowl74x74.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X - UI_LAYOUT.SETTINGS.CATEGORY_SCROLL_OFFSET_X,
        y = UI_LAYOUT.SETTINGS.CATEGORY_ROW_Y,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    scrollRightButtonHitbox = {
        spritePath = "assets/sprites/ui/buttonarrowr74x74.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X + UI_LAYOUT.SETTINGS.CATEGORY_SCROLL_OFFSET_X,
        y = UI_LAYOUT.SETTINGS.CATEGORY_ROW_Y,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GREEN),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    }
}