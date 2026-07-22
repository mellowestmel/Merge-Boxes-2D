-- ~/code/game/shop/purchaseUpgrades.lua

local TransactionModule = require("code.game.shop.transaction")

local UpgradeHandlerModule = require("code.game.upgradeHandler")

local Module = {}

function Module:getCost(id)
    local upgrade = UpgradeHandlerModule:getUpgrade(id)

    return math.floor(upgrade.cost(UpgradeHandlerModule:getStacks(id)))
end

function Module:canBuy(id)
    local upgrade = UpgradeHandlerModule:getUpgrade(id)

    if not upgrade then
        return false
    end

    if UpgradeHandlerModule:isMaxed(id) then
        return false
    end

    if upgrade.canBuy and not upgrade.canBuy(UpgradeHandlerModule:getStacks(id)) then
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

    local upgrade = UpgradeHandlerModule:getUpgrade(id)

    return TransactionModule:purchase(
        upgrade.currency or "credits",
        self:getCost(id),
        function()
            UpgradeHandlerModule:addStack(id)
        end
    )
end

return Module