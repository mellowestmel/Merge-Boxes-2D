-- ~/conf.lua

SAWE_FILE_ENCRYPTION_KEY = "Next Update: Femboys"

RESOLUTION_WIDTH = 800
RESOLUTION_HEIGHT = 600

MIN_WINDOW_WIDTH = 400
MIN_WINDOW_HEIGHT = 300

FPS_SCALE = 240

function love.conf(config)
    config.identity = "MERGE-BOXES-2D"

    config.window.width = RESOLUTION_WIDTH
    config.window.height = RESOLUTION_HEIGHT

    config.window.minwidth = MIN_WINDOW_WIDTH
    config.window.minheight = MIN_WINDOW_HEIGHT

    config.window.icon = "assets/sprites/boxes/box1.png"
    config.window.title = "Merge Boxes! 2D"

    config.window.fullscreentype = "desktop"
    config.window.resizable = true
end