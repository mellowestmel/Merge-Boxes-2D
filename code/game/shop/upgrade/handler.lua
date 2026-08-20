-- ~/code/game/shop/upgrades/handler.lua

local SaveFilesModule = require("code.engine.saves.files")
local UpgradesData = require("code.data.shop.upgrades")

local Module = {}

function Module:GetAllUpgrades()
    return UpgradesData.all
end

function Module:GetUpgradesByShop(shopId)
    return UpgradesData.byShop[shopId] or {}
end

function Module:GetStacks(id)
    return SaveFilesModule.loadedFile.upgrades[id] or 0
end

function Module:GetUpgrade(id)
    return UpgradesData.all[id]
end

function Module:GetEffect(id)
    local upgrade = self:GetUpgrade(id)

    return upgrade.effect(self:GetStacks(id))
end

function Module:AddStack(id)
    SaveFilesModule.loadedFile.upgrades[id] =
        self:GetStacks(id) + 1
end

function Module:IsMaxed(id)
    local upgrade = self:GetUpgrade(id)
    return self:GetStacks(id) >= upgrade.maxStacks
end

return Module