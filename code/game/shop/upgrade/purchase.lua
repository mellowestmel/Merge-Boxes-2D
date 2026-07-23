-- ~/code/game/shop/upgrades/purchase.lua

local TransactionModule = require("code.game.shop.transaction")

local UpgradeHandlerModule = require("code.game.shop.upgrade.handler")

local Module = {}

function Module:getCost(id)
    local upgrade = UpgradeHandlerModule:getUpgrade(id)

    return math.floor(upgrade.cost(UpgradeHandlerModule:getStacks(id)))
end

function Module:canBuy(id, shopId)
    local upgrade = UpgradeHandlerModule:getUpgrade(id)

    if not upgrade then
        return false
    end

    if shopId and upgrade.shopId ~= shopId then
        return false
    end

    if UpgradeHandlerModule:isMaxed(id) then
        return false
    end

    return TransactionModule:canAfford(
        upgrade.currency or "credits",
        self:getCost(id)
    )
end

function Module:buy(id, shopId)
    if not self:canBuy(id, shopId) then
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