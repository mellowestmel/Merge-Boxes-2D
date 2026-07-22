-- ~/code/data/ui/scenes/game.lua

local RenderModule = require("code.engine.render")

local CONSTANTS = require("code.game.ui.constants")
local UI_LAYOUT = require("code.data.ui.layout")

return {
    spawnButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = UI_LAYOUT.GAME.SPAWN_BUTTON.X,
        y = UI_LAYOUT.GAME.SPAWN_BUTTON.Y,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_YELLOW),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    spawnButtonLabel = {
        text = "Spawn Box!",

        type = "text",

        x = UI_LAYOUT.GAME.SPAWN_BUTTON.X,
        y = UI_LAYOUT.GAME.SPAWN_BUTTON.Y,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_LARGE),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    autoSpawnButtonHitbox = {
        spritePath = CONSTANTS.DEFAULT_BUTTON_PATH,

        type = "sprite",

        x = UI_LAYOUT.GAME.SPAWN_BUTTON.X,
        y = UI_LAYOUT.GAME.SPAWN_BUTTON.Y - UI_LAYOUT.GAME.SPAWN_BUTTON_ROW_OFFSET,

        scaleY = UI_LAYOUT.GAME.AUTO_SPAWN_BUTTON_HEIGHT_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_BUTTON,
    },

    autoSpawnButtonLabel = {
        text = "Auto Spawn (OFF)",

        type = "text",

        x = UI_LAYOUT.GAME.SPAWN_BUTTON.X,
        y = UI_LAYOUT.GAME.SPAWN_BUTTON.Y - UI_LAYOUT.GAME.SPAWN_BUTTON_ROW_OFFSET,

        scaleX = UI_LAYOUT.GAME.AUTO_SPAWN_LABEL_SCALE,
        scaleY = UI_LAYOUT.GAME.AUTO_SPAWN_LABEL_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_WHITE),
        font = love.graphics.newFont(CONSTANTS.STANBERRY_FONT_PATH, CONSTANTS.FONT_LARGE),

        zIndex = CONSTANTS.Z_UI_TEXT,
    },

    playAreaBackground = {
        spritePath = "assets/sprites/backgrounds/areabg.png",

        type = "sprite",

        anchorX = 0,
        anchorY = 0,

        zIndex = CONSTANTS.Z_BACKGROUND,
    },

    upgradeShopButtonHitbox = {
        spritePath = "assets/sprites/ui/buttoncart74x74.png",

        type = "sprite",

        x = UI_LAYOUT.GAME.SPAWN_BUTTON.X - CONSTANTS.BUTTON_HORIZONTAL_GAP,
        y = UI_LAYOUT.GAME.SPAWN_BUTTON.Y + CONSTANTS.BUTTON_HORIZONTAL_GAP,

        scaleX = CONSTANTS.ICON_MEDIUM_SCALE,
        scaleY = CONSTANTS.ICON_MEDIUM_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_BLUE),

        zIndex = CONSTANTS.Z_UI_ICON_OVERLAY,
    },

    blackMarketButtonHitbox = {
        spritePath = "assets/sprites/ui/buttonbm74x74.png",

        type = "sprite",

        x = UI_LAYOUT.GAME.SPAWN_BUTTON.X,
        y = UI_LAYOUT.GAME.SPAWN_BUTTON.Y + CONSTANTS.BUTTON_HORIZONTAL_GAP,

        scaleX = CONSTANTS.ICON_MEDIUM_SCALE,
        scaleY = CONSTANTS.ICON_MEDIUM_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_GOLD),

        zIndex = CONSTANTS.Z_UI_ICON_OVERLAY,
    },

    sacrificeButtonHitbox = {
        spritePath = "assets/sprites/ui/buttonsac74x74.png",

        type = "sprite",

        x = UI_LAYOUT.GAME.SPAWN_BUTTON.X + CONSTANTS.BUTTON_HORIZONTAL_GAP,
        y = UI_LAYOUT.GAME.SPAWN_BUTTON.Y + CONSTANTS.BUTTON_HORIZONTAL_GAP,

        scaleX = CONSTANTS.ICON_MEDIUM_SCALE,
        scaleY = CONSTANTS.ICON_MEDIUM_SCALE,

        color = RenderModule:createColorFromTable(CONSTANTS.COLOR_RED),

        zIndex = CONSTANTS.Z_UI_ICON_OVERLAY,
    },
}