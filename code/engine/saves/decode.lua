-- ~/code/engine/saves/decode.lua

local CONSTANTS = require("code.engine.saves.constants")

local string = require("code.engine.helpers.string")
local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

local Module = {}

local function normalizeTable(input, default, ignoreKeys)
    ignoreKeys = ignoreKeys or {}

    local normalized = {}

    input = type(input) == "table" and input or {}

    for key, defaultValue in pairs(default) do
        local value = input[key]

        if ignoreKeys[key] then
            normalized[key] = value

        elseif type(defaultValue) == "table" then
            normalized[key] = normalizeTable(
                value,
                defaultValue,
                {}
            )

        else
            if value == nil then
                normalized[key] = defaultValue
            else
                normalized[key] = value
            end
        end
    end

    return normalized
end

local function decryptBase64(string)
    return love.data.decode("string", "base64", string)
end

local function decryptWithKey(string)
    local key = SAVE_FILE_ENCRYPTION_KEY
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

function Module:DecodeSimple(section)
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

function Module:DecodeBoxes(section)
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

function Module:DecodeVersion(section)
    if not section then return end

    local output = string.gsub(section, "version ", "")
    return tonumber(output)
end

function Module:DecodeSlot(section)
    if not section then return end

    local output = string.gsub(section, "slot ", "")
    return tonumber(output)
end

function Module:DecodeSettings(file)
    local sections = seperateLines(file)

    local finalOutput = {
        audio = self:DecodeSimple(sections[1]),
        graphics = self:DecodeSimple(sections[2]),
        accessibility = self:DecodeSimple(sections[3]),
    }

    finalOutput = normalizeTable(finalOutput, CONSTANTS.DEFAULT_SETTINGS)

    return finalOutput
end

function Module:Decode(file)
    file = decryptWithKey(file)
    file = decryptBase64(file)

    local sections = seperateLines(file)

    local hasMigrated = sections[6]
    local finalOutput = {
        version = self:DecodeVersion(sections[1]),
        slot = self:DecodeSlot(sections[2]),

        boxes = self:DecodeBoxes(sections[3]),

        currencies = self:DecodeSimple(sections[4]),
        stats = self:DecodeSimple(sections[5]),
        upgrades = self:DecodeSimple(sections[6])
    }

    if not hasMigrated then
        finalOutput = {
            version = CONSTANTS.DEFAULT_DATA.version,
            slot = self:DecodeSlot(sections[1]),

            boxes = self:DecodeBoxes(sections[4]),

            currencies = self:DecodeSimple(sections[2]),
            stats = self:DecodeSimple(sections[3]),
            upgrades = table.clone(CONSTANTS.DEFAULT_DATA.upgrades),
        }
    end

    finalOutput = normalizeTable(finalOutput, CONSTANTS.DEFAULT_DATA, {boxes = true})

    return finalOutput
end

return Module