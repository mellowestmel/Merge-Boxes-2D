-- ~/code/data/shop/upgrades.lua

local CONSTANTS = require("code.data.constants")

local upgradesByShop = {}
local upgrades = {}

for _, fileName in pairs(love.filesystem.getDirectoryItems(CONSTANTS.SHOP.UPGRADE_DATA.DIRECTORY)) do
    local shopId = fileName:match("(.+)%.lua$")

    if shopId then
        local rawUpgradeList = require(CONSTANTS.SHOP.UPGRADE_DATA.REQUIRE_DIRECTORY .. shopId)
        local shopUpgradeIds = {}

        for _, upgradeData in pairs(rawUpgradeList) do
            upgradeData.shopId = shopId

            upgrades[upgradeData.id] = upgradeData
            table.insert(shopUpgradeIds, upgradeData.id)
        end

        table.sort(shopUpgradeIds)
        upgradesByShop[shopId] = shopUpgradeIds
    end
end

return {
    all = upgrades,
    byShop = upgradesByShop,
}