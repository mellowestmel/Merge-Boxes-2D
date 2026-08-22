-- ~/code/engine/saves/files.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")
local CONSTANTS = require("code.engine.saves.constants")

local SavesHelpersModule = require("code.engine.saves.helpers")
local SavesDecodeModule = require("code.engine.saves.decode")
local SavesEncodeModule = require("code.engine.saves.encode")

local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

local BoxesObjectModule = require("code.game.boxes.object")

local Module = {}
Module.lastSaveSlot = 1

Module.playtimeAtSessionStart = 0
Module.loadedFile = nil

function Module:Get(path)
    if not self.loadedFile then return nil end
    return SavesHelpersModule.GetPath(self.loadedFile, path)
end

function Module:Set(path, value)
    if not self.loadedFile then return end
    SavesHelpersModule.SetPath(self.loadedFile, path, value)
end

function Module:Update(deltaTime)
    if not self.loadedFile then return end

    local playtime = self:Get("stats.playtime") or 0
    self:Set("stats.playtime", playtime + deltaTime)
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
            local highestBoxTier = Module:Get("stats.highestBoxTier") or 0

            local newBoxTier = box.data and box.data.tier
            if not newBoxTier then return end

            if highestBoxTier < newBoxTier then
                SignalHandlerModule.Get("game.boxes.highesttierchanged"):Fire(newBoxTier, highestBoxTier)
                Module:Set("stats.highestBoxTier", newBoxTier)
            end
        end
    end)
end

function Module:SaveFile(file)
    if type(file) == "string" then
        file = SavesDecodeModule:Decode(file)
    end

    if self.loadedFile and self:Get("slot") == file.slot then
        self:Set("boxes", BoxesObjectModule:GetSortedArray())
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

    return file and SavesDecodeModule:Decode(file) or nil
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

    self.playtimeAtSessionStart = self:Get("stats.playtime")

    SignalHandlerModule.Get("engine.saves.fileloaded"):Fire(decodedFile)
    return decodedFile
end

function Module:DeleteFile(slot)
    slot = math.clamp(slot, 1, CONSTANTS.MAX_SAVE_SLOTS)
    local fileName = CONSTANTS.SAVE_FILE_PREFIX .. tostring(slot) .. CONSTANTS.SAVE_FILE_EXTENSION

    if love.filesystem.getInfo(fileName) then
        love.filesystem.remove(fileName)
    end

    if self.loadedFile and self:Get("slot") == slot then
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