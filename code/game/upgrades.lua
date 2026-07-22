-- ~/code/game/upgrades.lua

local SaveFilesModule = require("code.engine.saves.files")

local UpgradeData = require("code.data.shop.upgrades")

local Module = {}

function Module:getAllUpgrades()
    return UpgradeData
end

function Module:getStacks(id)
    return SaveFilesModule.loadedFile.upgrades[id] or 0
end

function Module:getUpgrade(id)
    return UpgradeData[id]
end

function Module:getEffect(id)
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