-- ~/code/game/ui/scenes/boxRanch.lua

local SavesFilesModule = require("code.engine.saves.files")

local LocalizationHandlerModule = require("code.engine.localizationHandler")
local MusicHandlerModule = require("code.game.musicHandler")

local BoxesObjectModule = require("code.game.boxes.object")
local BoxFactoryModule = require("code.game.boxes.factory")

local COMMON_VALUES = require("code.data.ui.commonValues")
local CONSTANTS = require("code.data.constants")

local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")
local UIObjectHelperModule = require("code.game.ui.helpers.object")
local UISceneBase = require("code.game.ui.helpers.scene")

local ScreenFlashModule = require("code.game.vfx.screenFlash")

local SceneData = require("code.data.ui.scenes.boxRanch")

local Module = UISceneBase.new("boxRanch")

local LOCKED_SHOP_BUTTON_SPRITE = "assets/sprites/ui/buttons/buttonlocked74x74.png"

local spawnButton
local spawnButtonLabel

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

local function _setupSpawnButton(self)
    local hitbox

    spawnButton, hitbox, spawnButtonLabel = UIObjectHelperModule.CreateElementButton(
        self,
        SceneData.spawnButtonHitbox,
        SceneData.spawnButtonLabel,
        function()
            BoxFactoryModule:Spawn()
        end
    )
end

local function _setupAutoSpawnButton(self)
    local button, hitbox, label

    local function _refresh()
        local enabled = BoxFactoryModule.autoSpawnEnabled

        label.text = LocalizationHandlerModule.Get(
            "boxRanch.autoSpawn",
            {
                state = LocalizationHandlerModule.Get(enabled and "boxRanch.on" or "boxRanch.off")
            }
        )

        hitbox:ChangeColor(
            enabled and COMMON_VALUES.COLOR_GREEN or COMMON_VALUES.COLOR_RED
        )
    end

    button, hitbox, label = UIObjectHelperModule.CreateElementButton(
        self,
        SceneData.autoSpawnButtonHitbox,
        SceneData.autoSpawnButtonLabel,
        function()
            BoxFactoryModule.autoSpawnEnabled = not BoxFactoryModule.autoSpawnEnabled

            _refresh()
        end
    )

    _refresh()
end

local function _setupShopButtons(self)
    shopButtonHitboxes = {}

    for _, shopButton in ipairs(SHOP_BUTTONS) do
        local _, hitbox = UIObjectHelperModule.CreateElementButton(
            self,
            shopButton.hitboxData,
            nil,
            function()
                if SavesFilesModule:Get("tracking.highestBoxTier") < shopButton.requirement then
                    UISharedFunctions:PlayNotAllowedSound()
                    return
                end

                UISceneHandlerModule:TransitionTo(shopButton.targetScene)
            end
        )

        shopButtonHitboxes[shopButton.key] = hitbox
    end
end

-- Shows the locked sprite on shop buttons the player hasn't unlocked yet.
local function _updateShopButtons()
    local highestBoxTier = SavesFilesModule:Get("tracking.highestBoxTier")

    for _, shopButton in ipairs(SHOP_BUTTONS) do
        local hitbox = shopButtonHitboxes[shopButton.key]

        if hitbox then
            hitbox:ChangeSprite(
                highestBoxTier < shopButton.requirement
                    and LOCKED_SHOP_BUTTON_SPRITE
                    or shopButton.hitboxData.spritePath
            )
        end
    end
end

local function _updateSpawnButton()
    if not spawnButton or not spawnButtonLabel then return end

    local cooldown = SavesFilesModule:Get("stats.upgradeable.spawnCooldown")
    local timeLeft = cooldown - (love.timer.getTime() - BoxFactoryModule.lastSpawned)

    spawnButton.cooldown = cooldown

    spawnButtonLabel.text = timeLeft >= 0
        and LocalizationHandlerModule.Get(
            "boxRanch.spawnCooldown",
            { time = string.format("%.1f", timeLeft) }
        )
        or LocalizationHandlerModule.Get("boxRanch.spawnBox")
end

-- The back-to-menu button unloads the file (which saves it) before this runs,
-- so only save here when the file is still loaded (e.g. going to settings).
function Module:OnClean()
    if SavesFilesModule.loadedFile then
        SavesFilesModule:SaveFile(SavesFilesModule.loadedFile)
    end

    spawnButton = nil
    spawnButtonLabel = nil

    shopButtonHitboxes = {}

    ScreenFlashModule:Stop()
end

function Module:OnUpdate()
    MusicHandlerModule:Update()

    _updateShopButtons()
    _updateSpawnButton()
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
    UISharedFunctions:SetupBackToMenuButton(self)
    _setupSpawnButton(self)
end

return Module