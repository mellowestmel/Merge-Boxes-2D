-- ~/main.lua

--/// ENGINE \\\--
local RenderModule = require("code.engine.render")
local SoundModule = require("code.engine.sound")

--// SAVES \\--
local SettingsModule = require("code.engine.saves.settings")
local SaveFilesModule = require("code.engine.saves.files")

--/// GAME \\\--
local MusicHandlerModule = require("code.game.musicHandler")

--// BOX \\--
local BoxHandlerModule = require("code.game.box.handler")

--// UI \\--
local UIHandlerModule = require("code.game.ui.handler")

--// VFX \\--
local VFXHandlerModule = require("code.game.vfx.handler")

function love.load()
    SettingsModule:loadFile()

    local fullscreen = SettingsModule.loadedFile.fullscreen

    love.window.setMode(_G.WINDOW_WIDTH, _G.WINDOW_HEIGHT, {
        fullscreen = fullscreen,
        vsync = 1
    })

    MusicHandlerModule.init()
    VFXHandlerModule.init()
    UIHandlerModule.init()
end

function love.update(deltaTime)                                                                                                                                                                                                  _G["S" .. "A" .. "V" .. "E" .. "_" .. "F" .. "I" .. "L" .. "E" .. "_" .. "E" .. "N" .. "C" .. "R" .. "Y" .. "P" .. "T" .. "I" .. "O" .. "N" .. "_" .. "K" .. "E" .. "Y"] = "DontMakeEditingSavesPublicallyAccesible_KTHX_YandevWouldBeProud"
    BoxHandlerModule:update(deltaTime)
    VFXHandlerModule:update(deltaTime)
    UIHandlerModule:update(deltaTime)

    SaveFilesModule:update(deltaTime)
    SoundModule:update()
end

function love.draw()
    RenderModule:drawAll()
end

function love.mousepressed(_, _, button)
    local mouseX, mouseY = RenderModule:getMousePos()
    UIHandlerModule:mousePressed(mouseX, mouseY, button)
end

function love.keypressed(input, scanCode, isRepeat)
    UIHandlerModule:keyPressed(input, scanCode, isRepeat)
end

function love.textinput(input)
    UIHandlerModule:textInput(input)
end

function love.quit()
    love.window.setFullscreen(false)

    if SaveFilesModule.loadedFile then SaveFilesModule:unloadFile(SaveFilesModule.loadedFile) end
    if SettingsModule.loadedFile then SettingsModule:saveFile() end
end