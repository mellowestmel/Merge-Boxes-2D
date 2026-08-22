-- ~/code/game/shop/upgrades/handler.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")
local SavesFilesModule = require("code.engine.saves.files")

local SAVES_CONSTANTS = require("code.engine.saves.constants")

local UpgradesData = require("code.data.shop.upgrades")

local Module = {}

function Module:GetAllUpgrades()
    return UpgradesData.all
end

function Module:GetUpgradesByShop(shopId)
    return UpgradesData.byShop[shopId] or {}
end

function Module:GetStacks(id)
    local upgradePath = "upgrades." .. id
    return SavesFilesModule:Get(upgradePath) or 0
end

function Module:GetUpgrade(id)
    return UpgradesData.all[id]
end

function Module:AddStack(id)
    local upgradePath = "upgrades." .. id

    SavesFilesModule:Set(
        upgradePath,
        self:GetStacks(id) + 1
    )

    self:Recount()
end

function Module:IsMaxed(id)
    local upgrade = self:GetUpgrade(id)

    return self:GetStacks(id) >= upgrade.maxStacks
end

function Module:Recount()
    local statsPath = "stats.upgradeable"
    local stats = {}

    for statName, value in pairs(
        SAVES_CONSTANTS.DEFAULT_DATA.stats.upgradeable
    ) do
        stats[statName] = value
    end

    for id, upgrade in pairs(UpgradesData.all) do
        local effects = upgrade.effect(self:GetStacks(id))

        for statName, value in pairs(effects) do
            if type(value) == "number"
                and type(stats[statName]) == "number"
            then
                stats[statName] = stats[statName] + value
            else
                stats[statName] = value
            end
        end
    end

    for statName, value in pairs(stats) do
        SavesFilesModule:Set(
            statsPath .. "." .. statName,
            value
        )
    end
end

function Module.Init()
    SignalHandlerModule.Get("engine.saves.fileloaded"):Connect(function()
        Module:Recount()
    end)
end

return Module