-- ~/code/game/box/factory.lua

local SaveFilesModule = require("code.engine.saves.files")

local UpgradeHandlerModule = require("code.game.upgradeHandler")

local math = require("code.engine.helpers.math")

local CONSTANTS = require("code.game.box.constants")
local BoxesObjectModule = require("code.game.box.object")

local Module = {}
Module.lastSpawned = 0

function Module:spawn()
    local x = math.random(0, CONSTANTS.AREA_WIDTH)
    local y = math.random(0, CONSTANTS.AREA_HEIGHT)

    local spawnTier = CONSTANTS.DEFAULT_BOX_SPAWN_TIER
        + UpgradeHandlerModule:getEffect("spawnTier")

    local spawnAmount = UpgradeHandlerModule:getEffect("multiSpawn")

    for _ = 1, spawnAmount do
        -- Lucky Roll
        local luckyChance = UpgradeHandlerModule:getEffect("luckyRoll")

        if math.random() < luckyChance then
            spawnTier = spawnTier + 1
        end

        if SaveFilesModule.loadedFile.stats.highestBoxTier < spawnTier then
            SaveFilesModule.loadedFile.stats.highestBoxTier = spawnTier
        end

        local data = BoxesObjectModule:getBoxDataByTier(spawnTier)
        local box = BoxesObjectModule:createBox(data)

        if box then
            box.element.x, box.element.y = x, y

            local velocityX = math.random(
                CONSTANTS.MIN_SPAWN_VELOCITY,
                CONSTANTS.MAX_SPAWN_VELOCITY
            )

            local velocityY = math.random(
                CONSTANTS.MIN_SPAWN_VELOCITY,
                CONSTANTS.MAX_SPAWN_VELOCITY
            )

            box.velocityX = velocityX
            box.velocityY = velocityY

            self.lastSpawned = love.timer.getTime()
        end
    end
end

function Module:getSpawnCooldown()
    return CONSTANTS.DEFAULT_BOX_SPAWN_COOLDOWN
        - UpgradeHandlerModule:getEffect("spawnCooldown")
end

return Module