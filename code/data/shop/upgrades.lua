-- ~/code/data/shop/upgrades.lua

local UPGRADE_REQUIRE_DIRECTORY = "code.data.shop.upgrades."
local UPGRADES_DIRECTORY = "code/data/shop/upgrades"

local upgradesByShop = {}
local upgrades = {}

for _, fileName in pairs(love.filesystem.getDirectoryItems(UPGRADES_DIRECTORY)) do
    local shopId = fileName:match("(.+)%.lua$")

    if shopId then
        local rawUpgradeList = require(UPGRADE_REQUIRE_DIRECTORY .. shopId)
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