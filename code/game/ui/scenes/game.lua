-- ~/code/game/ui/scenes/game.lua

local RenderElementModule = require("code.engine.render.element")
local RenderUtilsModule = require("code.engine.render.utils")

local SoundHandlerModule = require("code.engine.soundHandler")

local SavesFilesModule = require("code.engine.saves.files")

local string = require("code.engine.helpers.string")
local table = require("code.engine.helpers.table")

local MusicHandlerModule = require("code.game.musicHandler")
local UpgradeHandlerModule = require("code.game.upgradeHandler")

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

-- Every shop that's accessed from a locked/unlocked button on this scene.
-- Add a new shop here and both setup and the locked-sprite update pick it up.
local SHOP_BUTTONS = {
    {
        key = "upgradeShop",
        hitboxData = SceneData.upgradeShopButtonHitbox,
        requirement = SHOP_CONSTANTS.SHOPS.UPGRADE_SHOP.UNLOCK_REQUIREMENT,
        targetScene = "upgradeShop"
    },
    {
        key = "blackMarket",
        hitboxData = SceneData.blackMarketButtonHitbox,
        requirement = SHOP_CONSTANTS.SHOPS.BLACK_MARKET.UNLOCK_REQUIREMENT,
        targetScene = "blackMarket"
    },
    {
        key = "sacrifice",
        hitboxData = SceneData.sacrificeButtonHitbox,
        requirement = SHOP_CONSTANTS.SHOPS.SACRIFICIAL_GROUNDS.UNLOCK_REQUIREMENT,
        targetScene = "sacrificialGrounds"
    }
}

-- Populated in _setupShopButton, read back in Update() to refresh locked sprites.
local shopButtonHitboxes = {}

function Module:Clean()
    for _, element in pairs(self._elements) do
        element:Remove()
    end

    for _, button in pairs(self._objects) do
        button:Remove()
    end

    self._elements = {}
    self._objects = {}

    if not backButtonClicked and SavesFilesModule.loadedFile then
        SavesFilesModule:SaveFile(SavesFilesModule.loadedFile)
    elseif backButtonClicked then
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
                    SavesFilesModule:UnloadFile(SavesFilesModule.loadedFile)
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
        local enabled = BoxFactoryModule.autoSpawnEnabled

        autoSpawnButtonLabel.text =
            "Auto Spawn ("
            .. (enabled and "ON" or "OFF")
            .. ")"

        autoSpawnButtonHitbox.color =
            RenderUtilsModule.CreateColorFromTable(
                enabled
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
            BoxFactoryModule.autoSpawnEnabled = not BoxFactoryModule.autoSpawnEnabled
            _set()
        end
    })

    table.insert(self._objects, autoSpawnButton)
end

-- Creates one locked/unlocked shop-navigation button from a SHOP_BUTTONS entry.
-- Below the requirement it just plays the "not allowed" sound; at or above it,
-- transitions to the shop's own scene.
local function _setupShopButton(self, shopButton)
    local hitbox = UISharedFunctions:CreateElement(shopButton.hitboxData, self)
    shopButtonHitboxes[shopButton.key] = hitbox

    local button = UIButtonObjectModule.new({
        elements = { hitbox },
        hitboxElement = hitbox,

        mouseButton = 1,

        onClick = function()
            if SavesFilesModule:Get("stats.highestBoxTier")
                < shopButton.requirement
            then
                _playNotAllowedSound()
                return
            end

            ScreenTransitionModule:Transition({
                callback = function()
                    UISceneHandlerModule:Switch(shopButton.targetScene)
                end
            })
        end
    })

    table.insert(self._objects, button)
end

local function _setupShopButtons(self)
    shopButtonHitboxes = {}

    for _, shopButton in pairs(SHOP_BUTTONS) do
        _setupShopButton(self, shopButton)
    end
end

local function _lockedImageLogic(current, requirement, originalPath)
    return (current >= requirement and originalPath or "assets/sprites/ui/buttons/buttonlocked74x74.png")
end

function Module:Update()
    MusicHandlerModule:Update()
    UISharedFunctions:Update()

    for _, shopButton in pairs(SHOP_BUTTONS) do
        local hitbox = shopButtonHitboxes[shopButton.key]
        if not hitbox then goto continue end

        hitbox:ChangeSprite(_lockedImageLogic(
            SavesFilesModule:Get("stats.highestBoxTier"),
            shopButton.requirement,
            shopButton.hitboxData.spritePath
        ))

        :: continue ::
    end

    if spawnButtonHitbox and spawnButtonLabel and spawnButton then
        local cooldown = SavesFilesModule:Get("stats.upgradeable.spawnCooldown")
        spawnButton.cooldown = cooldown

        local time = love.timer.getTime() - BoxFactoryModule.lastSpawned
        local timeLeft = cooldown - time

        local onCooldown = time <= cooldown
        spawnButtonLabel.text = (onCooldown and string.format("%.1f", timeLeft) .. "s" or SceneData.spawnButtonLabel.text)
    end
end

function Module:Init(slot)
    if slot then
        SavesFilesModule:LoadFile(slot)
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

    if SavesFilesModule:Get("stats.upgradeable.autoSpawnUnlocked") then
        _setupAutoSpawnButton(self)
    end

    _setupShopButtons(self)
    _setupBackToMenuButton(self)
    _setupSpawnButton(self)
end

return Module