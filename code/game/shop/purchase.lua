-- ~/code/game/shop/purchase.lua

--// SAVES \\--
local SaveFilesModule = require("code.engine.saves.files")

local Module = {}

function Module:canAfford(currency, amount)
    return SaveFilesModule.loadedFile.currencies[currency] >= amount
end

function Module:spend(currency, amount)
    if not self:canAfford(currency, amount) then
        return false
    end

    SaveFilesModule.loadedFile.currencies[currency] =
        SaveFilesModule.loadedFile.currencies[currency] - amount

    return true
end

function Module:add(currency, amount)
    SaveFilesModule.loadedFile.currencies[currency] =
        (SaveFilesModule.loadedFile.currencies[currency] or 0) + amount
end

return Module