---@diagnostic disable: undefined-field
-- ~/code/engine/saves/decode.lua

--// SAVES \\--
local CONSTANTS = require("code.engine.saves.constants")

--// HELPERS \\--
local string = require("code.engine.helpers.string")
local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

local Module = {}

local function normalizeTable(table, default, ignoreKeys)
    ignoreKeys = ignoreKeys or {}
    local normalized = {}

    for key, defaultValue in pairs(default) do
        if ignoreKeys[key] then
            normalized[key] = table[key] or (type(defaultValue) == "table" and {} or defaultValue)
        elseif type(defaultValue) == "table" then
            normalized[key] = normalizeTable(table[key] or {}, defaultValue, {})
        else
            normalized[key] = table[key] ~= nil and table[key] or defaultValue
        end
    end

    return normalized
end

local function decryptBase64(string)
    return love.data.decode("string", "base64", string)
end

local function decryptWithKey(string)
    local key = _G.SAVE_FILE_ENCRYPTION_KEY
    local keyLength = #key

    local output = {}

    for index = 1, #string do
        local eByte = string:byte(index)
        local kByte = key:byte(((index - 1) % keyLength) + 1)
        output[index] = string.char(math.xorByte(eByte, kByte))
    end

    return table.concat(output)
end

local function seperateLines(file)
    local sections = {}
    for section in file:gmatch("(.-)\n\n") do
        table.insert(sections, section)
    end

    local last = file:match("([^\n].*)$")
    if last then
        table.insert(sections, last)
    end

    return sections
end

function Module:decodeSimple(section)
    if not section then return end

    local result = {}

    for line in section:gmatch("[^\r\n]+") do
        local index, value = line:match("(%S+)%s+(%S+)")

        if index and value then
            if value == "true" then
                result[index] = true
            elseif value == "false" then
                result[index] = false
            else
                local num = tonumber(value)
                result[index] = num or value
            end
        end
    end

    return result
end

function Module:decodeBoxes(section)
    if not section then return end

    local boxes = {}

    for line in section:gmatch("[^\r\n]+") do
        local tier, velocityX, velocityY, x, y, rotation =
            line:match("(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")

        if tier and velocityX and velocityY and x and y and rotation then
            table.insert(boxes, {
                tier = tonumber(tier),

                velocityX = tonumber(velocityX),
                velocityY = tonumber(velocityY),
                
                x = tonumber(x),
                y = tonumber(y),

                rotation = tonumber(rotation)
            })
        end
    end

    return boxes
end

function Module:decodeSlot(section)
    if not section then return end

    local output = string.gsub(section, "slot ", "")
    return tonumber(output)
end

function Module:decodeSettings(file)
    local finalOutput = self:decodeSimple(file)
    finalOutput = normalizeTable(finalOutput, CONSTANTS.DEFAULT_SETTINGS)

    return finalOutput
end

function Module:decode(file)
    file = decryptWithKey(file)
    file = decryptBase64(file)

    local sections = seperateLines(file)

    local finalOutput = {
        slot = self:decodeSlot(sections[1]),

        currencies = self:decodeSimple(sections[2]),
        stats = self:decodeSimple(sections[3]),

        boxes = self:decodeBoxes(sections[4])
    }

    finalOutput = normalizeTable(finalOutput, CONSTANTS.DEFAULT_DATA, {boxes = true})

    return finalOutput
end

return Module