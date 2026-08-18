-- ~/code/engine/saves/encode.lua

local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

local Module = {}

local function encryptBase64(string)
    return love.data.encode("string", "base64", string)
end

local function encryptWithKey(string)
    local key = _G.SAVE_FILE_ENCRYPTION_KEY
    local keyLength = #key

    local output = {}

    for index = 1, #string do
        local sByte = string:byte(index)
        local kByte = key:byte(((index - 1) % keyLength) + 1)
        output[index] = string.char(math.xorByte(sByte, kByte))
    end

    return table.concat(output)
end

local function addStringNewLine(...)
    local parts = {...}
    return table.concat(parts, "\n")
end

local function addString(...)
    local parts = {...}
    return table.concat(parts, " ")
end

function Module:EncodeBoxes(boxes)
    local output = ""

    for _, box in pairs(boxes) do
        local line = addString(
            box.tier,

            box.velocityX,
            box.velocityY,

            box.element.x,
            box.element.y,

            box.element.rotation
        )
        output = output .. line .. "\n"
    end

    return output
end

function Module:EncodeSimple(section)
    if not section then return "" end

    local lines = {}
    for key, value in pairs(section) do
        table.insert(lines, key .. " " .. tostring(value))
    end

    return table.concat(lines, "\n") .. "\n"
end


function Module:EncodeVersion(version)
    return "version " .. version .. "\n"
end

function Module:EncodeSlot(slot)
    return "slot " .. slot .. "\n"
end

function Module:EncodeSettings(file)
    local finalOutput = addStringNewLine(
        self:EncodeSimple(file.audio),
        self:EncodeSimple(file.graphics),
        self:EncodeSimple(file.accessibility)
    )

    return finalOutput
end

function Module:Encode(file)
    local finalOutput = addStringNewLine(
        self:EncodeVersion(file.version),
        self:EncodeSlot(file.slot),

        self:EncodeBoxes(file.boxes),

        self:EncodeSimple(file.currencies),
        self:EncodeSimple(file.stats),
        self:EncodeSimple(file.upgrades)
    )

    finalOutput = encryptBase64(finalOutput)
    finalOutput = encryptWithKey(finalOutput)

    return finalOutput
end

return Module