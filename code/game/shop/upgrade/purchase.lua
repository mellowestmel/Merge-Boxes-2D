-- ~/code/game/shop/upgrades/purchase.lua


local SignalHandlerModule = require("code.engine.events.signalHandler")

local TransactionModule = require("code.game.shop.transaction")
local UpgradeHandlerModule = require("code.game.shop.upgrade.handler")

local Module = {}

function Module:GetCost(id)
    local upgrade = UpgradeHandlerModule:GetUpgrade(id)

    return math.floor(upgrade.cost(UpgradeHandlerModule:GetStacks(id)))
end

function Module:CanBuy(id, shopId)
    local upgrade = UpgradeHandlerModule:GetUpgrade(id)

    local currency = upgrade.currency or "credits"
    local cost = self:GetCost(id)

    local function failed()
        SignalHandlerModule.Get("game.shop.transactionfailed"):Fire(currency, cost)
        return false
    end

    if not upgrade then return failed() end
    if shopId and upgrade.shopId ~= shopId then return failed() end
    if UpgradeHandlerModule:IsMaxed(id) then return failed() end

    return TransactionModule:CanAfford(currency, cost)
end

function Module:Buy(id, shopId)
    if not self:CanBuy(id, shopId) then
        return false
    end

    local upgrade = UpgradeHandlerModule:GetUpgrade(id)
    SignalHandlerModule.Get("game.shop.upgradepurchased"):Fire(id, shopId, self:GetCost(id))

    local result = TransactionModule:Purchase(
        upgrade.currency or "credits",
        self:GetCost(id),

        function()
            UpgradeHandlerModule:AddStack(id)
        end
    )

    if UpgradeHandlerModule:IsMaxed(id) then
        SignalHandlerModule.Get("game.shop.upgrademaxed"):Fire(id)
    end

    return result
end

return Module