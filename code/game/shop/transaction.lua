-- ~/code/game/shop/transaction.lua

local SaveFilesModule = require("code.engine.saves.files")

local Module = {}

function Module:canAfford(currency, amount)
    return (SaveFilesModule.loadedFile.currencies[currency] or 0) >= amount
end

function Module:purchase(currency, amount, callback)
    if not self:canAfford(currency, amount) then
        return false
    end

    SaveFilesModule.loadedFile.currencies[currency] =
        SaveFilesModule.loadedFile.currencies[currency] - amount

    if callback then
        callback()
    end

    return true
end

return Module