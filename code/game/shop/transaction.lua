-- ~/code/game/shop/transaction.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")
local SaveFilesModule = require("code.engine.saves.files")

local Module = {}

function Module:CanAfford(currency, cost)
    local canAfford = (SaveFilesModule:Get("currencies." .. currency) or 0) >= cost

    if not canAfford then
        SignalHandlerModule.Get("game.shop.transactionfailed"):Fire(currency, cost)
    end

    return canAfford
end

function Module:Purchase(currency, cost, callback)
    local currencyPath = "currencies." .. currency
    local current = SaveFilesModule:Get(currencyPath)

    SaveFilesModule:Set(currencyPath, current - cost)

    if callback then
        callback()
    end

    SignalHandlerModule.Get("game.shop.transactioncompleted"):Fire(currency, cost)
    return true
end

return Module