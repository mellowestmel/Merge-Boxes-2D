
local BoxesObjectModule = require("code.game.boxes.object")

local CONSTANTS = require("code.engine.saves.constants")

local string = require("code.engine.helpers.string")
local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

local Module = {}

local function _normalizeTable(input, default, ignoreKeys)
	ignoreKeys = ignoreKeys or {}

	local normalized = {}

	input = type(input) == "table" and input or {}

	for key, defaultValue in pairs(default) do
		local value = input[key]

		if ignoreKeys[key] then
			normalized[key] = value

		elseif type(defaultValue) == "table" then
			normalized[key] = _normalizeTable(
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

local function _decryptBase64(string)
	return love.data.decode("string", "base64", string)
end

local function _decryptWithKey(string)
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

local function _seperateLines(file)
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
	if not section then
		return
	end

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
	if not section then
		return
	end

	local boxes = {}

	for line in section:gmatch("[^\r\n]+") do
		local values = {}

		for value in line:gmatch("%S+") do
			table.insert(values, value)
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
				table.insert(box.items, values[index])
			end

			table.insert(boxes, box)
		end
	end

	return boxes
end

function Module:DecodeLegacyBoxes(section)
	if not section then
		return
	end

	local boxes = {}

	for line in section:gmatch("[^\r\n]+") do
		local values = {}

		for value in line:gmatch("%S+") do
			table.insert(values, value)
		end

		if #values >= 6 then
			local tier = tonumber(values[1])
			local boxData = BoxesObjectModule.GetBoxDataByTier(tier)

			if boxData then
				table.insert(boxes, {
					type = boxData.type,

					velocityX = tonumber(values[2]),
					velocityY = tonumber(values[3]),

					x = tonumber(values[4]),
					y = tonumber(values[5]),

					rotation = tonumber(values[6]),

					items = {}
				})
			end
		end
	end

	return boxes
end

function Module:DecodeVersion(section)
	if not section then
		return
	end

	local output = string.gsub(section, "version ", "")

	return tonumber(output)
end

function Module:DecodeSlot(section)
	if not section then
		return
	end

	local output = string.gsub(section, "slot ", "")

	return tonumber(output)
end

function Module:DecodeSettings(file)
	local sections = _seperateLines(file)

	local finalOutput = {
		audio = self:DecodeSimple(sections[1]),
		graphics = self:DecodeSimple(sections[2]),
		accessibility = self:DecodeSimple(sections[3]),
	}

	finalOutput = _normalizeTable(
		finalOutput,
		CONSTANTS.DEFAULT_SETTINGS
	)

	return finalOutput
end

function Module:Decode(file)
	file = _decryptWithKey(file)
	file = _decryptBase64(file)

	local sections = _seperateLines(file)

	local version = self:DecodeVersion(sections[1])
	local finalOutput

	if version then
		finalOutput = {
			version = CONSTANTS.DEFAULT_DATA.version,
			slot = self:DecodeSlot(sections[2]),

			boxes = version < CONSTANTS.DEFAULT_DATA.version
				and self:DecodeLegacyBoxes(sections[3])
				or self:DecodeBoxes(sections[3]),

			currencies = self:DecodeSimple(sections[4]),
			stats = self:DecodeSimple(sections[5]),
			upgrades = self:DecodeSimple(sections[6])
		}
	else
		finalOutput = {
			version = CONSTANTS.DEFAULT_DATA.version,
			slot = self:DecodeSlot(sections[1]),

			boxes = self:DecodeLegacyBoxes(sections[4]),

			currencies = self:DecodeSimple(sections[2]),
			stats = self:DecodeSimple(sections[3]),

			upgrades = table.clone(CONSTANTS.DEFAULT_DATA.upgrades)
		}
	end
	print("----------------------")
	for index, v in pairs(self:DecodeSimple(sections[6])) do
		print(index, v)
	end

	return _normalizeTable(
		finalOutput,
		CONSTANTS.DEFAULT_DATA,
		{
			boxes = true
		}
	)
end

return Module