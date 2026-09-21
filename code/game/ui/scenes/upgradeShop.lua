-- ~/code/game/ui/scenes/upgradeShop.lua

local SoundHandlerModule = require("code.engine.soundHandler")

local string = require("code.engine.helpers.string")

local MusicHandlerModule = require("code.game.musicHandler")
local UpgradeHandlerModule = require("code.game.upgradeHandler")

local PurchaseUpgradeHandlerModule = require("code.game.shop.upgrade.purchase")

local BoxesObjectModule = require("code.game.boxes.object")

local UISharedFunctions = require("code.game.ui.shared")
local UIButtonObjectModule = require("code.game.ui.objects.button")
local UIScrollingFrameObjectModule = require("code.game.ui.objects.scrollingFrame")
local UITextWrappingHelperModule = require("code.game.ui.helpers.textWrapping")
local UILayoutHelperModule = require("code.game.ui.helpers.layout")

local UILayoutData = require("code.data.ui.layout")

local COMMON_VALUES = require("code.data.ui.commonValues")
local CONSTANTS = require("code.data.constants")

local SceneData = require("code.data.ui.scenes.upgradeShop")
local ShopID = CONSTANTS.SHOP.UPGRADE_SHOP.ID

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

local function _setupBirdSecret(self)
    local birdSecret = UISharedFunctions:CreateElement(
        SceneData.birdSecret,
        self
    )

    local birdButton = UIButtonObjectModule.new({
        elements = {birdSecret},

        hitboxElement = birdSecret,
        mouseButton = 1,

        onClick = function()
            local birdSound = SoundHandlerModule.new({
                soundPath = "assets/sounds/secret/chirp.wav"
            })

            if birdSound then
                birdSound:Play() birdSound:Remove()
            end
        end
    })

    table.insert(self._objects, birdButton)
end

local SavesFilesModule = require("code.engine.saves.files")
local function _setupFaceSecret(self)
    if math.floor(
        SavesFilesModule:Get("tracking.playtime") - SavesFilesModule.playtimeAtSessionStart
    ) ~= 745 then return end -- 12 minutes 25 seconds

    local faceSecret = UISharedFunctions:CreateElement(
        SceneData.faceSecret,
        self
    )

    local faceButton = UIButtonObjectModule.new({
        elements = {faceSecret},

        hitboxElement = faceSecret,
        mouseButton = 1,

        onClick = function()
            local clipsPath = "assets/sounds/secret/clips"
            local files = love.filesystem.getDirectoryItems(clipsPath)

            if #files == 0 then return end

            local soundFile = files[math.random(1, #files)]

            local faceSound = SoundHandlerModule.new({
                soundPath = clipsPath .. "/" .. soundFile
            })

            if faceSound then
                faceSound:Play()
                faceSound:Remove()
            end
        end
    })

    table.insert(self._objects, faceButton)
end

local function _setupDescriptionPanel(self)
    local background = UISharedFunctions:CreateElement(
        SceneData.upgradeDescriptionBackground,
        self
    )

    local text = UISharedFunctions:CreateElement(
        SceneData.upgradeDescriptionText,
        self
    )

    background.render, text.render = false, false

    self._description = {
        background = background,
        text = text,
        baseScaleY = background.scaleY,
        baseHeight = background:GetHeight()
    }
end

-- Runs only when the hovered upgrade changes, not every frame.
local function _setDescription(self, upgradeId)
    local panel = self._description
    local text, background = panel.text, panel.background
    local padding = COMMON_VALUES.MEDIUM_PADDING

    text.text = UpgradeHandlerModule:GetUpgrade(upgradeId).description or ""
    UITextWrappingHelperModule.Wrap(text, background, padding)

    local _, breaks = text.text:gsub("\n", "")
    local lineCount = breaks + 1
    local lineHeight =
        text.font:getHeight() * text.font:getLineHeight() * text.scaleY

    -- Grow the background if the wrapped text doesn't fit
    background.scaleY = panel.baseScaleY * math.max(
        1,
        (lineCount * lineHeight + padding * 2) / panel.baseHeight
    )

    -- The renderer anchors text by ONE line's height, so a multi-line block
    -- hangs down from the anchor. Shift up by half the extra lines to center.
    panel.textOffsetY = -((lineCount - 1) * lineHeight) / 2
    panel.id = upgradeId
end

local function _updateDescription(self)
    local panel = self._description
    if not panel then return end

    -- Same rule Button uses for the hover cursor
    local hovered
    for _, upgradeButton in pairs(self._upgradeButtons) do
        if upgradeButton.button._isHovered and upgradeButton.hitbox.render then
            hovered = upgradeButton
            break
        end
    end

    local background, text = panel.background, panel.text
    background.render, text.render = hovered ~= nil, hovered ~= nil

    if not hovered then return end

    if panel.id ~= hovered.id then
        _setDescription(self, hovered.id)
    end

    -- Left of the hovered button; repositioned every frame so it follows scrolling
    local hitbox = hovered.hitbox

    background.x =
        hitbox.x
        - (hitbox:GetWidth() + background:GetWidth()) / 2
        - COMMON_VALUES.MEDIUM_PADDING

    background.y = hitbox.y

    text.x = background.x
    text.y = background.y + panel.textOffsetY
end

local function _getUpgrades()
    return UpgradeHandlerModule:GetUpgradesByShop(
        CONSTANTS.SHOP.UPGRADE_SHOP.ID
    )
end

local function _createStackIndicators(
    self,
    buttonConfig,
    maximumStacks,
    currentStacks
)
    local indicators = {}
    local itemSpacing = COMMON_VALUES.MEDIUM_PADDING

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

        indicator:ChangeColor(
            (stackIndex <= currentStacks)
            and COMMON_VALUES.COLOR_YELLOW
            or COMMON_VALUES.COLOR_DARK
        )

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
        button = buyButton,
        hitbox = hitbox,
        costLabel = costLabel,
        indicators = indicators,
        maxStacks = maximumStacks
    })
end

local function _setupUpgradesScrollingFrame(self)
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
        COMMON_VALUES.LARGE_PADDING

    for index, upgradeId in pairs(_getUpgrades()) do
        _createUpgradeButton(self, {
            id = upgradeId,

            x = frameTrack.x,

            y = UILayoutHelperModule.GetVerticalStackY(
                startPositionY,
                index,
                COMMON_VALUES.BUTTON_VERTICAL_GAP
            ),

            children = childElements
        })
    end

    local scrollingFrame = UIScrollingFrameObjectModule.new({
        hitboxElement = frameTrack,
        scrollTrackElement = frameTrack,
        scrollBarElement = scrollWheel,

        elements = childElements,
        padding = COMMON_VALUES.LARGE_PADDING
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
            indicator:ChangeColor(
                (stackIndex <= currentStacks)
                and COMMON_VALUES.COLOR_YELLOW
                or COMMON_VALUES.COLOR_DARK)
        end
    end

    _updateDescription(self)
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

    _setupBirdSecret(self)
    _setupFaceSecret(self)

    _setupUpgradesScrollingFrame(self)
    _setupDescriptionPanel(self)
end

return Module