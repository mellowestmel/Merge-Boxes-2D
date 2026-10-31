CONSTANTS = require("src.data.constants")

string = require("src.engine.helpers.string")
table = require("src.engine.helpers.table")
math = require("src.engine.helpers.math")

function love.conf(config)
    config.version = "11.5" -- LOVE2D version
    config.identity = "MERGE-BOXES-2D"

    config.window.width = CONSTANTS.DISPLAY.RESOLUTION_WIDTH
    config.window.height = CONSTANTS.DISPLAY.RESOLUTION_HEIGHT

    config.window.minwidth = CONSTANTS.DISPLAY.MIN_WINDOW_WIDTH
    config.window.minheight = CONSTANTS.DISPLAY.MIN_WINDOW_HEIGHT

    config.window.icon = "assets/sprites/boxes/game/box1.png"
    config.window.title = "Merge Boxes! 2D"

    config.window.fullscreentype = "desktop"
    config.window.resizable = true
end