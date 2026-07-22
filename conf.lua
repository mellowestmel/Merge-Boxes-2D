-- ~/conf.lua

math.randomseed(os.time())
math.random()

_G.SAWE_FILE_ENCRYPTION_KEY = "Next Update: Femboys"

_G.RESOLUTION_WIDTH = 800
_G.RESOLUTION_HEIGHT = 600

_G.MIN_WINDOW_WIDTH = 400
_G.MIN_WINDOW_HEIGHT = 300

_G.FPS_SCALE = 240

function love.conf(config)
    config.identity = "MERGE-BOXES-2D"

    config.window.width = _G.RESOLUTION_WIDTH
    config.window.height = _G.RESOLUTION_HEIGHT

    config.window.minwidth = _G.MIN_WINDOW_WIDTH
    config.window.minheight = _G.MIN_WINDOW_HEIGHT

    config.window.icon = "assets/sprites/boxes/box1.png"
    config.window.title = "Merge Boxes! 2D"

    config.window.fullscreentype = "desktop"

    config.window.resizable = true
    config.console = false
end