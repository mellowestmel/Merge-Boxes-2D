-- ~/code/game/ui/scenes/game.lua

local RenderElementModule = require("code.engine.render.element")
local RenderUtilsModule = require("code.engine.render.utils")

local SoundHandlerModule = require("code.engine.soundHandler")

local SaveFilesModule = require("code.engine.saves.files")

local string = require("code.engine.helpers.string")
local table = require("code.engine.helpers.table")

local MusicHandlerModule = require("code.game.musicHandler")
local UpgradeHandlerModule = require("code.game.shop.upgrade.handler")

local BoxesObjectModule = require("code.game.boxes.object")
local BoxFactoryModule = require("code.game.boxes.factory")

local SHOP_CONSTANTS = require("code.game.shop.constants")
local CONSTANTS = require("code.game.ui.constants")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")

local UIButtonObjectModule = require("code.game.ui.objects.button")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")
local ScreenFlashModule = require("code.game.vfx.screenFlash")

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

local autoSpawnEnabled = false

function Module:Clean()
    for _, element in pairs(self._elements) do
        element:Remove()
    end

    for _, button in pairs(self._objects) do
        button:Remove()
    end

    self._elements = {}
    self._objects = {}

    if not backButtonClicked then
        SaveFilesModule:SaveFile(SaveFilesModule.loadedFile)
    else
        BoxesObjectModule:ClearBoxes()
    end

    ScreenFlashModule:Stop()
    UISharedFunctions:CleanUpdates()
end

local function _playNotAllowedSound()
    local notAllowedSound = SoundHandlerModule.new({
        soundPath = "assets/sounds/ui/notallowed.wav"
    })

    if notAllowedSound then
        notAllowedSound:Play() notAllowedSound:Remove()
    end
end

local function _setupBackToMenuButton(self)
    backButtonClicked = false

    local backToMenuButtonHitbox = UISharedFunctions:CreateElement(
        SharedData.backToMenuButtonHitbox,
        self
    )

    local backToMenuButton = UIButtonObjectModule.new({
        elements = {
            backToMenuButtonHitbox,
        },

        hitboxElement = backToMenuButtonHitbox,

        mouseButton = 1,

        onClick = function()
            backButtonClicked = true

            ScreenTransitionModule:Transition({
                callback = function()
                    SaveFilesModule:UnloadFile(SaveFilesModule.loadedFile)
                    UISceneHandlerModule:Switch("saveFiles")
                end
            })
        end
    })

    table.insert(self._objects, backToMenuButton)
end

local function _setupSpawnButton(self)
    spawnButtonHitbox = UISharedFunctions:CreateElement(
        SceneData.spawnButtonHitbox,
        self
    )

    spawnButtonLabel = UISharedFunctions:CreateElement(
        SceneData.spawnButtonLabel,
        self
    )

    spawnButton = UIButtonObjectModule.new({
        elements = {
            spawnButtonHitbox,
            spawnButtonLabel
        },

        hitboxElement = spawnButtonHitbox,

        mouseButton = 1,

        onClick = function()
            BoxFactoryModule:Spawn()
        end
    })

    table.insert(self._objects, spawnButton)
end

local function _setupAutoSpawnButton(self)
    local autoSpawnButtonHitbox = UISharedFunctions:CreateElement(
        SceneData.autoSpawnButtonHitbox,
        self
    )

    local autoSpawnButtonLabel = UISharedFunctions:CreateElement(
        SceneData.autoSpawnButtonLabel,
        self
    )

    local function _set()
        autoSpawnButtonLabel.text =
            "Auto Spawn ("
            .. (autoSpawnEnabled and "ON" or "OFF")
            .. ")"

        autoSpawnButtonHitbox.color =
            RenderUtilsModule.CreateColorFromTable(
                autoSpawnEnabled
                    and CONSTANTS.COLOR_GREEN
                    or CONSTANTS.COLOR_RED
            )
    end

    _set()

    local autoSpawnButton = UIButtonObjectModule.new({
        elements = {
            autoSpawnButtonHitbox,
            autoSpawnButtonLabel
        },

        hitboxElement = autoSpawnButtonHitbox,

        mouseButton = 1,

        onClick = function()
            autoSpawnEnabled = not autoSpawnEnabled
            _set()
        end
    })

    table.insert(self._objects, autoSpawnButton)
end

local function _setupUpgradeShopButton(self)
    upgradeShopButtonHitbox = UISharedFunctions:CreateElement(
        SceneData.upgradeShopButtonHitbox,
        self
    )

    local upgradeShopButton = UIButtonObjectModule.new({
        elements = {
            upgradeShopButtonHitbox,
        },

        hitboxElement = upgradeShopButtonHitbox,

        mouseButton = 1,

        onClick = function()
            if SaveFilesModule.loadedFile.stats.highestBoxTier
                < SHOP_CONSTANTS.SHOPS.UPGRADE_SHOP.UNLOCK_REQUIREMENT
            then
                _playNotAllowedSound()
                return
            end

            ScreenTransitionModule:Transition({
                callback = function()
                    UISceneHandlerModule:Switch("upgradeShop")
                end
            })
        end
    })

    table.insert(self._objects, upgradeShopButton)
end

local function _setupBlackMarketButton(self)
    blackMarketButtonHitbox = UISharedFunctions:CreateElement(
        SceneData.blackMarketButtonHitbox,
        self
    )

    local blackMarketButton = UIButtonObjectModule.new({
        elements = {
            blackMarketButtonHitbox,
        },

        hitboxElement = blackMarketButtonHitbox,

        mouseButton = 1,

        onClick = function()
            if SaveFilesModule.loadedFile.stats.highestBoxTier
                < SHOP_CONSTANTS.SHOPS.BLACK_MARKET.UNLOCK_REQUIREMENT
            then
                _playNotAllowedSound()
                return
            end

            ScreenTransitionModule:Transition({
                callback = function()
                    UISceneHandlerModule:Switch("blackMarket")
                end
            })
        end
    })

    table.insert(self._objects, blackMarketButton)
end

local function _setupSacrificeButton(self)
    sacrificeButtonHitbox = UISharedFunctions:CreateElement(
        SceneData.sacrificeButtonHitbox,
        self
    )

    local sacrificeButton = UIButtonObjectModule.new({
        elements = {
            sacrificeButtonHitbox,
        },

        hitboxElement = sacrificeButtonHitbox,

        mouseButton = 1,

        onClick = function()
            if SaveFilesModule.loadedFile.stats.highestBoxTier
                < SHOP_CONSTANTS.SHOPS.SACRIFICIAL_GROUNDS.UNLOCK_REQUIREMENT
            then
                _playNotAllowedSound()
                return
            end

            ScreenTransitionModule:Transition({
                callback = function()
                    UISceneHandlerModule:Switch("sacrificialGrounds")
                end
            })
        end
    })

    table.insert(self._objects, sacrificeButton)
end

local function _lockedImageLogic(current, requirement, originalPath)
    if current >= requirement then
        return RenderElementModule.imageCache[originalPath]
    else
        return RenderElementModule.imageCache[
            "assets/sprites/ui/buttons/buttonlocked74x74.png"
        ]
    end
end

function Module:Update()
    MusicHandlerModule:Update()
    UISharedFunctions:Update()

    if upgradeShopButtonHitbox
        and blackMarketButtonHitbox
        and sacrificeButtonHitbox
    then
        upgradeShopButtonHitbox.drawable = _lockedImageLogic(
            SaveFilesModule.loadedFile.stats.highestBoxTier,
            SHOP_CONSTANTS.SHOPS.UPGRADE_SHOP.UNLOCK_REQUIREMENT,
            SceneData.upgradeShopButtonHitbox.spritePath
        )

        blackMarketButtonHitbox.drawable = _lockedImageLogic(
            SaveFilesModule.loadedFile.stats.highestBoxTier,
            SHOP_CONSTANTS.SHOPS.BLACK_MARKET.UNLOCK_REQUIREMENT,
            SceneData.blackMarketButtonHitbox.spritePath
        )

        sacrificeButtonHitbox.drawable = _lockedImageLogic(
            SaveFilesModule.loadedFile.stats.highestBoxTier,
            SHOP_CONSTANTS.SHOPS.SACRIFICIAL_GROUNDS.UNLOCK_REQUIREMENT,
            SceneData.sacrificeButtonHitbox.spritePath
        )
    end

    if spawnButtonHitbox
        and spawnButtonLabel
        and spawnButton
    then
        local cooldown = BoxFactoryModule:GetSpawnCooldown()
        spawnButton.cooldown = cooldown

        local time = love.timer.getTime() - BoxFactoryModule.lastSpawned
        local timeLeft = cooldown - time

        local onCooldown = time <= cooldown

        spawnButtonLabel.text =
            onCooldown
                and string.format("%.1f", timeLeft) .. "s"
                or SceneData.spawnButtonLabel.text

        if not onCooldown
            and UpgradeHandlerModule:GetEffect("autoSpawn")
            and autoSpawnEnabled
        then
            spawnButton:MousePressed(
                spawnButtonHitbox.x,
                spawnButtonHitbox.y,
                1
            )
        end
    end
end

function Module:Init(slot)
    --%note shitty preloading
    if not RenderElementModule.imageCache[
        "assets/sprites/ui/buttons/buttonlocked74x74.png"
    ] then
        local temp = RenderElementModule.new({
            type = "sprite",
            spritePath = "assets/sprites/ui/buttons/buttonlocked74x74.png"
        })

        temp:Remove()
    end

    if slot then
        SaveFilesModule:LoadFile(slot)

        SaveFilesModule.loadedFile.stats.playtimeAtSessionStart =
            SaveFilesModule.loadedFile.stats.playtime
    end

    BoxesObjectModule.renderBoxes = true

    MusicHandlerModule:StopTrack(MusicHandlerModule.playingTrack)

    UISharedFunctions:SetupSidebarBackground(self)
    UISharedFunctions:SetupSettingsButton(self)

    UISharedFunctions:SetupSessionPlaytimeLabel(self)
    UISharedFunctions:SetupCurrencyLabels(self)

    UISharedFunctions:CreateElement(
        SceneData.playAreaBackground,
        self
    )

    if UpgradeHandlerModule:GetEffect("autoSpawn") then
        _setupAutoSpawnButton(self)
    end

    _setupUpgradeShopButton(self)
    _setupBlackMarketButton(self)
    _setupBackToMenuButton(self)
    _setupSacrificeButton(self)
    _setupSpawnButton(self)
end

return Module