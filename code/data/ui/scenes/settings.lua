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

        x = UI_LAYOUT.SETTINGS_BUTTON.x,
        y = UI_LAYOUT.SETTINGS_BUTTON.y,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    currentCategoryLabel = {
        type = "text",

        x = CONSTANTS.CENTER_X,
        y = 550,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),

        font = love.graphics.newFont(
            CONSTANTS.STANBERRY_FONT_PATH,
            CONSTANTS.FONT_LARGE
        ),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    scrollRightButtonHitbox = {
        spritePath = "assets/sprites/ui/buttonarrowr74x74.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X + 125,
        y = 550,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GREEN),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    scrollLeftButtonHitbox = {
        spritePath = "assets/sprites/ui/buttonarrowl74x74.png",

        type = "sprite",

        x = CONSTANTS.CENTER_X - 125,
        y = 550,

        scaleX = CONSTANTS.ICON_SMALL_SCALE,
        scaleY = CONSTANTS.ICON_SMALL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GREEN),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },
}