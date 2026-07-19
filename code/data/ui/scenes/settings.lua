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

    backButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y + CONSTANTS.BUTTON_VERTICAL_GAP,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    backButtonLabel = {
        text = "Back",

        type = "text",

        x = CONSTANTS.CENTER_X,
        y = UI_LAYOUT.MAIN_MENU.BUTTON_Y + CONSTANTS.BUTTON_VERTICAL_GAP,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_BUTTON),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },
}