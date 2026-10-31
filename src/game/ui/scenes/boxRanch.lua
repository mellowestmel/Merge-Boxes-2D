local SavesFilesModule = require("src.engine.saves.files")

local LocalizationHandlerModule = require("src.engine.localizationHandler")
local MusicHandlerModule = require("src.game.musicHandler")

local BoxesObjectModule = require("src.game.boxes.object")
local BoxFactoryModule = require("src.game.boxes.factory")

local COMMON_VALUES = require("src.data.ui.commonValues")

local UISceneHandlerModule = require("src.game.ui.sceneHandler")
local UISharedFunctions = require("src.game.ui.shared")
local UIObjectHelperModule = require("src.game.ui.helpers.object")
local UISceneBase = require("src.game.ui.helpers.scene")

local ScreenFlashModule = require("src.game.vfx.screenFlash")

local SceneData = require("src.data.ui.scenes.boxRanch")

local Module = UISceneBase.new("boxRanch")

local spawnButton
local spawnButtonLabel

local shopButtonHitboxes = {}

local function _setupSpawnButton(self)
    local _

    spawnButton, _, spawnButtonLabel = UIObjectHelperModule.CreateElementButton(
        self,
        SceneData.spawnButtonHitbox,
        SceneData.spawnButtonLabel,
        function()
            BoxFactoryModule:Spawn()
        end
    )
end

local function _setupAutoSpawnButton(self)
    local _, hitbox, label

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

    _, hitbox, label = UIObjectHelperModule.CreateElementButton(
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

    for _, shopButton in ipairs(CONSTANTS.UI.BOX_RANCH.SHOP_BUTTONS) do
        local _, hitbox = UIObjectHelperModule.CreateElementButton(
            self,
            SceneData[shopButton.hitboxKey],
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

    for _, shopButton in ipairs(CONSTANTS.UI.BOX_RANCH.SHOP_BUTTONS) do
        local hitbox = shopButtonHitboxes[shopButton.key]

        if hitbox then
            hitbox:ChangeSprite(
                highestBoxTier < shopButton.requirement
                    and CONSTANTS.UI.BOX_RANCH.LOCKED_SHOP_BUTTON_SPRITE
                    or SceneData[shopButton.hitboxKey].spritePath
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
