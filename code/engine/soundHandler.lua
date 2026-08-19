-- ~/code/engine/sound.lua

local SignalHandlerModule = require("code.engine.events.signalHandler")

local SettingsModule = require("code.engine.saves.settings")

local IdManagerModule = require("code.engine.idManager")
local math = require("code.engine.helpers.math")

local Sound = {
    id = 0,

    type = "",
    soundPath = "",

    source = {},

    volume = 1,
    pitch = 1
}
Sound.__index = Sound

local Module = {}
Module._sounds = {}

local manager = IdManagerModule.new()

local function computeVolume(sound)
    local base =
    (
        sound.type == "sound"
        and SettingsModule.loadedFile.audio.soundVolume
        or SettingsModule.loadedFile.audio.trackVolume
    )

    if SettingsModule.loadedFile.audio.muteGame then
        base = 0
    end

    return sound.volume * base * SettingsModule.loadedFile.audio.masterVolume
end

function Sound:Pause()
    self.source:pause()
end

function Sound:Play(randomizePitch, min, max, divisor)
    local defaultPitch = self.pitch

    if randomizePitch then
        divisor = divisor or 1000
        min = min or -100
        max = max or 100
        self.pitch = defaultPitch + math.random(min, max) / divisor
    end

    self.source:setPitch(self.pitch)

    local volume = computeVolume(self)
    self.source:setVolume(volume)

    self.source:stop()
    self.source:play()

    self.pitch = defaultPitch
end

function Sound:Stop()
    self.source:stop()
end

function Sound:Remove()
    local id = self.id
    self.source = nil

    Module._sounds[id] = nil
    manager:Release(id)
end

function Module.new(data)
    if not data.soundPath then return end

    local sourceType = ((data.type or "sound") == "sound" and "static" or "stream")
    local source = love.audio.newSource(data.soundPath, sourceType)

    local sound = setmetatable({
        id = manager:Get(),

        type = data.type or "sound",
        soundPath = data.soundPath,

        source = source,

        loop = data.loop or false,

        volume = data.volume or 1,
        pitch = data.pitch or 1
    }, Sound)
    Module._sounds[sound.id] = sound

    return sound
end

function Module:Update()
    for _, sound in pairs(self._sounds) do
        if not sound.source:isPlaying() then goto continue end

        sound.source:setVolume(computeVolume(sound))
        sound.source:setLooping(sound.loop)
        sound.source:setPitch(sound.pitch)

        :: continue ::
    end
end

function Module.Init()
    SignalHandlerModule.Get("love.update"):Connect(function()
        Module:Update()
    end)
end

return Module