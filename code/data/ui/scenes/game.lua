-- ~/code/data/ui/scenes/game.lua

--/// ENGINE \\\--
local RenderModule = require("code.engine.render")

--// UI \\--
local CONSTANTS = require("code.game.ui.constants")
local UI_LAYOUT = require("code.data.ui.layout")

return {
    spawnButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = UI_LAYOUT.SPAWN_BUTTON_X,
        y = UI_LAYOUT.SPAWN_BUTTON_Y,

        color = RenderModule:createColor(255, 200, 0),

        zIndex = 1001,
    },

    spawnButtonLabel = {
        text = "Spawn Box!",

        type = "text",

        x = CONSTANTS.SPAWN_BUTTON_X,
        y = CONSTANTS.SPAWN_BUTTON_Y,

        color = RenderModule:createColor(255, 255, 255),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_BUTTON),

        zIndex = 1002,
    },

    playAreaBackground = {
        spritePath = "assets/sprites/backgrounds/areabg.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = 1,
    },

    upgradeShopButtonHitbox = {
        spritePath = "assets/sprites/ui/buttoncart74x74.png",

        type = "sprite",

        x = UI_LAYOUT.SPAWN_BUTTON_X - CONSTANTS.BUTTON_SPACING,
        y = UI_LAYOUT.SPAWN_BUTTON_Y + CONSTANTS.BUTTON_SPACING,

        scaleX = CONSTANTS.BUTTON_ICON_SCALE,
        scaleY = CONSTANTS.BUTTON_ICON_SCALE,

        color = RenderModule:createColor(110, 153, 202),

        zIndex = 1004,
    },

    blackMarketButtonHitbox = {
        spritePath = "assets/sprites/ui/buttonbm74x74.png",

        type = "sprite",

        x = UI_LAYOUT.SPAWN_BUTTON_X,
        y = UI_LAYOUT.SPAWN_BUTTON_Y + CONSTANTS.BUTTON_ROW_OFFSET,

        scaleX = CONSTANTS.BUTTON_ICON_SCALE,
        scaleY = CONSTANTS.BUTTON_ICON_SCALE,

        color = RenderModule:createColor(248, 217, 109),

        zIndex = 1004,
    },

    sacrificeButtonHitbox = {
        spritePath = "assets/sprites/ui/buttonsac74x74.png",

        type = "sprite",

        x = UI_LAYOUT.SPAWN_BUTTON_X + CONSTANTS.BUTTON_ROW_OFFSET,
        y = UI_LAYOUT.SPAWN_BUTTON_Y + CONSTANTS.BUTTON_ROW_OFFSET,

        scaleX = CONSTANTS.BUTTON_ICON_SCALE,
        scaleY = CONSTANTS.BUTTON_ICON_SCALE,

        color = RenderModule:createColor(204, 49, 61),

        zIndex = 1004,
    },
}