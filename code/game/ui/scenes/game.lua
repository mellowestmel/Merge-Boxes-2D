-- ~/code/game/ui/scenes/game.lua

--/// ENGINE \\\--
local RenderModule = require("code.engine.render")

--// SAVES \\--
local SaveFilesModule = require("code.engine.saves.files")

--// HELPERS \\--
local string = require("code.engine.helpers.string")
local table = require("code.engine.helpers.table")

--/// GAME \\\--
local MusicHandlerModule = require("code.game.musicHandler")

--// BOX \\--
local BoxesObjectModule = require("code.game.box.object")
local BoxFactoryModule = require("code.game.box.factory")

--// SHOP \\--
local SHOP_CONSTANTS = require("code.game.shop.constants")

--// UI \\--
local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")

--/ UI OBJECTS \--
local UIButtonObjectModule = require("code.game.ui.objects.button")

--// VFX \\--
local ScreenTransitionModule = require("code.game.vfx.screenTransition")
local ScreenFlashModule = require("code.game.vfx.screenFlash")

--/// DATA \\\--
local SharedData = require("code.data.ui.scenes.shared")
local SceneData = require("code.data.ui.scenes.game")

local Module = {}
Module._elements = {}
Module._objects = {}
Module.name = "game"

local spawnButtonHitbox = nil
local spawnButtonLabel = nil
local spawnButton = nil

local backButtonClicked = false

local upgradeShopButtonHitbox = nil
local blackMarketButtonHitbox = nil
local sacrificeButtonHitbox = nil

function Module:clean()
    for _, element in pairs(self._elements) do
        element:remove()
    end

    for _, button in pairs(self._objects) do
        button:remove()
    end

    self._elements = {}
    self._objects = {}

    if not backButtonClicked then
        SaveFilesModule:saveFile(SaveFilesModule.loadedFile)
    else
        BoxesObjectModule:clearBoxes()
    end

    ScreenFlashModule:stop()
end

local function setupBackground(self)
    local playAreaBackground = RenderModule:createElement(SceneData.playAreaBackground)
    table.insert(self._elements, playAreaBackground)
end

local function setupBackToMenuButton(self)
    backButtonClicked = false

    local backToMenuButtonHitbox = RenderModule:createElement(SharedData.backToMenuButtonHitbox)
    table.insert(self._elements, backToMenuButtonHitbox)

    local backToMenuButton = UIButtonObjectModule:createButton({
        elements = {
            backToMenuButtonHitbox,
        },

        hitboxElement = backToMenuButtonHitbox,

        mouseButton = 1,
        onClick = function()
            backButtonClicked = true

            ScreenTransitionModule:transition({
                callback = function()
                    SaveFilesModule:unloadFile(SaveFilesModule.loadedFile)
                    UISceneHandlerModule:switch("saveFiles")
                end
            })
        end
    })

    table.insert(self._objects, backToMenuButton)
end

local function setupSpawnButton(self)
    spawnButtonHitbox = RenderModule:createElement(SceneData.spawnButtonHitbox)
    spawnButtonLabel = RenderModule:createElement(SceneData.spawnButtonLabel)

    table.insert(self._elements, spawnButtonHitbox)
    table.insert(self._elements, spawnButtonLabel)

    spawnButton = UIButtonObjectModule:createButton({
        elements = {
            spawnButtonHitbox,
            spawnButtonLabel
        },

        hitboxElement = spawnButtonHitbox,

        mouseButton = 1,
        onClick = function()
            BoxFactoryModule:spawn()
        end
    })

    table.insert(self._objects, spawnButton)
end

local function setupUpgradeShopButton(scene)
    upgradeShopButtonHitbox = RenderModule:createElement(SceneData.upgradeShopButtonHitbox)
    table.insert(scene._elements, upgradeShopButtonHitbox)

    local upgradeShopButton = UIButtonObjectModule:createButton({
        elements = {
            upgradeShopButtonHitbox,
        },

        hitboxElement = upgradeShopButtonHitbox,

        mouseButton = 1,
        onClick = function()
            if SaveFilesModule.loadedFile.stats.highestBoxTier < SHOP_CONSTANTS.UPGRADE_SHOP_UNLOCK_REQUIREMENT then return end

            ScreenTransitionModule:transition({
                callback = function()
                    UISceneHandlerModule:switch("upgradeShop")
                end
            })
        end
    })

    table.insert(scene._objects, upgradeShopButton)
end

local function setupBlackMarketButton(scene)
    blackMarketButtonHitbox = RenderModule:createElement(SceneData.blackMarketButtonHitbox)
    table.insert(scene._elements, blackMarketButtonHitbox)

    local blackMarketButton = UIButtonObjectModule:createButton({
        elements = {
            blackMarketButtonHitbox,
        },

        hitboxElement = blackMarketButtonHitbox,

        mouseButton = 1,
        onClick = function()
            if SaveFilesModule.loadedFile.stats.highestBoxTier < SHOP_CONSTANTS.BLACK_MARKET_BUYING_REQUIREMENT then return end

            ScreenTransitionModule:transition({
                callback = function()
                    UISceneHandlerModule:switch("blackMarket")
                end
            })
        end
    })

    table.insert(scene._objects, blackMarketButton)
end

local function setupSacrificeButton(scene)
    sacrificeButtonHitbox = RenderModule:createElement(SceneData.sacrificeButtonHitbox)
    table.insert(scene._elements, sacrificeButtonHitbox)

    local sacrificeButton = UIButtonObjectModule:createButton({
        elements = {
            sacrificeButtonHitbox,
        },

        hitboxElement = sacrificeButtonHitbox,

        mouseButton = 1,
        onClick = function()
            if SaveFilesModule.loadedFile.stats.highestBoxTier < SHOP_CONSTANTS.SACRIFICE_UNLOCK_REQUIREMENT then return end

            ScreenTransitionModule:transition({
                callback = function()
                    UISceneHandlerModule:switch("sacrifice")
                end
            })
        end
    })

    table.insert(scene._objects, sacrificeButton)
end

local function lockedImageLogic(current, requirement, originalPath)
    if current >= requirement then
        return RenderModule.imageCache[originalPath]
    else
        return RenderModule.imageCache["assets/sprites/ui/buttonlocked74x74.png"]
    end
end

function Module:update()
    MusicHandlerModule:update()
    UISharedFunctions:update()

    if upgradeShopButtonHitbox and blackMarketButtonHitbox and sacrificeButtonHitbox then
        
        upgradeShopButtonHitbox.drawable = lockedImageLogic(
            SaveFilesModule.loadedFile.stats.highestBoxTier, 
            SHOP_CONSTANTS.UPGRADE_SHOP_UNLOCK_REQUIREMENT, 
            SceneData.upgradeShopButtonHitbox.spritePath
        )

        blackMarketButtonHitbox.drawable = lockedImageLogic(
            SaveFilesModule.loadedFile.stats.highestBoxTier, 
            SHOP_CONSTANTS.BLACK_MARKET_BUYING_REQUIREMENT, 
            SceneData.blackMarketButtonHitbox.spritePath
        )

        sacrificeButtonHitbox.drawable = lockedImageLogic(
            SaveFilesModule.loadedFile.stats.highestBoxTier, 
            SHOP_CONSTANTS.SACRIFICE_UNLOCK_REQUIREMENT, 
            SceneData.sacrificeButtonHitbox.spritePath
        )

    end

    if spawnButtonHitbox and spawnButtonLabel and spawnButton then
        spawnButton.cooldown = SaveFilesModule.loadedFile.stats.boxSpawnCooldown

        local time = (love.timer.getTime() - BoxFactoryModule.lastSpawned)
        local timeLeft = SaveFilesModule.loadedFile.stats.boxSpawnCooldown - time
        
        local onCooldown = time <= SaveFilesModule.loadedFile.stats.boxSpawnCooldown

        spawnButtonLabel.text =  (onCooldown and string.format("%.1f", timeLeft) .. "s" or SceneData.spawnButtonLabel.text)
    end
end

function Module:init(slot)
    --%note shitty preloading
    if not RenderModule.imageCache["assets/sprites/ui/buttonlocked74x74.png"] then
        local temp = RenderModule:createElement({
            type = "sprite",
            spritePath = "assets/sprites/ui/buttonlocked74x74.png"
        })

        temp:remove()
    end

    if slot then
        SaveFilesModule:loadFile(slot)

        SaveFilesModule.loadedFile.stats.playtimeAtSessionStart = SaveFilesModule.loadedFile.stats.playtime
    end

    BoxesObjectModule.renderBoxes = true

    MusicHandlerModule:stopTrack(MusicHandlerModule.playingTrack)

    UISharedFunctions:setupSidebarBackground(self)
    UISharedFunctions:setupSettingsButton(self)

    UISharedFunctions:setupSessionPlaytimeLabel(self)
    UISharedFunctions:setupCreditsLabel(self)

    setupUpgradeShopButton(self)
    setupBlackMarketButton(self)
    setupBackToMenuButton(self)
    setupSacrificeButton(self)
    setupSpawnButton(self)
    setupBackground(self)
end

return Module