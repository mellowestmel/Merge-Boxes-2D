-- ~/code/game/ui/scenes/upgradeShop.lua

local SoundHandlerModule = require("code.engine.soundHandler")
local SavesFilesModule = require("code.engine.saves.files")

local MusicHandlerModule = require("code.game.musicHandler")
local UpgradeHandlerModule = require("code.game.upgradeHandler")

local PurchaseUpgradeHandlerModule = require("code.game.shop.upgrade.purchase")

local BoxesObjectModule = require("code.game.boxes.object")

local UISharedFunctions = require("code.game.ui.shared")
local UIObjectHelperModule = require("code.game.ui.helpers.object")
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
	UIObjectHelperModule.CleanScene(self)

	self._upgradeButtons = {}

	UISharedFunctions:Clean()
end

local function _setupBirdSecret(self)
	local birdSecret = UIObjectHelperModule.CreateElement(
		SceneData.birdSecret,
		self
	)

	UIObjectHelperModule.CreateButton(
		self,
		{birdSecret},
		birdSecret,
		function()
			SoundHandlerModule.new({
				soundPath = "assets/sounds/secret/chirp.wav"
			}):Play(true)
		end
	)
end

local function _setupFaceSecret(self)
	if math.floor(
		SavesFilesModule:Get("tracking.playtime") - SavesFilesModule.playtimeAtSessionStart
	) ~= 745 then return end -- 12 minutes 25 seconds

	local faceSecret = UIObjectHelperModule.CreateElement(
		SceneData.faceSecret,
		self
	)

	UIObjectHelperModule.CreateButton(
		self,
		{faceSecret},
		faceSecret,
		function()
			local clipsPath = "assets/sounds/secret/clips"
			local files = love.filesystem.getDirectoryItems(clipsPath)

			if #files == 0 then return end

			SoundHandlerModule.new({
				soundPath = clipsPath .. "/" .. files[math.random(1, #files)]
			}):Play(true)
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

	text.text = UpgradeHandlerModule:GetUpgrade(upgradeId).description or ""
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

	local visible = hovered ~= nil
	local background, text = panel.background, panel.text

	background.render, text.render = visible, visible

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
		local indicator = UIObjectHelperModule.CreateElement(
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

	local hitbox = UIObjectHelperModule.CreateElement(
		SceneData.upgradeBuyHitbox,
		self
	)

	hitbox.x, hitbox.y = buttonConfig.x, buttonConfig.y

	table.insert(buttonConfig.children, hitbox)

	local halfHeight =
		hitbox:GetHeight() *
		UILayoutData.upgradeShop.textOffsetRatio

	buttonConfig.indicatorY = buttonConfig.y + halfHeight

	local nameLabel = UIObjectHelperModule.CreateElement(
		SceneData.upgradeName,
		self
	)

	nameLabel.text = upgrade.name or buttonConfig.id
	nameLabel.x, nameLabel.y =
		buttonConfig.x,
		buttonConfig.y - halfHeight

	table.insert(buttonConfig.children, nameLabel)

	local currentStacks = UpgradeHandlerModule:GetStacks(buttonConfig.id)
	local maximumStacks = upgrade.maxStacks or 1
	local isMaxedOut = UpgradeHandlerModule:IsMaxed(buttonConfig.id)
	local upgradeCost = PurchaseUpgradeHandlerModule:GetCost(buttonConfig.id)

	local costLabel = UIObjectHelperModule.CreateElement(
		SceneData.upgradeCost,
		self
	)

	costLabel.text =
		isMaxedOut
		and "MAX"
		or string.format(
			"%s Credits",
			string.formatNumber(upgradeCost)
		)

	costLabel.x, costLabel.y =
		buttonConfig.x,
		buttonConfig.y

	table.insert(buttonConfig.children, costLabel)

	local indicators = _createStackIndicators(
		self,
		buttonConfig,
		maximumStacks,
		currentStacks
	)

	local buttonElements = {
		hitbox,
		nameLabel,
		costLabel
	}

	for _, indicator in pairs(indicators) do
		table.insert(buttonElements, indicator)
	end

	local buyButton = UIObjectHelperModule.CreateButton(
		self,
		buttonElements,
		hitbox,
		function()
			local success =
				PurchaseUpgradeHandlerModule:Buy(
					buttonConfig.id,
					ShopID
				)

			SoundHandlerModule.new({
				soundPath =
					success
					and "assets/sounds/shop/transaction.wav"
					or "assets/sounds/ui/notallowed.wav"
			}):Play(true)
		end
	)

	table.insert(self._upgradeButtons, {
		id = buttonConfig.id,
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
		frameTrack.y -
		(frameTrack:GetHeight() / 2) +
		COMMON_VALUES.LARGE_PADDING

	for index, upgradeId in pairs(
		UpgradeHandlerModule:GetUpgradesByShop(ShopID)
	) do
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

	UIObjectHelperModule.CreateScrollingFrame(
		self,
		frameTrack,
		scrollWheel,
		childElements,
		COMMON_VALUES.LARGE_PADDING
	)
end

local function _updateUpgradeButton(upgradeButton)
	local currentStacks = UpgradeHandlerModule:GetStacks(
		upgradeButton.id
	)

	local isMaxedOut = UpgradeHandlerModule:IsMaxed(
		upgradeButton.id
	)

	local upgradeCost = PurchaseUpgradeHandlerModule:GetCost(
		upgradeButton.id
	)

	if currentStacks ~= upgradeButton.currentStacks then
		upgradeButton.currentStacks = currentStacks

		for stackIndex, indicator in pairs(upgradeButton.indicators) do
			indicator:ChangeColor(
				(stackIndex <= currentStacks)
				and COMMON_VALUES.COLOR_YELLOW
				or COMMON_VALUES.COLOR_DARK
			)
		end
	end

	if isMaxedOut ~= upgradeButton.isMaxedOut
		or upgradeCost ~= upgradeButton.upgradeCost
	then
		upgradeButton.isMaxedOut = isMaxedOut
		upgradeButton.upgradeCost = upgradeCost

		upgradeButton.costLabel.text =
			isMaxedOut
			and "MAX"
			or string.format(
				"%s Credits",
				string.formatNumber(upgradeCost)
			)
	end
end

function Module:Update()
	UISharedFunctions:Update()

	for _, upgradeButton in pairs(self._upgradeButtons) do
		_updateUpgradeButton(upgradeButton)
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