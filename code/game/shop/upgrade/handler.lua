-- ~/code/game/shop/upgrades/handler.lua

local SaveFilesModule = require("code.engine.saves.files")
local UpgradesData = require("code.data.shop.upgrades")

local Module = {}

function Module:getAllUpgrades()
    return UpgradesData.all
end

function Module:getUpgradesByShop(shopId)
    return UpgradesData.byShop[shopId] or {}
end

function Module:getStacks(id)
    return SaveFilesModule.loadedFile.upgrades[id] or 0
end

function Module:getUpgrade(id)
    return UpgradesData.all[id]
end

function Module:getEffect(id)
    for index, key in pairs(UpgradesData.all) do
        print(index, key)
    end
    local upgrade = self:getUpgrade(id)

    return upgrade.effect(self:getStacks(id))
end

function Module:addStack(id)
    SaveFilesModule.loadedFile.upgrades[id] =
        self:getStacks(id) + 1
end

function Module:isMaxed(id)
    local upgrade = self:getUpgrade(id)

    return self:getStacks(id) >= upgrade.maxStacks
end

return Module