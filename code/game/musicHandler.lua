-- ~/code/game/musicHandler.lua

local SoundModule = require("code.engine.sound")

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

function Module:update()
    local name = self.playingTrack
    if name then
        local playingTrack = Module.loadedTracks[name]
        if playingTrack then
            if playingTrack.soundObject.source:isPlaying() then return end
            if not playingTrack.isGameplayTrack then return end
        end
    end

    self:playRandomGameplayTrack(name)
end

function Module.init()
    for name, track in pairs(TracksData) do
        local data = table.clone(track)

        local soundObject = SoundModule:createSound({
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

function Module:playTrack(name)
    if name == self.playingTrack then return end

    if self.playingTrack then
        self:stopTrack(self.playingTrack)
    end

    local track = self.loadedTracks[name]
    if not track then return end

    track.soundObject:play()

    self.playingTrack = name
end

function Module:pauseTrack(name)
    local track = self.loadedTracks[name]
    if not track then return end

    track.soundObject:pause()
end

function Module:stopTrack(name)
    local track = self.loadedTracks[name]
    if not track then return end

    track.soundObject:stop()
    self.playingTrack = nil
end

function Module:playRandomGameplayTrack(exclude)
    local track = pickRandomGameplayTrack(exclude)
    self:playTrack(track)
end

function Module:getLoadedTracks()
    return self.loadedTracks
end

return Module