-- ~/code/game/ui/scenes/upgradeShop.lua

local RenderUtilsModule = require("code.engine.render.utils")

local SoundHandlerModule = require("code.engine.soundHandler")

local string = require("code.engine.helpers.string")

local MusicHandlerModule = require("code.game.musicHandler")
local UpgradeHandlerModule = require("code.game.shop.upgrade.handler")

local PurchaseUpgradeHandlerModule = require("code.game.shop.upgrade.purchase")

local BoxesObjectModule = require("code.game.boxes.object")

local UISharedFunctions = require("code.game.ui.shared")
local UIButtonObjectModule = require("code.game.ui.objects.button")
local UIScrollingFrameObjectModule = require("code.game.ui.objects.scrollingFrame")
local UILayoutHelperModule = require("code.game.ui.helpers.layout")

local UILayoutData = require("code.data.ui.layout")

local CONSTANTS = require("code.game.ui.constants")
local SHOP_CONSTANTS = require("code.game.shop.constants")

local SceneData = require("code.data.ui.scenes.upgradeShop")
local ShopID = SHOP_CONSTANTS.SHOPS.UPGRADE_SHOP.ID

local Module = {}
Module._elements = {}
Module._objects = {}
Module._upgradeButtons = {}
Module.name = "upgradeShop"

function Module:Clean()
    for _, element in pairs(self._elements) do
        element:Remove()
    end

    for _, object in pairs(self._objects) do
        object:Remove()
    end

    self._elements = {}
    self._objects = {}
    self._upgradeButtons = {}

    UISharedFunctions:CleanUpdates()
end

local function _setupTheBirbsWord(self)
    local birb = UISharedFunctions:CreateElement(
        SceneData.theBirbsWord,
        self
    )

    local birbButton = UIButtonObjectModule.new({
        elements = {birb},

        hitboxElement = birb,
        mouseButton = 1,

        onClick = function()
            local birbSound = SoundHandlerModule.new({
                soundPath = "assets/sounds/birb.wav"
            })

            if birbSound then
                birbSound:Play() birbSound:Remove()
            end
        end
    })

    table.insert(self._objects, birbButton)
end

local function _getUpgrades()
    return UpgradeHandlerModule:GetUpgradesByShop(
        SHOP_CONSTANTS.SHOPS.UPGRADE_SHOP.ID
    )
end

local function _createStackIndicators(
    self,
    buttonConfig,
    maximumStacks,
    currentStacks
)
    local indicators = {}
    local itemSpacing = CONSTANTS.MEDIUM_PADDING

    local startPositionX =
        buttonConfig.x -
        (((maximumStacks - 1) * itemSpacing) / 2)

    for stackIndex = 1, maximumStacks do
        local indicator = UISharedFunctions:CreateElement(
            SceneData.upgradeStackCounter,
            self
        )

        indicator.x = UILayoutHelperModule.GetHorizontalStackX(
            startPositionX,
            stackIndex,
            itemSpacing
        )

        indicator.y = buttonConfig.indicatorY

        indicator.color =
            (stackIndex <= currentStacks)
            and self._yellowColor
            or self._darkColor

        table.insert(buttonConfig.children, indicator)
        table.insert(indicators, indicator)
    end

    return indicators
end

local function _createUpgradeButton(self, buttonConfig)
    local upgrade = UpgradeHandlerModule:GetUpgrade(buttonConfig.id)

    -- Hitbox Background
    local hitbox = UISharedFunctions:CreateElement(
        SceneData.upgradeBuyHitbox,
        self
    )

    hitbox.x, hitbox.y = buttonConfig.x, buttonConfig.y

    table.insert(buttonConfig.children, hitbox)

    local halfHeight =
        hitbox:GetHeight() *
        UILayoutData.upgradeShop.textOffsetRatio

    buttonConfig.indicatorY = buttonConfig.y + halfHeight

    -- Upgrade Name Label
    local nameLabel = UISharedFunctions:CreateElement(
        SceneData.upgradeName,
        self
    )

    nameLabel.text = upgrade.name or buttonConfig.id
    nameLabel.x, nameLabel.y =
        buttonConfig.x,
        buttonConfig.y - halfHeight

    table.insert(buttonConfig.children, nameLabel)

    -- Upgrade Cost Label
    local currentStacks =
        UpgradeHandlerModule:GetStacks(buttonConfig.id)

    local maximumStacks = upgrade.maxStacks or 1

    local isMaxedOut =
        UpgradeHandlerModule:IsMaxed(buttonConfig.id)

    local upgradeCost =
        PurchaseUpgradeHandlerModule:GetCost(buttonConfig.id)

    local formattedCostText =
        isMaxedOut
        and "MAX"
        or string.format(
            "%s Credits",
            string.formatNumber(upgradeCost)
        )

    local costLabel = UISharedFunctions:CreateElement(
        SceneData.upgradeCost,
        self
    )

    costLabel.text = formattedCostText
    costLabel.x, costLabel.y =
        buttonConfig.x,
        buttonConfig.y

    table.insert(buttonConfig.children, costLabel)

    -- Stack Indicators
    local indicators = _createStackIndicators(
        self,
        buttonConfig,
        maximumStacks,
        currentStacks
    )

    -- Button Hitbox Assembly
    local buttonElements = {
        hitbox,
        nameLabel,
        costLabel
    }

    for _, indicator in pairs(indicators) do
        table.insert(buttonElements, indicator)
    end

    local buyButton = UIButtonObjectModule.new({
        elements = buttonElements,

        hitboxElement = hitbox,
        mouseButton = 1,

        onClick = function()
            local success =
                PurchaseUpgradeHandlerModule:Buy(
                    buttonConfig.id,
                    ShopID
                )

            local sound = SoundHandlerModule.new({
                soundPath =
                    success
                    and "assets/sounds/shop/transaction.wav"
                    or "assets/sounds/ui/notallowed.wav"
            })

            if sound then
                sound:Play() sound:Remove()
            end
        end
    })

    table.insert(self._objects, buyButton)

    table.insert(self._upgradeButtons, {
        id = buttonConfig.id,
        costLabel = costLabel,
        indicators = indicators,
        maxStacks = maximumStacks
    })
end

local function _setupUpgradesScrollingFrame(self)
    self._yellowColor =
        RenderUtilsModule.CreateColorFromTable(
            CONSTANTS.COLOR_YELLOW
        )

    self._darkColor =
        RenderUtilsModule.CreateColorFromTable(
            CONSTANTS.COLOR_DARK
        )

    local frameTrack = UISharedFunctions:CreateElement(
        SceneData.upgradesFrameBackground,
        self
    )

    local scrollWheel = UISharedFunctions:CreateElement(
        SceneData.upgradesFrameScrollWheel,
        self
    )

    local childElements = {}

    local startPositionY =
        frameTrack.y -
        (frameTrack:GetHeight() / 2) +
        CONSTANTS.LARGE_PADDING

    for index, upgradeId in pairs(_getUpgrades()) do
        _createUpgradeButton(self, {
            id = upgradeId,

            x = frameTrack.x,

            y = UILayoutHelperModule.GetVerticalStackY(
                startPositionY,
                index,
                CONSTANTS.BUTTON_VERTICAL_GAP
            ),

            children = childElements
        })
    end

    local scrollingFrame = UIScrollingFrameObjectModule.new({
        hitboxElement = frameTrack,
        scrollTrackElement = frameTrack,
        scrollBarElement = scrollWheel,

        elements = childElements,
        padding = CONSTANTS.LARGE_PADDING
    })

    table.insert(self._objects, scrollingFrame)
end

function Module:Update()
    UISharedFunctions:Update()

    for _, upgradeButton in pairs(self._upgradeButtons) do
        local currentStacks =
            UpgradeHandlerModule:GetStacks(
                upgradeButton.id
            )

        local isMaxedOut =
            UpgradeHandlerModule:IsMaxed(
                upgradeButton.id
            )

        local upgradeCost =
            PurchaseUpgradeHandlerModule:GetCost(
                upgradeButton.id
            )

        upgradeButton.costLabel.text =
            isMaxedOut
            and "MAX"
            or string.format(
                "%s Credits",
                string.formatNumber(upgradeCost)
            )

        for stackIndex, indicator in pairs(
            upgradeButton.indicators
        ) do
            indicator.color =
                (stackIndex <= currentStacks)
                and self._yellowColor
                or self._darkColor
        end
    end
end

function Module:Init()
    MusicHandlerModule:PlayTrack("upgradeShop")

    BoxesObjectModule.renderBoxes = false

    UISharedFunctions:SetupSidebarBackground(self)
    UISharedFunctions:SetupSettingsButton(self)
    UISharedFunctions:SetupShopBackButton(self)

    UISharedFunctions:SetupSessionPlaytimeLabel(self)
    UISharedFunctions:SetupCurrencyLabels(self)

    UISharedFunctions:SetupBackToMenuButton(self)

    UISharedFunctions:SetupBackground(self)

    _setupTheBirbsWord(self)
    _setupUpgradesScrollingFrame(self)
end

return Module