local SignalHandlerModule = require("src.engine.events.signalHandler")

local CONSTANTS = require("src.data.constants")

local SavesHelpersModule = require("src.engine.saves.helpers")
local SavesDecodeModule = require("src.engine.saves.decode")
local SavesEncodeModule = require("src.engine.saves.encode")

local Module = {}
Module.loadedFile = nil

function Module:Get(path)
    if not self.loadedFile then return nil end
    return SavesHelpersModule.GetPath(self.loadedFile, path)
end

function Module:Set(path, value)
    if not self.loadedFile then return end
    SavesHelpersModule.SetPath(self.loadedFile, path, value)
end

function Module:SaveFile()
    local finalOutput = SavesEncodeModule:EncodeSettings(self.loadedFile)
    local fileName = CONSTANTS.SAVES.SETTINGS_FILE_NAME

    love.filesystem.write(fileName, finalOutput)
end

function Module:LoadFile()
    local fileName = CONSTANTS.SAVES.SETTINGS_FILE_NAME

    local file = love.filesystem.read(fileName)
    local decodedFile = (file and SavesDecodeModule:DecodeSettings(file) or nil)

    if not decodedFile then
        decodedFile = table.clone(CONSTANTS.SAVES.DEFAULT_SETTINGS)
    end

    self.loadedFile = decodedFile

    return decodedFile
end

function Module.Init()
    Module:LoadFile()

    SignalHandlerModule.Get("love.quit"):Connect(function()
        if Module.loadedFile then Module:SaveFile() end
    end)
end

return Module