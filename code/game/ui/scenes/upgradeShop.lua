-- ~/code/game/ui/scenes/upgradeShop.lua

local SavesFilesModule = require("code.engine.saves.files")

local LocalizationHandlerModule = require("code.engine.localizationHandler")
local MusicHandlerModule = require("code.game.musicHandler")
local UpgradeHandlerModule = require("code.game.upgradeHandler")

local PurchaseUpgradeHandlerModule = require("code.game.shop.upgrade.purchase")

local BoxesObjectModule = require("code.game.boxes.object")

local UISharedFunctions = require("code.game.ui.shared")
local UIObjectHelperModule = require("code.game.ui.helpers.object")
local UITextWrappingHelperModule = require("code.game.ui.helpers.textWrapping")
local UILayoutHelperModule = require("code.game.ui.helpers.layout")
local UISceneBase = require("code.game.ui.helpers.scene")

local UILayoutData = require("code.data.ui.layout")

local COMMON_VALUES = require("code.data.ui.commonValues")
local CONSTANTS = require("code.data.constants")

local SceneData = require("code.data.ui.scenes.upgradeShop")
local ShopID = CONSTANTS.SHOP.UPGRADE_SHOP.ID

local FACE_SECRET_PLAYTIME = 745 -- 12 minutes 25 seconds
local SECRET_CLIPS_PATH = "assets/sounds/secret/clips"

local Module = UISceneBase.new("upgradeShop")
Module._upgradeButtons = {}

function Module:OnClean()
	self._upgradeButtons = {}
end

local function _setupBirdSecret(self)
	UIObjectHelperModule.CreateElementButton(
		self,
		SceneData.birdSecret,
		nil,
		function()
			UISharedFunctions:PlaySound("assets/sounds/secret/chirp.wav")
		end
	)
end

local function _setupFaceSecret(self)
	local sessionPlaytime =
		SavesFilesModule:Get("tracking.playtime") - SavesFilesModule.playtimeAtSessionStart

	if math.floor(sessionPlaytime) ~= FACE_SECRET_PLAYTIME then return end

	UIObjectHelperModule.CreateElementButton(
		self,
		SceneData.faceSecret,
		nil,
		function()
			local files = love.filesystem.getDirectoryItems(SECRET_CLIPS_PATH)

			if #files == 0 then return end

			UISharedFunctions:PlaySound(
				SECRET_CLIPS_PATH .. "/" .. files[math.random(1, #files)]
			)
		end
	)
end

local function _setupDescriptionPanel(self)
	local background = UIObjectHelperModule.CreateElement(
		SceneData.upgradeDescriptionBackground,
		self
	)

	local text = UIObjectHelperModule.CreateElement(
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

	text.text = LocalizationHandlerModule.Get("upgrades." .. upgradeId .. ".description")
	UITextWrappingHelperModule.Wrap(text, background, padding)

	local _, breaks = text.text:gsub("\n", "")
	local lineCount = breaks + 1
	local lineHeight =
		text.font:getHeight() * text.font:getLineHeight() * text.scaleY

	background.scaleY = panel.baseScaleY * math.max(
		1,
		(lineCount * lineHeight + padding * 2) / panel.baseHeight
	)

	panel.textOffsetY = -((lineCount - 1) * lineHeight) / 2
	panel.id = upgradeId
end

local function _updateDescription(self)
	local panel = self._description
	if not panel then return end

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

	local hitbox = hovered.hitbox

	background.x =
		hitbox.x
		- (hitbox:GetWidth() + background:GetWidth()) / 2
		- COMMON_VALUES.MEDIUM_PADDING

	background.y = hitbox.y

	text.x = background.x
	text.y = background.y + panel.textOffsetY
end

-- Filled stack indicators are yellow, empty ones are dark.
local function _setIndicatorColor(indicator, stackIndex, currentStacks)
	indicator:ChangeColor(
		(stackIndex <= currentStacks)
			and COMMON_VALUES.COLOR_YELLOW
			or COMMON_VALUES.COLOR_DARK
	)
end

local function _formatCostText(isMaxedOut, upgradeCost)
	return isMaxedOut
		and LocalizationHandlerModule.Get("upgradeShop.maxed")
		or LocalizationHandlerModule.Get("upgradeShop.cost", { amount = string.formatNumber(upgradeCost) })
end

-- Creates a centered row of stack indicators.
local function _createStackIndicators(self, x, y, maximumStacks, currentStacks)
	local indicators = {}
	local itemSpacing = COMMON_VALUES.MEDIUM_PADDING

	local startPositionX = x - (((maximumStacks - 1) * itemSpacing) / 2)

	for stackIndex = 1, maximumStacks do
		local indicator = UIObjectHelperModule.CreateElement(
			SceneData.upgradeStackCounter,
			self,
			{
				x = UILayoutHelperModule.GetHorizontalStackX(
					startPositionX,
					stackIndex,
					itemSpacing
				),

				y = y
			}
		)

		_setIndicatorColor(indicator, stackIndex, currentStacks)

		table.insert(indicators, indicator)
	end

	return indicators
end

-- Creates one upgrade button. Every element it makes is added to `children`
-- so the scrolling frame can move them together.
local function _createUpgradeButton(self, upgradeId, x, y, children)
	local upgrade = UpgradeHandlerModule:GetUpgrade(upgradeId)
	local textOffsetY = UILayoutData.upgradeShop.textOffsetRatio

	local hitbox = UIObjectHelperModule.CreateElement(
		SceneData.upgradeBuyHitbox,
		self,
		{ x = x, y = y }
	)

	local halfHeight = hitbox:GetHeight() * textOffsetY

	local nameLabel = UIObjectHelperModule.CreateElement(
		SceneData.upgradeName,
		self,
		{ x = x, y = y - halfHeight }
	)

	nameLabel.text = LocalizationHandlerModule.Get("upgrades." .. upgradeId .. ".name")

	local currentStacks = UpgradeHandlerModule:GetStacks(upgradeId)
	local isMaxedOut = UpgradeHandlerModule:IsMaxed(upgradeId)
	local upgradeCost = PurchaseUpgradeHandlerModule:GetCost(upgradeId)

	local costLabel = UIObjectHelperModule.CreateElement(
		SceneData.upgradeCost,
		self,
		{ x = x, y = y }
	)

	costLabel.text = _formatCostText(isMaxedOut, upgradeCost)

	local indicators = _createStackIndicators(
		self,
		x,
		y + halfHeight,
		upgrade.maxStacks or 1,
		currentStacks
	)

	local buttonElements = { hitbox, nameLabel, costLabel }

	for _, indicator in ipairs(indicators) do
		table.insert(buttonElements, indicator)
	end

	for _, element in ipairs(buttonElements) do
		table.insert(children, element)
	end

	local buyButton = UIObjectHelperModule.CreateButton(
		self,
		buttonElements,
		hitbox,
		function()
			local success = PurchaseUpgradeHandlerModule:Buy(upgradeId, ShopID)

			UISharedFunctions:PlaySound(
				success
					and "assets/sounds/shop/transaction.wav"
					or "assets/sounds/ui/notallowed.wav"
			)
		end
	)

	table.insert(self._upgradeButtons, {
		id = upgradeId,
		button = buyButton,
		hitbox = hitbox,
		costLabel = costLabel,
		indicators = indicators,
		currentStacks = currentStacks,
		isMaxedOut = isMaxedOut,
		upgradeCost = upgradeCost
	})
end

local function _setupUpgradesScrollingFrame(self)
	local frameTrack = UIObjectHelperModule.CreateElement(
		SceneData.upgradesFrameBackground,
		self
	)

	local scrollWheel = UIObjectHelperModule.CreateElement(
		SceneData.upgradesFrameScrollWheel,
		self
	)

	local childElements = {}

	local startPositionY =
		frameTrack.y
		- (frameTrack:GetHeight() / 2)
		+ COMMON_VALUES.LARGE_PADDING

	for index, upgradeId in pairs(UpgradeHandlerModule:GetUpgradesByShop(ShopID)) do
		_createUpgradeButton(
			self,
			upgradeId,
			frameTrack.x,

			UILayoutHelperModule.GetVerticalStackY(
				startPositionY,
				index,
				COMMON_VALUES.BUTTON_VERTICAL_GAP
			),

			childElements
		)
	end

	UIObjectHelperModule.CreateScrollingFrame(
		self,
		frameTrack,
		scrollWheel,
		childElements,
		COMMON_VALUES.LARGE_PADDING
	)
end

-- Only touches the elements when the upgrade's state actually changed.
local function _updateUpgradeButton(upgradeButton)
	local id = upgradeButton.id

	local currentStacks = UpgradeHandlerModule:GetStacks(id)
	local isMaxedOut = UpgradeHandlerModule:IsMaxed(id)
	local upgradeCost = PurchaseUpgradeHandlerModule:GetCost(id)

	if currentStacks ~= upgradeButton.currentStacks then
		upgradeButton.currentStacks = currentStacks

		for stackIndex, indicator in pairs(upgradeButton.indicators) do
			_setIndicatorColor(indicator, stackIndex, currentStacks)
		end
	end

	if isMaxedOut ~= upgradeButton.isMaxedOut
		or upgradeCost ~= upgradeButton.upgradeCost
	then
		upgradeButton.isMaxedOut = isMaxedOut
		upgradeButton.upgradeCost = upgradeCost

		upgradeButton.costLabel.text = _formatCostText(isMaxedOut, upgradeCost)
	end
end

function Module:OnUpdate()
	for _, upgradeButton in pairs(self._upgradeButtons) do
		_updateUpgradeButton(upgradeButton)
	end

	_updateDescription(self)
end

function Module:Init()
	MusicHandlerModule:PlayTrack("upgradeShop")

	BoxesObjectModule.renderBoxes = false

	UISharedFunctions:SetupShopScene(self)

	_setupBirdSecret(self)
	_setupFaceSecret(self)

	_setupUpgradesScrollingFrame(self)
	_setupDescriptionPanel(self)
end

return Module