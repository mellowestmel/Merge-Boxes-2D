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

local function _loadBoxes(savedBoxesData)
    if not savedBoxesData then return end

    for _, savedBoxData in pairs(savedBoxesData) do
        local boxData = BoxesObjectModule.GetBoxDataByType(savedBoxData.type)
        if not boxData then goto continue end

        local box = BoxesObjectModule.new(boxData)
        if not box then return end

        box.element.x = savedBoxData.x
        box.element.y = savedBoxData.y

        box.element.rotation = savedBoxData.rotation

        box.velocityX = savedBoxData.velocityX
        box.velocityY = savedBoxData.velocityY

        box.trinkets = savedBoxData.trinkets

        :: continue ::
    end
end

function Module:LoadFile(slot)
    slot = math.clamp(slot, 1, CONSTANTS.MAX_SAVE_SLOTS)

    local decodedFile = Module:ReadFile(slot)

    if not decodedFile then
        decodedFile = table.clone(CONSTANTS.DEFAULT_DATA)
        decodedFile.slot = slot
    end

    _loadBoxes(decodedFile.boxes)

    self.lastSaveSlot = decodedFile.slot
    self.loadedFile = decodedFile

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
end

function Module:GetFiles()
    local files = {}

    for slot = 1, CONSTANTS.MAX_SAVE_SLOTS do
        files[slot] = self:ReadFile(slot)
    end

    return files
end

return Module