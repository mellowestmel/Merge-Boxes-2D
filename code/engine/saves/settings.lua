-- ~/code/engine/saves/files.lua

local CONSTANTS = require("code.engine.saves.constants")

local SavesDecodeModule = require("code.engine.saves.decode")
local SavesEncodeModule = require("code.engine.saves.encode")

local table = require("code.engine.helpers.table")

local Module = {}
Module.loadedFile = nil

function Module:SaveFile()
    local finalOutput = SavesEncodeModule:EncodeSettings(self.loadedFile)
    local fileName = CONSTANTS.SETTINGS_FILE_NAME

    love.filesystem.write(fileName, finalOutput)
end

function Module:LoadFile()
    local fileName = CONSTANTS.SETTINGS_FILE_NAME

    local file = love.filesystem.read(fileName)
    local decodedFile = (file and SavesDecodeModule:DecodeSettings(file) or nil)

    if not decodedFile then
        decodedFile = table.clone(CONSTANTS.DEFAULT_SETTINGS)
    end

    self.loadedFile = decodedFile

    return decodedFile
end

return Module