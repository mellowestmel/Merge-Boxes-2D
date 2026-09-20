local BoxesObjectModule = require("code.game.boxes.object")

local CONSTANTS = require("code.data.constants")

local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

local stdString = _G.string
local stdTable = _G.table

local Module = {}

local CURRENT_VERSION = CONSTANTS.SAVES.DEFAULT_DATA.version

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

local function _decryptBase64(encoded)
	return love.data.decode("string", "base64", encoded)
end

local function _decryptWithKey(encrypted)
	local key = SAVE_FILE_ENCRYPTION_KEY

	assert(
		type(key) == "string" and #key > 0,
		"SAVE_FILE_ENCRYPTION_KEY is missing or empty"
	)

	local keyLength = #key
	local output = {}

	for index = 1, #encrypted do
		local eByte = encrypted:byte(index)
		local kByte = key:byte(((index - 1) % keyLength) + 1)

		output[index] = stdString.char(math.xorByte(eByte, kByte))
	end

	return stdTable.concat(output)
end

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

function Module:DecodeSimple(section)
	if not section then
		return
	end

	local result = {}

	for line in section:gmatch("[^\r\n]+") do
		local index, value = line:match("(%S+)%s+(%S+)")

		if index and value then
			if value == "true" then
				_assignPath(result, index, true)

			elseif value == "false" then
				_assignPath(result, index, false)

			else
				_assignPath(result, index, tonumber(value) or value)
			end
		end
	end

	return result
end

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

			-- skip corrupt lines instead of crashing later on nil numbers
			if box.velocityX and box.velocityY and box.x and box.y and box.rotation then
				boxes[#boxes + 1] = box
			end
		end
	end

	return boxes
end

-- Pre-v3 saves stored a numeric tier instead of a box type.
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
			local boxData = tier and BoxesObjectModule.GetBoxDataByTier(tier)

			local velocityX = tonumber(values[2])
			local velocityY = tonumber(values[3])
			local x = tonumber(values[4])
			local y = tonumber(values[5])
			local rotation = tonumber(values[6])

			if boxData and velocityX and velocityY and x and y and rotation then
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

function Module:DecodeVersion(section)
	if not section then
		return
	end

	return tonumber(section:match("^%s*version%s+(%d+)"))
end

function Module:DecodeSlot(section)
	if not section then
		return
	end

	return tonumber(section:match("^%s*slot%s+(%d+)"))
end

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

function Module:Decode(file)
	local ok, decoded = pcall(function()
		return _decryptBase64(_decryptWithKey(file))
	end)

	if not ok then
		return nil, tostring(decoded)
	end

	local sections = _splitSections(decoded)

	local version = self:DecodeVersion(sections[1])
	local finalOutput

	if version then
		finalOutput = {
			version = CURRENT_VERSION,
			slot = self:DecodeSlot(sections[2]),

			boxes = version < CURRENT_VERSION
				and self:DecodeLegacyBoxes(sections[3])
				or self:DecodeBoxes(sections[3]),

			currencies = self:DecodeSimple(sections[4]),
			stats = self:DecodeSimple(sections[5]),

			upgrades = self:DecodeSimple(sections[6]),
			trinkets = self:DecodeSimple(sections[7])
		}
	else
		finalOutput = {
			version = CURRENT_VERSION,
			slot = self:DecodeSlot(sections[1]),

			boxes = self:DecodeLegacyBoxes(sections[4]),

			currencies = self:DecodeSimple(sections[2]),
			stats = self:DecodeSimple(sections[3]),

			upgrades = table.clone(CONSTANTS.SAVES.DEFAULT_DATA.upgrades),
			trinkets = table.clone(CONSTANTS.SAVES.DEFAULT_DATA.trinkets)
		}
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