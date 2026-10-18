local BoxConstructor = require("src.data.constructors.boxConstructor")

local CosmeticData = require("src.data.boxes.cosmeticData")
local GameplayData = require("src.data.boxes.gameplayData")

local boxes = {}

for type, data in pairs(GameplayData) do
	boxes[type] = BoxConstructor.new(type, data, CosmeticData[type])
end

return boxes