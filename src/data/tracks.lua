-- ~/src/data/tracks.lua

local TrackConstructor = require("src.data.constructors.trackConstructor")

local rawTracks = {
    mainMenu = {
        trackPath = "assets/audio/tracks/mainmenu.ogg",
        author = "Orzech05",
        trackName = "Fresh Start",

        isGameplayTrack = false
    },
    settings = {
        trackPath = "assets/audio/tracks/settingsmenu.ogg",
        author = "Orzech05",
        trackName = "Fine Tuning",

        isGameplayTrack = false
    },

    almanac = {
        trackPath = "assets/audio/tracks/settingsmenu.ogg",
        author = "Orzech05",
        trackName = "Boxology 101",

        isGameplayTrack = false
    },
    map = {
        trackPath = "assets/audio/tracks/settingsmenu.ogg",
        author = "Orzech05",
        trackName = "Bigger Picture",

        isGameplayTrack = false
    },

    upgradeShop = {
        trackPath = "assets/audio/tracks/upgradeshop.ogg",
        author = "Orzech05",
        trackName = "Blue Business",

        isGameplayTrack = false
    },
    blackMarket = {
        trackPath = "assets/audio/tracks/blackmarket.ogg",
        author = "Orzech05",
        trackName = "Shady Seller",

        isGameplayTrack = false
    },
    sacrificialGrounds = {
        trackPath = "assets/audio/tracks/sacrifice.ogg",
        author = "Orzech05",
        trackName = "Feline Favor",

        isGameplayTrack = false
    },
    fishingShop = {
        trackPath = "assets/audio/tracks/upgradeshop.ogg",
        author = "Orzech05",
        trackName = "Gone Fishing",

        isGameplayTrack = false
    },

    game1 = {
        trackPath = "assets/audio/tracks/game1.ogg",
        author = "Orzech05",
        trackName = "Mellow Meadows",

        isGameplayTrack = true
    },
    game2 = {
        trackPath = "assets/audio/tracks/game1.ogg",
        author = "Orzech05",
        trackName = "TBA",

        isGameplayTrack = true
    },
    game3 = {
        trackPath = "assets/audio/tracks/game1.ogg",
        author = "Orzech05",
        trackName = "TBA",

        isGameplayTrack = true
    },
    game4 = {
        trackPath = "assets/audio/tracks/game1.ogg",
        author = "Orzech05",
        trackName = "TBA",

        isGameplayTrack = true
    },
}

local tracks = {}

for key, trackData in pairs(rawTracks) do
    tracks[key] = TrackConstructor.new(trackData)
end

return tracks