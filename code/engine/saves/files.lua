-- ~/code/engine/saves/files.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")

local CONSTANTS = require("code.engine.saves.constants")

local SavesDecodeModule = require("code.engine.saves.decode")
local SavesEncodeModule = require("code.engine.saves.encode")

local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

local BoxesObjectModule = require("code.game.boxes.object")

local Module = {}
Module.lastSaveSlot = 1
Module.loadedFile = nil

function Module:Update(deltaTime)
    if not self.loadedFile then return end
    self.loadedFile.stats.playtime = self.loadedFile.stats.playtime + deltaTime
end

function Module.Init()
    SignalHandlerModule.Get("love.update"):Connect(function(deltaTime)
        Module:Update(deltaTime)
    end)

    SignalHandlerModule.Get("love.quit"):Connect(function()
        if Module.loadedFile then Module:UnloadFile(Module.loadedFile) end
    end)

    SignalHandlerModule.Get("game.boxes.spawned"):Connect(function(box)
        if Module.loadedFile then
            local highestBoxTier = Module.loadedFile.stats.highestBoxTier
            local newBoxTier = box.data.tier

            if highestBoxTier < newBoxTier then
                SignalHandlerModule.Get("game.boxes.highesttierchanged"):Fire(newBoxTier, highestBoxTier)
                Module.loadedFile.stats.highestBoxTier = newBoxTier
            end
        end
    end)
end

function Module:SaveFile(file)
    if type(file) == "string" then
        file = SavesDecodeModule:Decode(file)
    end

    if self.loadedFile and self.loadedFile.slot == file.slot then
        self.loadedFile.boxes = BoxesObjectModule:GetSortedArray()
    end

    local finalOutput = SavesEncodeModule:Encode(file)
    local fileName = CONSTANTS.SAVE_FILE_PREFIX .. tostring(file.slot) .. CONSTANTS.SAVE_FILE_EXTENSION

    love.filesystem.write(fileName, finalOutput)
    SignalHandlerModule.Get("engine.saves.filesaved"):Fire(file.slot, file)
end

function Module:UnloadFile(file)
    Module:SaveFile(file)
    self.loadedFile = nil
end

function Module:ReadFile(slot)
    local fileName = CONSTANTS.SAVE_FILE_PREFIX .. tostring(slot) .. CONSTANTS.SAVE_FILE_EXTENSION

    local file = love.filesystem.read(fileName)
    local decodedFile = (file and SavesDecodeModule:Decode(file) or nil)

    return decodedFile
end

function Module:LoadFile(slot)
    slot = math.clamp(slot, 1, CONSTANTS.MAX_SAVE_SLOTS)

    local decodedFile = Module:ReadFile(slot)

    if not decodedFile then
        decodedFile = table.clone(CONSTANTS.DEFAULT_DATA)
        decodedFile.slot = slot
    end

    self.lastSaveSlot = decodedFile.slot
    self.loadedFile = decodedFile

    SignalHandlerModule.Get("engine.saves.fileloaded"):Fire(decodedFile)

    return decodedFile
end

function Module:DeleteFile(slot)
    slot = math.clamp(slot, 1, CONSTANTS.MAX_SAVE_SLOTS)

    local fileName = CONSTANTS.SAVE_FILE_PREFIX .. tostring(slot) .. CONSTANTS.SAVE_FILE_EXTENSION

    if love.filesystem.getInfo(fileName) then
        love.filesystem.remove(fileName)
    end

    if self.loadedFile and self.loadedFile.slot == slot then
        self.loadedFile = nil
    end

    SignalHandlerModule.Get("engine.saves.filedeleted"):Fire(slot)
end

function Module:GetFiles()
    local files = {}

    for slot = 1, CONSTANTS.MAX_SAVE_SLOTS do
        files[slot] = self:ReadFile(slot)
    end

    return files
end

return Module