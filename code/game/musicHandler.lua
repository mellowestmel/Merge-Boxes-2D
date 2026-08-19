-- ~/code/game/musicHandler.lua

local SoundHandlerModule = require("code.engine.soundHandler")

local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

local TracksData = require("code.data.tracks")

local Module = {}

Module.gameplayTracks = {}
Module.loadedTracks = {}

Module.playingTrack = nil

local function pickRandomGameplayTrack(exclude)
    local list = Module.gameplayTracks
    if #list == 0 then return nil end
    if #list == 1 then return list[1] end

    local pick
    repeat
        pick = list[math.random(#list)]
    until pick ~= exclude

    return pick
end

function Module:Update()
    local name = self.playingTrack
    if name then
        local playingTrack = Module.loadedTracks[name]
        if playingTrack then
            if playingTrack.soundObject.source:isPlaying() then return end
            if not playingTrack.isGameplayTrack then return end
        end
    end

    self:PlayRandomGameplayTrack(name)
end

function Module.Init()
    for name, track in pairs(TracksData) do
        local data = table.clone(track)

        local soundObject = SoundHandlerModule.new({
            soundPath = data.trackPath,
            volume = data.volume or 1,
            type = "track",
            loop = not data.isGameplayTrack
        })

        data.soundObject = soundObject
        Module.loadedTracks[name] = data

        if data.isGameplayTrack then
            table.insert(Module.gameplayTracks, name)
        end
    end
end

function Module:PlayTrack(name)
    if name == self.playingTrack then return end

    if self.playingTrack then
        self:StopTrack(self.playingTrack)
    end

    local track = self.loadedTracks[name]
    if not track then return end

    track.soundObject:Play()

    self.playingTrack = name
end

function Module:PauseTrack(name)
    local track = self.loadedTracks[name]
    if not track then return end

    track.soundObject:Pause()
end

function Module:StopTrack(name)
    local track = self.loadedTracks[name]
    if not track then return end

    track.soundObject:Stop()
    self.playingTrack = nil
end

function Module:PlayRandomGameplayTrack(exclude)
    local track = pickRandomGameplayTrack(exclude)
    self:PlayTrack(track)
end

function Module:GetLoadedTracks()
    return self.loadedTracks
end

return Module