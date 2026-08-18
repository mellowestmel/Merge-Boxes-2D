-- ~/code/game/ui/scenes/upgradeShop.lua

local RenderElementModule = require("code.engine.render.element")
local SoundModule = require("code.engine.sound")

local string = require("code.engine.helpers.string")

local MusicHandlerModule = require("code.game.musicHandler")
local UpgradeHandlerModule = require("code.game.shop.upgrade.handler")

local PurchaseUpgradeHandlerModule = require("code.game.shop.upgrade.purchase")

local BoxesObjectModule = require("code.game.box.object")

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

local function setupBackground(self)
    local background = RenderElementModule.new(SceneData.background)
    table.insert(self._elements, background)
end

local function setupTheBirbsWord(self)
    local birb = RenderElementModule.new(SceneData.theBirbsWord)
    table.insert(self._elements, birb)

    local birbButton = UIButtonObjectModule.new({
        elements = { birb },

        hitboxElement = birb,
        mouseButton = 1,

        onClick = function()
            local birbSound = SoundModule:createSound({ soundPath = "assets/sounds/birb.wav" })
            if birbSound then
                birbSound:Play()
                birbSound:Remove()
            end
        end
    })

    table.insert(self._objects, birbButton)
end

local function getUpgrades()
    return UpgradeHandlerModule:getUpgradesByShop(SHOP_CONSTANTS.SHOPS.UPGRADE_SHOP.ID)
end

local function createStackIndicators(self, buttonConfig, maximumStacks, currentStacks)
    local indicators = {}
    local itemSpacing = CONSTANTS.MEDIUM_PADDING

    local startPositionX = buttonConfig.x - (((maximumStacks - 1) * itemSpacing) / 2)

    for stackIndex = 1, maximumStacks do
        local indicator = RenderElementModule.new(SceneData.upgradeStackCounter)

        indicator.x = UILayoutHelperModule.getHorizontalStackX(startPositionX, stackIndex, itemSpacing)
        indicator.y = buttonConfig.indicatorY

        indicator.color = (stackIndex <= currentStacks) and self._yellowColor or self._darkColor

        table.insert(self._elements, indicator)
        table.insert(buttonConfig.children, indicator)
        table.insert(indicators, indicator)
    end

    return indicators
end

local function createUpgradeButton(self, buttonConfig)
    local upgrade = UpgradeHandlerModule:getUpgrade(buttonConfig.id)

    -- Hitbox Background
    local hitbox = RenderElementModule.new(SceneData.upgradeBuyHitbox)
    hitbox.x, hitbox.y = buttonConfig.x, buttonConfig.y

    table.insert(self._elements, hitbox)
    table.insert(buttonConfig.children, hitbox)

    local halfHeight = hitbox:getHeight() * UILayoutData.upgradeShop.textOffsetRatio
    buttonConfig.indicatorY = buttonConfig.y + halfHeight

    -- Upgrade Name Label
    local nameLabel = RenderElementModule.new(SceneData.upgradeName)
    nameLabel.text = upgrade.name or buttonConfig.id
    nameLabel.x, nameLabel.y = buttonConfig.x, buttonConfig.y - halfHeight

    table.insert(self._elements, nameLabel)
    table.insert(buttonConfig.children, nameLabel)

    -- Upgrade Cost Label
    local currentStacks = UpgradeHandlerModule:getStacks(buttonConfig.id)
    local maximumStacks = upgrade.maxStacks or 1
    local isMaxedOut = UpgradeHandlerModule:isMaxed(buttonConfig.id)

    local upgradeCost = PurchaseUpgradeHandlerModule:getCost(buttonConfig.id)
    local formattedCostText = isMaxedOut and "MAX" or string.format("%s Credits", string.formatNumber(upgradeCost))

    local costLabel = RenderElementModule.new(SceneData.upgradeCost)
    costLabel.text = formattedCostText
    costLabel.x, costLabel.y = buttonConfig.x, buttonConfig.y

    table.insert(self._elements, costLabel)
    table.insert(buttonConfig.children, costLabel)

    -- Stack Indicators
    local indicators = createStackIndicators(self, buttonConfig, maximumStacks, currentStacks)

    -- Button Hitbox Assembly
    local buttonElements = { hitbox, nameLabel, costLabel }
    for _, indicator in ipairs(indicators) do
        table.insert(buttonElements, indicator)
    end

    local buyButton = UIButtonObjectModule.new({
        elements = buttonElements,

        hitboxElement = hitbox,
        mouseButton = 1,

        onClick = function()
            local success = PurchaseUpgradeHandlerModule:buy(buttonConfig.id, ShopID)
            local sound = SoundModule:createSound(
                {
                    soundPath = (
                        success and
                        "assets/sounds/shop/transaction.wav" or
                        "assets/sounds/ui/notallowed.wav"
                    )
                }
            )

            if sound then
                sound:Play()
                sound:Remove()
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

local function setupUpgradesScrollingFrame(self)
    self._yellowColor = RenderModule:createColorFromTable(CONSTANTS.COLOR_YELLOW)
    self._darkColor = RenderModule:createColorFromTable(CONSTANTS.COLOR_DARK)

    local frameTrack = RenderElementModule.new(SceneData.upgradesFrameBackground)
    local scrollWheel = RenderElementModule.new(SceneData.upgradesFrameScrollWheel)

    table.insert(self._elements, frameTrack)
    table.insert(self._elements, scrollWheel)

    local childElements = {}
    local startPositionY = frameTrack.y - (frameTrack:getHeight() / 2) + CONSTANTS.LARGE_PADDING

    for index, upgradeId in ipairs(getUpgrades()) do
        createUpgradeButton(self, {
            id = upgradeId,

            x = frameTrack.x,
            y = UILayoutHelperModule.getVerticalStackY(startPositionY, index, CONSTANTS.BUTTON_VERTICAL_GAP),

            children = childElements
        })
    end

    local scrollingFrame = UIScrollingFrameObjectModule:createScrollingFrame({
        hitboxElement = frameTrack,
        scrollTrackElement = frameTrack,
        scrollBarElement = scrollWheel,

        elements = childElements,
        padding = CONSTANTS.LARGE_PADDING
    })

    table.insert(self._objects, scrollingFrame)
end

function Module:Update(deltaTime)
    UISharedFunctions:Update()

    for _, upgradeButton in ipairs(self._upgradeButtons) do
        local currentStacks = UpgradeHandlerModule:getStacks(upgradeButton.id)
        local isMaxedOut = UpgradeHandlerModule:isMaxed(upgradeButton.id)

        local upgradeCost = PurchaseUpgradeHandlerModule:getCost(upgradeButton.id)
        upgradeButton.costLabel.text = isMaxedOut and "MAX" or string.format("%s Credits", string.formatNumber(upgradeCost))

        for stackIndex, indicator in ipairs(upgradeButton.indicators) do
            indicator.color = (stackIndex <= currentStacks) and self._yellowColor or self._darkColor
        end
    end
end

function Module:init()
    MusicHandlerModule:playTrack("upgradeShop")

    BoxesObjectModule.renderBoxes = false

    UISharedFunctions:setupSidebarBackground(self)
    UISharedFunctions:setupSettingsButton(self)
    UISharedFunctions:setupShopBackButton(self)

    UISharedFunctions:setupSessionPlaytimeLabel(self)
    UISharedFunctions:setupCurrencyLabels(self)

    UISharedFunctions:setupBackToMenuButton(self)

    setupTheBirbsWord(self)
    setupBackground(self)
    setupUpgradesScrollingFrame(self)
end

return Module