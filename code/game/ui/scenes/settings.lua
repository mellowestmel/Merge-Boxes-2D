-- ~/code/game/ui/scenes/settings.lua

--/// ENGINE \\\--
local RenderModule = require("code.engine.render")

--// SAVES \\--
local SaveFilesModule = require("code.engine.saves.files")
local SettingsModule = require("code.engine.saves.settings")

--// HELPERS \\--
local table = require("code.engine.helpers.table")

--/// GAME \\\--
local MusicHandlerModule = require("code.game.musicHandler")

--// BOX \\--
local BoxesObjectModule = require("code.game.box.object")

--// UI \\--
local UISceneHandlerModule = require("code.game.ui.sceneHandler")
local UISharedFunctions = require("code.game.ui.shared")

--/ UI OBJECTS \--
local UIButtonObjectModule = require("code.game.ui.objects.button")

--// VFX \\--
local ScreenTransitionModule = require("code.game.vfx.screenTransition")

--/// DATA \\\--
local SceneData = require("code.data.ui.scenes.settings")

local Module = {}
Module._elements = {}
Module._objects = {}

Module.name = "settings"

local currentCategoryIndex = 1
local categories = {}

local currentCategoryLabel

function Module:clean()
    for _, element in pairs(self._elements) do
        element:remove()
    end

    for _, object in pairs(self._objects) do
        object:remove()
    end

    self._elements = {}
    self._objects = {}

    UISharedFunctions:cleanUpdates()
end

local function setupBackground(self)
    local background = RenderModule:createElement(SceneData.background)
    table.insert(self._elements, background)
end

local function setupCancelButton(self)
    local cancelButtonHitbox = RenderModule:createElement(SceneData.cancelButtonHitbox)
    table.insert(self._elements, cancelButtonHitbox)

    local cancelButton = UIButtonObjectModule:createButton({
        elements = {
            cancelButtonHitbox
        },

        hitboxElement = cancelButtonHitbox,

        mouseButton = 1,
        onClick = function()
            ScreenTransitionModule:transition({
                callback = function()
                    UISceneHandlerModule:switch(UISceneHandlerModule.lastScene.name)
                end
            })
        end
    })

    table.insert(self._objects, cancelButton)
end

local function updateCategoryLabel()
    if currentCategoryLabel then
        currentCategoryLabel.text = categories[currentCategoryIndex] or ""
    end
end

local function scrollCategory(increment)
    currentCategoryIndex = currentCategoryIndex + increment

    if currentCategoryIndex < 1 then
        currentCategoryIndex = #categories
    elseif currentCategoryIndex > #categories then
        currentCategoryIndex = 1
    end

    updateCategoryLabel()
end

local function setupCurrentCategoryLabel(self)
    currentCategoryLabel = RenderModule:createElement(SceneData.currentCategoryLabel)
    table.insert(self._elements, currentCategoryLabel)

    updateCategoryLabel()
end

local function setupScrollButtons(self)
    local scrollRightButtonHitbox = RenderModule:createElement(SceneData.scrollRightButtonHitbox)
    table.insert(self._elements, scrollRightButtonHitbox)

    local scrollLeftButtonHitbox = RenderModule:createElement(SceneData.scrollLeftButtonHitbox)
    table.insert(self._elements, scrollLeftButtonHitbox)

    local scrollRightButton = UIButtonObjectModule:createButton({
        elements = {
            scrollRightButtonHitbox
        },

        hitboxElement = scrollRightButtonHitbox,

        mouseButton = 1,
        onClick = function()
            scrollCategory(1)
        end
    })

    local scrollLeftButton = UIButtonObjectModule:createButton({
        elements = {
            scrollLeftButtonHitbox
        },

        hitboxElement = scrollLeftButtonHitbox,

        mouseButton = 1,
        onClick = function()
            scrollCategory(-1)
        end
    })

    table.insert(self._objects, scrollRightButton)
    table.insert(self._objects, scrollLeftButton)

    return scrollLeftButton, scrollRightButton
end

local function setupCategoryScrolling(self)
    setupCurrentCategoryLabel(self)
    setupScrollButtons(self)
end

local function buildCategories()
    categories = {}

    for categoryName in pairs(SettingsModule.loadedFile) do
        table.insert(categories, categoryName)
    end
end

function Module:update()
    UISharedFunctions:update()
end

function Module:init()
    MusicHandlerModule:playTrack("settings")

    BoxesObjectModule.renderBoxes = false

    if SaveFilesModule.loadedFile then
        UISharedFunctions:setupSessionPlaytimeLabel(self)
        UISharedFunctions:setupCurrencyLabels(self)
    end

    currentCategoryIndex = 1

    buildCategories()

    setupCategoryScrolling(self)
    setupCancelButton(self)
    setupBackground(self)
end

return Module