-- ~/code/data/boxes.lua

local BoxConstructor = require("code.data.constructors.boxConstructor")

local CosmeticData = require("code.data.boxes.cosmeticData")
local GameplayData = require("code.data.boxes.gameplayData")
local FlavorData = require("code.data.boxes.flavorData")

local boxes = {}

for type, data in pairs(GameplayData) do
	boxes[type] = BoxConstructor.new(type, data, FlavorData[type], CosmeticData[type])
end

return boxes