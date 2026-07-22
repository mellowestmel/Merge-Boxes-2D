-- ~/main.lua

local RenderModule = require("code.engine.render")
local SoundModule = require("code.engine.sound")

local SettingsModule = require("code.engine.saves.settings")
local SaveFilesModule = require("code.engine.saves.files")

local MusicHandlerModule = require("code.game.musicHandler")

local BoxHandlerModule = require("code.game.box.handler")

local UIHandlerModule = require("code.game.ui.handler")
local VFXHandlerModule = require("code.game.vfx.handler")

function love.load()
    SettingsModule:loadFile()
    RenderModule:init()

    MusicHandlerModule.init()
    VFXHandlerModule.init()
    UIHandlerModule.init()
end

function love.update(deltaTime)                                                                                                                                                                                           _G["S" .. "A" .. "V" .. "E" .. "_" .. "F" .. "I" .. "L" .. "E" .. "_" .. "E" .. "N" .. "C" .. "R" .. "Y" .. "P" .. "T" .. "I" .. "O" .. "N" .. "_" .. "K" .. "E" .. "Y"] = "DontMakeEditingSavesPublicallyAccesible_KTHX_YandevWouldBeProud"
    RenderModule:update()

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

function love.mousereleased(_, _, button)
    local mouseX, mouseY = RenderModule:getMousePos()
    UIHandlerModule:mouseReleased(mouseX, mouseY, button)
end

function love.wheelmoved(x, y)
    UIHandlerModule:wheelMoved(x, y)
end

function love.quit()
    love.window.setFullscreen(false)

    if SaveFilesModule.loadedFile then SaveFilesModule:unloadFile(SaveFilesModule.loadedFile) end
    if SettingsModule.loadedFile then SettingsModule:saveFile() end
end