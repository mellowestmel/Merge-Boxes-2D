-- ~/code/game/shop/purchaseUpgrades.lua

local TransactionModule = require("code.game.shop.transaction")

local UpgradesModule = require("code.game.upgrades")

local Module = {}

function Module:getCost(id)
    local upgrade = UpgradesModule:getUpgrade(id)

    return math.floor(upgrade.cost(UpgradesModule:getStacks(id)))
end

function Module:canBuy(id)
    local upgrade = UpgradesModule:getUpgrade(id)

    if not upgrade then
        return false
    end

    if UpgradesModule:isMaxed(id) then
        return false
    end

    if upgrade.canBuy and not upgrade.canBuy(UpgradesModule:getStacks(id)) then
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

    local upgrade = UpgradesModule:getUpgrade(id)

    return TransactionModule:purchase(
        upgrade.currency or "credits",
        self:getCost(id),
        function()
            UpgradesModule:addStack(id)
        end
    )
end

return Module