-- ~/code/game/ui/scenes/boxRanch.lua

local SoundHandlerModule = require("code.engine.soundHandler")
local SavesFilesModule = require("code.engine.saves.files")

local string = require("code.engine.helpers.string")

local MusicHandlerModule = require("code.game.musicHandler")
local BoxesObjectModule = require("code.game.boxes.object")
local BoxFactoryModule = require("code.game.boxes.factory")

local COMMON_VALUES = require("code.data.ui.commonValues")
local CONSTANTS = require("code.data.constants")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")
local UIObjectHelperModule = require("code.game.ui.helpers.object")

local ScreenTransitionModule = require("code.game.vfx.screenTransition")
local ScreenFlashModule = require("code.game.vfx.screenFlash")

local SharedData = require("code.data.ui.scenes.shared")
local SceneData = require("code.data.ui.scenes.boxRanch")

local Module = {}
Module._elements = {}
Module._objects = {}
Module.name = "boxRanch"

local spawnButtonHitbox
local spawnButtonLabel
local spawnButton

local backButtonClicked = false

local SHOP_BUTTONS = {
    {
        key = "upgradeShop",

        hitboxData = SceneData.upgradeShopButtonHitbox,
        requirement = CONSTANTS.SHOP.UPGRADE_SHOP.UNLOCK_REQUIREMENT,

        targetScene = "upgradeShop"
    },
    {
        key = "blackMarket",

        hitboxData = SceneData.blackMarketButtonHitbox,
        requirement = CONSTANTS.SHOP.BLACK_MARKET.UNLOCK_REQUIREMENT,

        targetScene = "blackMarket"
    },
    {
        key = "sacrifice",

        hitboxData = SceneData.sacrificeButtonHitbox,
        requirement = CONSTANTS.SHOP.SACRIFICIAL_GROUNDS.UNLOCK_REQUIREMENT,

        targetScene = "sacrificialGrounds"
    }
}

local shopButtonHitboxes = {}

local function _playNotAllowedSound()
    SoundHandlerModule.new({
        soundPath = "assets/sounds/ui/notallowed.wav"
    }):Play(true)
end

local function _setupBackToMenuButton(self)
    backButtonClicked = false

    local hitbox = UIObjectHelperModule.CreateElement(
        SharedData.backToMenuButtonHitbox,
        self
    )

    UIObjectHelperModule.CreateButton(
        self,

        {hitbox},
        hitbox,

        function()
            backButtonClicked = true

            ScreenTransitionModule:Transition({
                callback = function()
                    SavesFilesModule:UnloadFile(SavesFilesModule.loadedFile)
                    UISceneHandlerModule:Switch("saveFiles")
                end
            })
        end
    )
end

local function _setupSpawnButton(self)
    spawnButtonHitbox = UIObjectHelperModule.CreateElement(
        SceneData.spawnButtonHitbox,
        self
    )

    spawnButtonLabel = UIObjectHelperModule.CreateElement(
        SceneData.spawnButtonLabel,
        self
    )

    spawnButton = UIObjectHelperModule.CreateButton(
        self,

        {
            spawnButtonHitbox,
            spawnButtonLabel
        },
        spawnButtonHitbox,

        function()
            BoxFactoryModule:Spawn()
        end
    )
end

local function _setupAutoSpawnButton(self)
    local hitbox = UIObjectHelperModule.CreateElement(
        SceneData.autoSpawnButtonHitbox,
        self
    )

    local label = UIObjectHelperModule.CreateElement(
        SceneData.autoSpawnButtonLabel,
        self
    )

    local function __update()
        local enabled = BoxFactoryModule.autoSpawnEnabled

        label.text = "Auto Spawn (" .. (enabled and "ON" or "OFF") .. ")"
        hitbox:ChangeColor(
            enabled and COMMON_VALUES.COLOR_GREEN or COMMON_VALUES.COLOR_RED
        )
    end

    __update()

    UIObjectHelperModule.CreateButton(
        self,

        {hitbox, label},
        hitbox,

        function()
            BoxFactoryModule.autoSpawnEnabled =
                not BoxFactoryModule.autoSpawnEnabled

            __update()
        end
    )
end

local function _setupShopButton(self, shopButton)
    local hitbox = UIObjectHelperModule.CreateElement(
        shopButton.hitboxData,
        self
    )

    shopButtonHitboxes[shopButton.key] = hitbox

    UIObjectHelperModule.CreateButton(
        self,

        {hitbox},
        hitbox,

        function()
            local highestBoxTier = SavesFilesModule:Get("tracking.highestBoxTier")

            if highestBoxTier < shopButton.requirement then
                _playNotAllowedSound()
                return
            end

            ScreenTransitionModule:Transition({
                callback = function()
                    UISceneHandlerModule:Switch(shopButton.targetScene)
                end
            })
        end
    )
end

local function _setupShopButtons(self)
    shopButtonHitboxes = {}

    for _, shopButton in ipairs(SHOP_BUTTONS) do
        _setupShopButton(self, shopButton)
    end
end

local function _updateShopButton(shopButton, highestBoxTier)
    local hitbox = shopButtonHitboxes[shopButton.key]

    if not hitbox then
        return
    end

    local spritePath = shopButton.hitboxData.spritePath

    if highestBoxTier < shopButton.requirement then
        spritePath = "assets/sprites/ui/buttons/buttonlocked74x74.png"
    end

    hitbox:ChangeSprite(spritePath)
end

function Module:Clean()
    UIObjectHelperModule.CleanScene(self)

    if not backButtonClicked and SavesFilesModule.loadedFile then
        SavesFilesModule:SaveFile(SavesFilesModule.loadedFile)
    elseif backButtonClicked then
        BoxesObjectModule:ClearBoxes()
    end

    spawnButtonHitbox = nil
    spawnButtonLabel = nil
    spawnButton = nil

    shopButtonHitboxes = {}

    ScreenFlashModule:Stop()
    UISharedFunctions:Clean()
end

function Module:Update()
    MusicHandlerModule:Update()
    UISharedFunctions:Update()

    local highestBoxTier = SavesFilesModule:Get("tracking.highestBoxTier")

    for _, shopButton in ipairs(SHOP_BUTTONS) do
        _updateShopButton(shopButton, highestBoxTier)
    end

    if not spawnButtonHitbox or not spawnButtonLabel or not spawnButton then
        return
    end

    local cooldown = SavesFilesModule:Get("stats.upgradeable.spawnCooldown")

    spawnButton.cooldown = cooldown

    local time = love.timer.getTime() - BoxFactoryModule.lastSpawned
    local timeLeft = cooldown - time

    if time <= cooldown then
        spawnButtonLabel.text = string.format("%.1fs", timeLeft)
    else
        spawnButtonLabel.text = SceneData.spawnButtonLabel.text
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

    UIObjectHelperModule.CreateElement(
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