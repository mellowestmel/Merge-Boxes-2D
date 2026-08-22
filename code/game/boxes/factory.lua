-- ~/code/game/boxes/factory.lua

local SavesFilesModule = require("code.engine.saves.files")

local math = require("code.engine.helpers.math")

local CONSTANTS = require("code.game.boxes.constants")
local BoxesObjectModule = require("code.game.boxes.object")

local Module = {}
Module.lastSpawned = 0
Module.autoSpawnEnabled = false

function Module:Spawn()
    local spawnTier = SavesFilesModule:Get("stats.upgradeable.spawnTier")
    local extraTierChance = SavesFilesModule:Get("stats.upgradeable.extraSpawnTierChance")

    local spawnAmount = SavesFilesModule:Get("stats.upgradeable.spawnCount")

    for _ = 1, spawnAmount do
        local currentSpawnTier = spawnTier

        if math.random() < extraTierChance then
            currentSpawnTier = currentSpawnTier + 1
        end

        local data = BoxesObjectModule.GetBoxDataByTier(currentSpawnTier)
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

function Module:Update()
    if not SavesFilesModule:Get("stats.upgradeable.autoSpawnUnlocked") or not self.autoSpawnEnabled then
        return
    end

    local cooldown = SavesFilesModule:Get("stats.upgradeable.spawnCooldown")
    local time = love.timer.getTime() - self.lastSpawned

    if time >= cooldown then
        self:Spawn()
    end
end

return Module