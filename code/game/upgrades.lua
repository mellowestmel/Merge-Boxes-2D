-- ~/code/game/upgrades.lua

--// SAVES \\--
local SaveFilesModule = require("code.engine.saves.files")

--// DATA \\--
local UpgradeData = require("code.data.shop.upgrades")

local Module = {}

function Module:getStacks(id)
    return SaveFilesModule.loadedFile.upgrades[id] or 0
end

function Module:getUpgrade(id)
    return UpgradeData[id]
end

function Module:isMaxed(id)
    local upgrade = self:getUpgrade(id)

    return self:getStacks(id) >= upgrade.maxStacks
end

function Module:getEffect(id)
    local upgrade = self:getUpgrade(id)

    return upgrade.effect(self:getStacks(id))
end

return Module