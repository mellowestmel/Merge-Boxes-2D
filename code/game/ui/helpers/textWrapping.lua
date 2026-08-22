-- ~/code/game/ui/helpers/textWrapping.lua

local Module = {}

function Module.Wrap(textElement, spriteElement, padding)
	padding = padding or 0

	local font = textElement.font or love.graphics.getFont()
	local maxWidth = spriteElement:GetWidth() - padding * 2

	local words = {}

	for word in textElement.text:gmatch("%S+") do
		table.insert(words, word)
	end

	local lines = {}
	local line = ""

	for _, word in pairs(words) do
		local candidate = line == ""
			and word
			or line .. " " .. word

		if font:getWidth(candidate) <= maxWidth then
			line = candidate
		else
			if line ~= "" then
				table.insert(lines, line)
			end

			line = word
		end
	end

	if line ~= "" then
		table.insert(lines, line)
	end

	textElement.text = table.concat(lines, "\n")

	return textElement
end

return Module