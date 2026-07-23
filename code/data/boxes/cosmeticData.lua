-- ~/code/data/boxDefinitions/cosmetic.lua

local RenderModule = require("code.engine.render")
local color = require("code.engine.helpers.color")

local cosmetic = {
    {
        tier = 1,
        spritePath = "assets/sprites/boxes/box1.png",

        scale = .7,
    },

    {
        tier = 2,
        spritePath = "assets/sprites/boxes/box2.png",

        scale = .75,
    },

    {
        tier = 3,
        spritePath = "assets/sprites/boxes/box3.png",

        scale = .8,
    },

    {
        tier = 4,
        spritePath = "assets/sprites/boxes/box4.png",

        scale = .9,
    },

    {
        tier = 5,
        spritePath = "assets/sprites/boxes/box5.png",

        scale = 1,

        screenFlashFadeDuration = 1.2,
        flashScreen = true,

        mergeSoundData = {soundPath = "assets/sounds/merge/special.wav"},
    },

    {
        tier = 6,
        spritePath = "assets/sprites/boxes/box6.png",

        scale = 1.1,

        mergeSoundData = {soundPath = "assets/sounds/merge/midsize.wav"},
    },

    {
        tier = 7,
        spritePath = "assets/sprites/boxes/box7.png",

        scale = 1.2,

        mergeSoundData = {soundPath = "assets/sounds/merge/midsize.wav"},
    },

    {
        tier = 8,
        spritePath = "assets/sprites/boxes/box8.png",

        scale = 1.3,

        mergeSoundData = {soundPath = "assets/sounds/merge/midsize.wav"},
    },

    {
        tier = 9,
        spritePath = "assets/sprites/boxes/box9.png",

        scale = 1.4,

        mergeSoundData = {soundPath = "assets/sounds/merge/midsize.wav"},
    },

    {
        tier = 10,
        spritePath = "assets/sprites/boxes/box10.png",

        scale = 1.5,

        screenFlashFadeDuration = 1.2,
        flashScreen = true,

        mergeSoundData = {soundPath = "assets/sounds/merge/special.wav"},
    },

    {
        tier = 11,
        spritePath = "assets/sprites/boxes/box11.png",

        scale = 1.6,

        mergeSoundData = {soundPath = "assets/sounds/merge/largesize.wav"},
    },

    {
        tier = 12,
        spritePath = "assets/sprites/boxes/box12.png",

        scale = 1.7,

        mergeSoundData = {soundPath = "assets/sounds/merge/largesize.wav"},
    },

    {
        tier = 13,
        spritePath = "assets/sprites/boxes/box13.png",

        scale = 1.8,

        mergeSoundData = {soundPath = "assets/sounds/merge/largesize.wav"},
    },

    {
        tier = 14,
        spritePath = "assets/sprites/boxes/box14.png",

        scale = 1.9,

        mergeSoundData = {soundPath = "assets/sounds/merge/largesize.wav"},
        reflectionPath = "assets/sprites/reflections/box14.png",

        reflective = true,
    },

    {
        tier = 15,
        spritePath = "assets/sprites/boxes/box15.png",

        scale = 2,

        screenFlashFadeDuration = 1.2,
        flashScreen = true,

        mergeSoundData = {soundPath = "assets/sounds/merge/special.wav"},
    },

    {
        tier = 16,
        spritePath = "assets/sprites/boxes/box16.png",

        scale = 2.1,

        mergeSoundData = {soundPath = "assets/sounds/merge/box16.wav"},

        onUpdateCosmetic = function(element)
            local hue = (love.timer.getTime() % 5) / 5
            element.color = RenderModule:createColor(color.HSVtoRGB(hue, 1, 1))
        end,
    },

    {
        tier = 17,
        spritePath = "assets/sprites/boxes/box17.png",

        scale = 2.2,

        mergeSoundData = {soundPath = "assets/sounds/merge/box17.wav"},

        reflectionPath = "assets/sprites/reflections/box17.png",
        reflective = true,
    },

    {
        tier = 18,
        spritePath = "assets/sprites/boxes/box18.png",

        scale = 2.3,

        mergeSoundData = {soundPath = "assets/sounds/merge/box18.wav"},
    },

    {
        tier = 19,
        spritePath = "assets/sprites/boxes/box19.png",

        scale = 2.35,
    },

    {
        tier = 20,
        spritePath = "assets/sprites/boxes/box20.png",

        scale = 2.4,

        mergeSoundData = {soundPath = "assets/sounds/merge/box20.wav"},
    },

    {
        tier = 21,
        spritePath = "assets/sprites/boxes/box21.png",

        scale = 2.45,
    },

    {
        tier = 22,
        spritePath = "assets/sprites/boxes/box22.png",

        scale = 2.5,
    },

    {
        tier = 23,
        spritePath = "assets/sprites/boxes/box23.png",

        scale = 2.55,

        reflectionPath = "assets/sprites/reflections/box23.png",
        reflective = true,
    },
}

return cosmetic