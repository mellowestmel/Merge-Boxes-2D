-- ~/code/game/shop/upgrades/purchase.lua

local TransactionModule = require("code.game.shop.transaction")

local UpgradeHandlerModule = require("code.game.shop.upgrade.handler")

local Module = {}

function Module:GetCost(id)
    local upgrade = UpgradeHandlerModule:GetUpgrade(id)

    return math.floor(upgrade.cost(UpgradeHandlerModule:GetStacks(id)))
end

function Module:CanBuy(id, shopId)
    local upgrade = UpgradeHandlerModule:GetUpgrade(id)

    if not upgrade then
        return false
    end

    if shopId and upgrade.shopId ~= shopId then
        return false
    end

    if UpgradeHandlerModule:IsMaxed(id) then
        return false
    end

    return TransactionModule:CanAfford(
        upgrade.currency or "credits",
        self:GetCost(id)
    )
end

function Module:Buy(id, shopId)
    if not self:CanBuy(id, shopId) then
        return false
    end

    local upgrade = UpgradeHandlerModule:GetUpgrade(id)

    return TransactionModule:Purchase(
        upgrade.currency or "credits",
        self:GetCost(id),
        function()
            UpgradeHandlerModule:AddStack(id)
        end
    )
end

return Module