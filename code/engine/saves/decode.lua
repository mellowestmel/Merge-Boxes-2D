local BoxesObjectModule = require("code.game.boxes.object")

local CONSTANTS = require("code.data.constants")

local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

local Module = {}

-- Fills missing values using the given defaults.
-- Tables are normalized recursively unless they are ignored.
local function _normalizeTable(input, default, ignoreKeys)
    ignoreKeys = ignoreKeys or {}
    input = type(input) == "table" and input or {}

    local normalized = {}

    for key, defaultValue in pairs(default) do
        local value = input[key]

        if ignoreKeys[key] then
            if value == nil then
                value = type(defaultValue) == "table"
                    and table.clone(defaultValue)
                    or defaultValue
            end

            normalized[key] = value

        elseif type(defaultValue) == "table" then
            normalized[key] = _normalizeTable(value, defaultValue)

        elseif value == nil then
            normalized[key] = defaultValue

        else
            normalized[key] = value
        end
    end

    return normalized
end

-- Decodes the base64 layer of the save data.
local function _decryptBase64(encoded)
    return love.data.decode("string", "base64", encoded)
end

-- Removes the encryption layer using the save file key.
local function _decryptWithKey(encrypted)
    local key = SAVE_FILE_ENCRYPTION_KEY
    local keyLength = #key
    local output = {}

    for index = 1, #encrypted do
        local eByte = encrypted:byte(index)
        local kByte = key:byte(((index - 1) % keyLength) + 1)

        output[index] = string.char(math.xorByte(eByte, kByte))
    end

    return table.concat(output)
end

-- Splits the decoded save into sections.
-- Each section is separated by an empty line.
local function _splitSections(file)
    local sections = {}

    file = file:gsub("\r\n", "\n")

    local start = 1

    while true do
        local separatorStart, separatorEnd = file:find("\n\n", start, true)

        if not separatorStart then
            sections[#sections + 1] = file:sub(start)
            break
        end

        sections[#sections + 1] = file:sub(start, separatorStart - 1)
        start = separatorEnd + 1
    end

    return sections
end

-- Creates nested tables from a dotted path.
-- For example, "upgradeable.spawnCount" becomes a nested table.
local function _assignPath(target, path, value)
    local segments = {}

    for segment in path:gmatch("[^%.]+") do
        segments[#segments + 1] = segment
    end

    if #segments == 0 then
        return
    end

    local node = target

    for index = 1, #segments - 1 do
        local segment = segments[index]

        if type(node[segment]) ~= "table" then
            node[segment] = {}
        end

        node = node[segment]
    end

    node[segments[#segments]] = value
end

-- Decodes a simple key-value section.
local function _decodeValue(value)
    if value == "true" then
        return true
    end

    if value == "false" then
        return false
    end

    return tonumber(value) or value
end

function Module:DecodeSimple(section)
    if not section then
        return
    end

    local result = {}

    for line in section:gmatch("[^\r\n]+") do
        local index, value = line:match("(%S+)%s+(%S+)")

        if index and value then
            _assignPath(result, index, _decodeValue(value))
        end
    end

    return result
end

-- Decodes boxes saved using their box type.
function Module:DecodeBoxes(section)
    if not section then
        return
    end

    local boxes = {}

    for line in section:gmatch("[^\r\n]+") do
        local values = {}

        for value in line:gmatch("%S+") do
            values[#values + 1] = value
        end

        if #values >= 6 then
            local box = {
                type = values[1],

                velocityX = tonumber(values[2]),
                velocityY = tonumber(values[3]),

                x = tonumber(values[4]),
                y = tonumber(values[5]),

                rotation = tonumber(values[6]),

                items = {}
            }

            for index = 7, #values do
                box.items[#box.items + 1] = values[index]
            end

            if box.velocityX
                and box.velocityY
                and box.x
                and box.y
                and box.rotation
            then
                boxes[#boxes + 1] = box
            end
        end
    end

    return boxes
end

-- Decodes boxes from saves made before version 3.
-- Older saves stored the box tier instead of the box type.
function Module:DecodeLegacyBoxes(section)
    if not section then
        return
    end

    local boxes = {}

    for line in section:gmatch("[^\r\n]+") do
        local values = {}

        for value in line:gmatch("%S+") do
            values[#values + 1] = value
        end

        if #values >= 6 then
            local tier = tonumber(values[1])
            local boxData = tier
                and BoxesObjectModule.GetBoxDataByTier(tier)

            local velocityX = tonumber(values[2])
            local velocityY = tonumber(values[3])
            local x = tonumber(values[4])
            local y = tonumber(values[5])
            local rotation = tonumber(values[6])

            if boxData
                and velocityX
                and velocityY
                and x
                and y
                and rotation
            then
                boxes[#boxes + 1] = {
                    type = boxData.type,

                    velocityX = velocityX,
                    velocityY = velocityY,

                    x = x,
                    y = y,

                    rotation = rotation,

                    items = {}
                }
            end
        end
    end

    return boxes
end

-- Reads the save version from a version section.
function Module:DecodeVersion(section)
    if not section then
        return
    end

    return tonumber(section:match("^%s*version%s+(%d+)"))
end

-- Reads the save slot from a slot section.
function Module:DecodeSlot(section)
    if not section then
        return
    end

    return tonumber(section:match("^%s*slot%s+(%d+)"))
end

-- Decodes the settings file and fills missing settings with defaults.
function Module:DecodeSettings(file)
    local sections = _splitSections(file)

    local finalOutput = {
        audio = self:DecodeSimple(sections[1]),
        graphics = self:DecodeSimple(sections[2]),
        accessibility = self:DecodeSimple(sections[3]),
    }

    return _normalizeTable(
        finalOutput,
        CONSTANTS.SAVES.DEFAULT_SETTINGS
    )
end

-- Decodes a save file and updates older save formats to the current format.
function Module:Decode(file)
    local ok, decoded = pcall(function()
        return _decryptBase64(_decryptWithKey(file))
    end)

    if not ok then
        return nil, tostring(decoded)
    end

    local sections = _splitSections(decoded)

    local newestVersion = CONSTANTS.SAVES.DEFAULT_DATA.version
    local version = self:DecodeVersion(sections[1])

    local finalOutput

    if version then
        local isV4 = version >= 4

        finalOutput = {
            version = newestVersion,

            slot = self:DecodeSlot(sections[2]),

            boxes = version < 3
                and self:DecodeLegacyBoxes(sections[3])
                or self:DecodeBoxes(sections[3]),

            currencies = self:DecodeSimple(sections[4]),
            stats = self:DecodeSimple(sections[5]),

            tracking = isV4
                and self:DecodeSimple(sections[6])
                or nil,

            upgrades = self:DecodeSimple(
                isV4 and sections[7] or sections[6]
            ),

            trinkets = self:DecodeSimple(
                isV4 and sections[8] or sections[7]
            )
        }

        if version < 4 then
            -- Tracking used to be stored inside stats.
            finalOutput.tracking = table.clone(
                CONSTANTS.SAVES.DEFAULT_DATA.tracking
            )

            finalOutput.tracking.playtime = finalOutput.stats.playtime
            finalOutput.tracking.highestBoxTier =
                finalOutput.stats.highestBoxTier

            finalOutput.stats.playtime = nil
            finalOutput.stats.highestBoxTier = nil
        end
    else
        finalOutput = {
            version = newestVersion,

            slot = self:DecodeSlot(sections[1]),

            boxes = self:DecodeLegacyBoxes(sections[4]),

            currencies = self:DecodeSimple(sections[2]),
            stats = self:DecodeSimple(sections[3]),

            upgrades = table.clone(
                CONSTANTS.SAVES.DEFAULT_DATA.upgrades
            ),

            trinkets = table.clone(
                CONSTANTS.SAVES.DEFAULT_DATA.trinkets
            )
        }

        -- Old saves also stored tracking values inside stats.
        finalOutput.tracking = table.clone(
            CONSTANTS.SAVES.DEFAULT_DATA.tracking
        )

        finalOutput.tracking.playtime = finalOutput.stats.playtime
        finalOutput.tracking.highestBoxTier =
            finalOutput.stats.highestBoxTier

        finalOutput.stats.playtime = nil
        finalOutput.stats.highestBoxTier = nil
    end

    return _normalizeTable(
        finalOutput,
        CONSTANTS.SAVES.DEFAULT_DATA,
        {
            boxes = true,
            trinkets = true
        }
    )
end

return Module