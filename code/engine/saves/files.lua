-- ~/code/engine/saves/files.lua

local CONSTANTS = require("code.engine.saves.constants")

local SavesDecodeModule = require("code.engine.saves.decode")
local SavesEncodeModule = require("code.engine.saves.encode")

local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

local BoxesObjectModule = require("code.game.box.object")

local Module = {}
Module.lastSaveSlot = 1
Module.loadedFile = nil

function Module:update(deltaTime)
    if not self.loadedFile then return end

    self.loadedFile.stats.playtime = self.loadedFile.stats.playtime + deltaTime
end

function Module:saveFile(file)
    if type(file) == "string" then
        file = SavesDecodeModule:decode(file)
    end

    if self.loadedFile and self.loadedFile.slot == file.slot then
        self.loadedFile.boxes = BoxesObjectModule:getSortedArray()
    end

    local finalOutput = SavesEncodeModule:encode(file)
    local fileName = CONSTANTS.SAVE_FILE_PREFIX .. tostring(file.slot) .. CONSTANTS.SAVE_FILE_EXTENSION

    love.filesystem.write(fileName, finalOutput)
end

function Module:unloadFile(file)
    Module:saveFile(file)
    self.loadedFile = nil
end

function Module:readFile(slot)
    local fileName = CONSTANTS.SAVE_FILE_PREFIX .. tostring(slot) .. CONSTANTS.SAVE_FILE_EXTENSION

    local file = love.filesystem.read(fileName)
    local decodedFile = (file and SavesDecodeModule:decode(file) or nil)

    return decodedFile
end

local function loadBoxes(boxesData)
    if not boxesData then return end

    for _, box in pairs(boxesData) do
        local boxData = BoxesObjectModule:getBoxDataByTier(box.tier)
        local boxObject = BoxesObjectModule:createBox(boxData)

        if boxObject then
            boxObject.velocityX = box.velocityX
            boxObject.velocityY = box.velocityY

            boxObject.element.x = box.x
            boxObject.element.y = box.y

            boxObject.element.rotation = box.rotation
        end
    end
end

function Module:loadFile(slot)
    slot = math.clamp(slot, 1, CONSTANTS.MAX_SAVE_SLOTS)

    local decodedFile = Module:readFile(slot)

    if not decodedFile then
        decodedFile = table.clone(CONSTANTS.DEFAULT_DATA)
        decodedFile.slot = slot
    end

    loadBoxes(decodedFile.boxes)

    self.lastSaveSlot = decodedFile.slot
    self.loadedFile = decodedFile

    return decodedFile
end

function Module:deleteFile(slot)
    print("Deleting slot:", slot)

    slot = math.clamp(slot, 1, CONSTANTS.MAX_SAVE_SLOTS)

    print("After clamp:", slot)

    local fileName = CONSTANTS.SAVE_FILE_PREFIX .. tostring(slot) .. CONSTANTS.SAVE_FILE_EXTENSION
    print("Deleting file:", fileName)

    if love.filesystem.getInfo(fileName) then
        love.filesystem.remove(fileName)
    end

    if self.loadedFile and self.loadedFile.slot == slot then
        self.loadedFile = nil
    end
end

function Module:getFiles()
    local files = {}

    for slot = 1, CONSTANTS.MAX_SAVE_SLOTS do
        files[slot] = self:readFile(slot)
    end

    return files
end

return Module