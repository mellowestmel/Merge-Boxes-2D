-- ~/code/engine/soundHandler.lua
-- Generic sound handler for creating, playing, updating, and removing sounds.

local SignalHandlerModule = require("code.engine.events.signalHandler")
local SettingsModule = require("code.engine.saves.settings")

local IdManagerModule = require("code.engine.idManager")

local Sound = {}
Sound.__index = Sound

local Module = {}
Module._sounds = {}

local manager = IdManagerModule.new()

-- Calculates the final volume using the sound/track volume, master volume, and mute setting.
local function _computeVolume(sound)
    local volume = sound.type == "sound"
        and SettingsModule:Get("audio.soundVolume")
        or SettingsModule:Get("audio.trackVolume")

    if SettingsModule:Get("audio.muteGame") then
        volume = 0
    end

    return sound.volume
        * volume
        * SettingsModule:Get("audio.masterVolume")
end

-- Updates a sound's volume, looping, and pitch while it is playing.
local function _updateSound(sound)
    if not sound.source:isPlaying() then
        return
    end

    sound.source:setVolume(_computeVolume(sound))
    sound.source:setLooping(sound.loop)
    sound.source:setPitch(sound.pitch)
end

-- Pauses the sound at its current position.
function Sound:Pause()
    self.source:pause()
end

-- Plays the sound from the beginning.
-- randomizePitch: optionally randomizes the pitch within the given range
-- min: minimum random pitch offset (defaults to -100)
-- max: maximum random pitch offset (defaults to 100)
-- divisor: divides the random pitch offset (defaults to 1000)
function Sound:Play(remove, randomizePitch, min, max, divisor)
    local defaultPitch = self.pitch

    if randomizePitch then
        divisor = divisor or 1000
        min = min or -100
        max = max or 100

        self.pitch = defaultPitch + math.random(min, max) / divisor
    end

    self.source:setPitch(self.pitch)
    self.source:setVolume(_computeVolume(self))

    self.source:stop()
    self.source:play()

    self.pitch = defaultPitch

    if remove then
        self:Remove()
    end
end

-- Stops the sound and resets its playback position.
function Sound:Stop()
    self.source:stop()
end

-- Removes the sound and releases its audio source.
function Sound:Remove()
    local id = self.id

    Module._sounds[id] = nil
    manager:Release(id)

    self.source:release()
    self.source = nil
end

-- data: sound configuration table

-- data.soundPath: path to the audio file
-- data.type: "sound" or "track" (defaults to "sound")
-- data.loop: whether the sound should loop (defaults to false)
-- data.volume: per-sound volume multiplier (defaults to 1)
-- data.pitch: playback pitch (defaults to 1)

function Module.new(data)
    assert(data.soundPath, "SoundHandlerModule.new requires soundPath")

    local type = data.type or "sound"
    local sourceType = type == "sound" and "static" or "stream"

    local sound = setmetatable({
        id = manager:Get(),

        type = type,
        soundPath = data.soundPath,

        source = love.audio.newSource(data.soundPath, sourceType),

        loop = data.loop or false,

        volume = data.volume or 1,
        pitch = data.pitch or 1
    }, Sound)

    Module._sounds[sound.id] = sound

    return sound
end

function Module:Update()
    for _, sound in pairs(self._sounds) do
        _updateSound(sound)
    end
end

function Module.Init()
    SignalHandlerModule.Get("love.update"):Connect(function()
        Module:Update()
    end)
end

return Module