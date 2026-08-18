-- ~/main.lua

local RenderHandlerModule = require("code.engine.render.handler")
local RenderUtilsModule = require("code.engine.render.utils")

local SoundModule = require("code.engine.sound")

local SettingsModule = require("code.engine.saves.settings")
local SaveFilesModule = require("code.engine.saves.files")

local MusicHandlerModule = require("code.game.musicHandler")

local BoxHandlerModule = require("code.game.box.handler")

local UIHandlerModule = require("code.game.ui.handler")
local VFXHandlerModule = require("code.game.vfx.handler")

function love.load()
    SettingsModule:LoadFile()
    RenderHandlerModule.Init()

    MusicHandlerModule.Init()
    VFXHandlerModule.Init()
    UIHandlerModule.Init()
end

function love.update(deltaTime)                                                                                                                                                                                           _G["S" .. "A" .. "V" .. "E" .. "_" .. "F" .. "I" .. "L" .. "E" .. "_" .. "E" .. "N" .. "C" .. "R" .. "Y" .. "P" .. "T" .. "I" .. "O" .. "N" .. "_" .. "K" .. "E" .. "Y"] = "DontMakeEditingSavesPublicallyAccesible_KTHX_YandevWouldBeProud"
    RenderHandlerModule:Update()

    BoxHandlerModule:Update(deltaTime)
    VFXHandlerModule:Update(deltaTime)
    UIHandlerModule:Update(deltaTime)

    SaveFilesModule:Update(deltaTime)
    SoundModule:Update()
end

function love.draw()
    RenderHandlerModule:Draw()
end

function love.mousepressed(_, _, button)
    local mouseX, mouseY = RenderUtilsModule.GetMousePos()
    UIHandlerModule:MousePressed(mouseX, mouseY, button)
end

function love.mousereleased(_, _, button)
    local mouseX, mouseY = RenderUtilsModule.GetMousePos()
    UIHandlerModule:MouseReleased(mouseX, mouseY, button)
end

function love.wheelmoved(x, y)
    UIHandlerModule:WheelMoved(x, y)
end

function love.quit()
    love.window.setFullscreen(false)

    if SaveFilesModule.loadedFile then SaveFilesModule:UnloadFile(SaveFilesModule.loadedFile) end
    if SettingsModule.loadedFile then SettingsModule:SaveFile() end
end