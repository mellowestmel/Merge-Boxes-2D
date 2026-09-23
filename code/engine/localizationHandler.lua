-- ~/code/engine/localizationHandler.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")


local DEFAULT_LANGUAGE = "english"

local LOCALE_DIRECTORY = "code/data/locales"
local LOCALE_REQUIRE_PATH = "code.data.locales."

local Module = {}

Module.language = DEFAULT_LANGUAGE
Module.languages = {}

local locales = {}
local strings = {}
local warnedKeys = {}

-- Walks a dotted key (e.g. "boxes.gerald.name") through a nested table.
local function _lookup(current, key)
    for part in key:gmatch("[^.]+") do
        if type(current) ~= "table" then
            return nil
        end

        current = current[part]
    end

    return current
end

-- Replaces {placeholders} with values from vars.
-- Unknown placeholders are left untouched so they're easy to spot.
local function _fill(text, variables)
    if not variables then
        return text
    end

    return (text:gsub("{(%w+)}", function(name)
        local value = variables[name]

        if value == nil then
            return nil
        end

        return tostring(value)
    end))
end

-- Loads every locale file in the locales folder.
-- A broken translation file errors on startup so it wont go unnoticed.
local function _scanLocales()
    locales = {}
    Module.languages = {}

    for _, fileName in ipairs(love.filesystem.getDirectoryItems(LOCALE_DIRECTORY)) do
        local code = fileName:match("^(.+)%.lua$")

        if code then
            local locale = require(LOCALE_REQUIRE_PATH .. code)

            assert(type(locale) == "table", "Locale '" .. code .. "' must return a table")
            assert(locale.meta and locale.meta.name, "Locale '" .. code .. "' is missing meta.name")

            locales[code] = locale
            table.insert(Module.languages, code)
        end
    end

    table.sort(Module.languages)
end

-- Returns the translated text for a key.
-- Missing keys return the key itself and are logged once.
function Module.Get(key, variables)
    local text = _lookup(strings, key)

    if type(text) ~= "string" then
        if not warnedKeys[key] then
            warnedKeys[key] = true
            print("[localization] missing key: " .. key)
        end

        return key
    end

    return _fill(text, variables)
end

function Module.GetLanguage()
    return Module.language
end

-- Sorted list of language codes, e.g. {"english", "polish"}.
function Module.GetLanguages()
    return Module.languages
end

-- The language's own name (meta.name), e.g. "Polski" for "polish".
function Module.GetLanguageName(code)
    local locale = locales[code]

    return locale and locale.meta and locale.meta.name or code
end

-- Switches language and fires "localization.changed" (language, oldLanguage).
function Module.SetLanguage(language)
    if not locales[language] then
        language = DEFAULT_LANGUAGE
    end

    if language == Module.language then
        return
    end

    local oldLanguage = Module.language

    Module.language = language
    strings = locales[language] or {}

    SignalHandlerModule.Get("localization.changed"):Fire(language, oldLanguage)
end

-- Called once settings are loaded.
function Module.Init()
    local SettingsModule = require("code.engine.saves.settings") -- Prevent circular dependency

    _scanLocales()
    assert(locales[DEFAULT_LANGUAGE], "Default locale '" .. DEFAULT_LANGUAGE .. "' not found in " .. LOCALE_DIRECTORY)

    local savedLanguage = SettingsModule:Get("accessibility.language")

    Module.language = locales[savedLanguage] and savedLanguage or DEFAULT_LANGUAGE
    strings = locales[Module.language] or {}

    SignalHandlerModule.Get("game.saves.settingchanged"):Connect(function(settingKey, newValue)
        if settingKey == "language" then
            Module.SetLanguage(newValue)
        end
    end)
end

return Module