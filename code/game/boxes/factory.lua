-- ~/code/game/box/factory.lua

local UpgradeHandlerModule = require("code.game.shop.upgrade.handler")

local math = require("code.engine.helpers.math")

local CONSTANTS = require("code.game.boxes.constants")
local BoxesObjectModule = require("code.game.boxes.object")

local Module = {}
Module.lastSpawned = 0

function Module:Spawn()
    local baseSpawnTier = CONSTANTS.DEFAULT_BOX_SPAWN_TIER
    + UpgradeHandlerModule:GetEffect("spawnTier")

    local luckyChance = UpgradeHandlerModule:GetEffect("luckyRoll")
    local spawnAmount = UpgradeHandlerModule:GetEffect("multiSpawn")

    for _ = 1, spawnAmount do
        local spawnTier = baseSpawnTier

        -- Lucky Roll
        if math.random() < luckyChance then
            spawnTier = spawnTier + 1
        end

        local data = BoxesObjectModule.GetBoxDataByTier(spawnTier)
        local box = BoxesObjectModule.new(data)

        if box then
            local x = math.random(0, CONSTANTS.AREA_WIDTH)
            local y = math.random(0, CONSTANTS.AREA_HEIGHT)
            box.element.x, box.element.y = x, y

            box.velocityX = math.random(
                CONSTANTS.MIN_SPAWN_VELOCITY,
                CONSTANTS.MAX_SPAWN_VELOCITY
            )

            box.velocityY = math.random(
                CONSTANTS.MIN_SPAWN_VELOCITY,
                CONSTANTS.MAX_SPAWN_VELOCITY
            )
        end
    end

    self.lastSpawned = love.timer.getTime()
end

function Module:GetSpawnCooldown()
    return CONSTANTS.DEFAULT_BOX_SPAWN_COOLDOWN
        - UpgradeHandlerModule:GetEffect("spawnCooldown")
end

return Module