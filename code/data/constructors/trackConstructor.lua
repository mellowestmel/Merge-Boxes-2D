-- ~/code/data/constructors/trackConstructor.lua

local Module = {}

function Module.new(data)
    assert(data.trackPath, "Track requires a trackPath")

    return {
        trackPath = data.trackPath,

        author = data.author or "Unknown",
        trackName = data.trackName or "Unknown",

        isGameplayTrack = data.isGameplayTrack or false,
    }
end

return Module