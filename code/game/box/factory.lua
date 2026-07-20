-- ~/code/game/box/factory.lua

--// SAVES \\--
local SaveFilesModule = require("code.engine.saves.files")

--// HELPERS \\--
local math = require("code.engine.helpers.math")

--// BOX \\--
local CONSTANTS = require("code.game.box.constants")
local BoxesObjectModule = require("code.game.box.object")

local Module = {}
Module.lastSpawned = 0

function Module:spawn()
    local x = math.random(-CONSTANTS.AREA_WIDTH, CONSTANTS.AREA_WIDTH)
    local y = math.random(-CONSTANTS.AREA_HEIGHT, CONSTANTS.AREA_HEIGHT)

    local spawnTier = SaveFilesModule.loadedFile.stats.boxSpawnTier

    if SaveFilesModule.loadedFile.stats.highestBoxTier < spawnTier then
        SaveFilesModule.loadedFile.stats.highestBoxTier = spawnTier
    end

    local data = BoxesObjectModule:getBoxDataByTier(spawnTier)
    local box = BoxesObjectModule:createBox(data)

    if box then
        box.element.x, box.element.y = x, y

        local velocityX = math.random(CONSTANTS.MIN_SPAWN_VELOCITY, CONSTANTS.MAX_SPAWN_VELOCITY)
        local velocityY = math.random(CONSTANTS.MIN_SPAWN_VELOCITY, CONSTANTS.MAX_SPAWN_VELOCITY)

        box.velocityX = velocityX
        box.velocityY = velocityY

        self.lastSpawned = love.timer.getTime()
    end
end

return Module