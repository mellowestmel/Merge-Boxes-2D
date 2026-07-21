-- ~/code/game/shop/purchaseUpgrades.lua

--// MODULES \\--
local TransactionModule = require("code.game.shop.transaction")

--// DATA \\--
local UpgradeData = require("code.data.shop.upgrades")

local Module = {}

function Module:getCost(id)
    local upgrade = UpgradeData:getUpgrade(id)

    return math.floor(upgrade.cost(UpgradeData:getStacks(id)))
end

function Module:canBuy(id)
    local upgrade = UpgradeData:getUpgrade(id)

    if not upgrade then
        return false
    end

    if UpgradeData:isMaxed(id) then
        return false
    end

    if upgrade.canBuy and not upgrade.canBuy(UpgradeData:getStacks(id)) then
        return false
    end

    return TransactionModule:canAfford(
        upgrade.currency or "credits",
        self:getCost(id)
    )
end

function Module:buy(id)
    if not self:canBuy(id) then
        return false
    end

    local upgrade = UpgradeData:getUpgrade(id)

    return TransactionModule:purchase(
        upgrade.currency or "credits",
        self:getCost(id),
        function()
            UpgradeData:addStack(id)
        end
    )
end

return Module