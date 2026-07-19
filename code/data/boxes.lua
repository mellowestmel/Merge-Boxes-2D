-- ~/code/data/boxes.lua

--/// ENGINE \\\--
local RenderModule = require("code.engine.render")

--// HELPERS \\--
local color = require("code.engine.helpers.color")

return {
    {
        spritePath = "assets/sprites/boxes/box1.png",

        description = "C'mon, it's Gerald! Do I really need to describe him? He's perfect!",
        quote = "Gerald.",
        name = "Gerald",

        mergeReward = 0,

        weight = 40,
        scale = .7,
        tier = 1,
    },
    {
        spritePath = "assets/sprites/boxes/box2.png",

        description = "Jimbo is constantly shocked at everything, always horrified by what comes next.",
        quote = "WHAT??",
        name = "Jimbo",

        mergeReward = 5,

        weight = 50,
        scale = .8,
        tier = 2,
    },
    {
        spritePath = "assets/sprites/boxes/box3.png",

        description = "Glumbo's constantly planning on taking over the world, but that'll never happen because he's telling his plans to everyone. He's the reason his brother Jimbo is constantly shocked.",
        quote = "And that's how I'll take over the world!",
        name = "Glumbo",

        mergeReward = 10,

        weight = 55,
        scale = .9,
        tier = 3,
    },
    {
        spritePath = "assets/sprites/boxes/box4.png",

        description = "Jeremy loves to remind the teacher about the homework. Nobody likes Jeremy.",
        quote = "Ermm... actually! ☝️🤓",
        name = "Jeremy",

        mergeReward = 15,

        weight = 120,
        scale = 1,
        tier = 4,
    },
    {
        spritePath = "assets/sprites/boxes/box5.png",

        description = "An overweight box that most definitely ate that cookie.",
        quote = "I didn't eat that cookie!",
        name = "Muncher",

        mergeReward = 50,

        screenFlashFadeDuration = 1.2,
        flashScreen = true,

        mergeSoundData = {soundPath = "assets/sounds/merge/special.wav"},

        weight = 250,
        scale = 1.1,
        tier = 5,
    },
    {
        spritePath = "assets/sprites/boxes/box6.png",

        description = [[Dylan loves clothes shopping at "Cold Subject". He isn't very talkative.]],
        quote = "...",
        name = "Dylan",

        mergeReward = 55,

        weight = 255,
        scale = 1.2,
        tier = 6,
    },
    {
        spritePath = "assets/sprites/boxes/box7.png",

        description = "A really enthusiastic box who loves bothering people. Annoying.",
        quote = "HEY!!!",
        name = "Carlos",

        mergeReward = 60,

        weight = 270,
        scale = 1.3,
        tier = 7,
    },
    {
        spritePath = "assets/sprites/boxes/box8.png",

        description = "This goofy goober of a box loves sticking out his tongue! A very silly creature indeed.",
        quote = "Blehhhh!",
        name = "Goobster Goobington III",

        mergeReward = 65,

        weight = 300,
        scale = 1.4,
        tier = 8,
    },
    {
        spritePath = "assets/sprites/boxes/box9.png",

        description = "Goodness gracious!! Is this thing okay!?!? Its eyes are bloodshot!!",
        quote = "YASS QWEEN 💅💅 WE'RE GETTING SOME GEMINI ENERGY! SLAYY! 💅💅💅",
        name = "Angel",

        mergeReward = 70,

        weight = 345,
        scale = 1.5,
        tier = 9,
    },
    {
        spritePath = "assets/sprites/boxes/box10.png",

        description = [[An extremely cool cube, who apparently has terrible parents. Who in their right mind would name their child "Frigid Wendyhot"? Also, who shaved off his other eyebrow?]],
        quote = "Sup, twin?",
        name = "Frigid Wendyhot",

        mergeReward = 100,

        screenFlashFadeDuration = 1.2,
        flashScreen = true,

        mergeSoundData = {soundPath = "assets/sounds/merge/special.wav"},

        weight = 370,
        scale = 1.58,
        tier = 10,
    },
    {
        spritePath = "assets/sprites/boxes/box11.png",

        description = "A box whose perception is always a few seconds behind reality. It reacts to things that already happened.",
        quote = "Whuh? wha-?",
        name = "Dizzy",

        mergeReward = 110,

        weight = 430,
        scale = 1.66,
        tier = 11,
    },
    {
        spritePath = "assets/sprites/boxes/box12.png",

        description = "A granite-man transformed into a box. He is the original artist behind every face you see on the boxes.",
        quote = "ROCK NOISES!!!",
        name = "Gochged",

        mergeReward = 120,

        weight = 600,
        scale = .85,
        tier = 12,
    },
    {
        spritePath = "assets/sprites/boxes/box13.png",

        description = "A box that grew so big, it became classifiable as a mountain! Going past this point may not be wise... He looks a little funny though.",
        quote = "Big back, big back! Big back, big back! Yeah, my back is loaded up with snacks and different foods!",
        name = "Mt. Box",

        mergeReward = 130,

        weight = 500,
        scale = 1.8,
        tier = 13,
    },
    {
        spritePath = "assets/sprites/boxes/box14.png",

        description = "This box is so massive that it became red-hot from the outside! Being able to fuse so much matter into one point is inhuman.",
        quote = "RAAAAAAAAAHHH!!!",
        name = "Unstable",

        mergeReward = 140,

        reflectionPath = "assets/sprites/reflections/box14.png",
        reflective = true,

        weight = 750,
        scale = 1.865,
        tier = 14,
    },
    {
        spritePath = "assets/sprites/boxes/box15.png",

        description = "A box that has been enlightened with the knowledge of everything, even the fact that it's in a game! It has become mute and unreactive, trying to process everything at once.",
        name = "Transcended",

        mergeReward = 222,

        screenFlashFadeDuration = 1.2,
        flashScreen = true,

        mergeSoundData = {soundPath = "assets/sounds/merge/special.wav"},

        weight = 1000,
        scale = 1.95,
        tier = 15,
    },
    {
        spritePath = "assets/sprites/boxes/box16.png",

        description = "A mesmerizing box which is hard to look at. You have fused so much matter into one being that it is starting to spill.",
        quote = "ZXZlcnl0aGluZw==",
        name = "Omnibox",

        mergeReward = 333,

        onUpdateCosmetic = function(element)
            local hue = (love.timer.getTime() % 5) / 5
            element.color = RenderModule:createColor(color.HSVtoRGB(hue, 1, 1))
        end,

        mergeSoundData = {soundPath = "assets/sounds/merge/box16.wav"},

        weight = 1100,
        scale = 2,
        tier = 16,
    },
    {
        spritePath = "assets/sprites/boxes/box17.png",

        description = "A sinister and unstable box. It has become so big that its weight is in the negatives.",
        quote = "MUAHAHAHAHA!",
        name = "Devoided",

        mergeReward = 444,

        reflectionPath = "assets/sprites/reflections/box17.png",
        reflective = true,

        mergeSoundData = {soundPath = "assets/sounds/merge/box17.wav"},

        weight = -60,
        scale = 2.05,
        tier = 17,
    },
    {
        spritePath = "assets/sprites/boxes/box18.png",

        description = "Quite a playful box that likes to mess around with its shapeshifting ability. It will occasionally shapeshift into the lower-tier boxes, while still being counted as the same tier.",
        quote = "Hide and seek! Will you find me?",
        name = "Box o' Matter",

        mergeReward = 555,

        mergeSoundData = {soundPath = "assets/sounds/merge/box18.wav"},

        weight = 1300,
        scale = 2.15,
        tier = 18,
    },
    {
        spritePath = "assets/sprites/boxes/box19.png",

        description = "An ancient cosmic entity that has existed since before the universe. It was in the middle of the best nap it has ever had.",
        quote = "I was SLEEPING!!",
        name = "Great Old Grumpy One",

        mergeReward = 666,

        weight = 1400,
        scale = 2.2,
        tier = 19,
    },
    {
        spritePath = "assets/sprites/boxes/box20.png",

        description = "A box so lucky it constantly gets accused of cheating in various games.",
        quote = "Trust me, it's luck!",
        name = "Luckroll Box",

        mergeReward = 777,

        weight = 1500,
        scale = 2.25,
        tier = 20,
    },
    {
        spritePath = "assets/sprites/boxes/box21.png",

        description = "A box that loves to collect little stickers and trinkets. It's covered in them. They're everywhere. How is that thing still breathing?",
        quote = "A little bit of everything, all of the time!",
        name = "The Collector",

        mergeReward = 888,

        weight = 1600,
        scale = 2.3,
        tier = 21,
    },
    {
        spritePath = "assets/sprites/boxes/box22.png",

        description = "A carefree little box who doesn't care what happens around her. Bears a striking resemblance to the creator of this game.",
        quote = "yea",
        name = "Mellow Box",

        mergeReward = 999,

        weight = 1700,
        scale = 2.35,
        tier = 22,
    },
    {
        spritePath = "assets/sprites/boxes/box23.png",

        description = "A funky-looking box with a weird typing quirk. Staring at it for too long may cause a migraine.",
        quote = "H3Y, H0W 4R3 Y4????",
        name = "Glitcherson",

        mergeReward = 1250,

        weight = 2000,
        scale = 2.4,
        tier = 23,
    },
    {
        spritePath = "assets/sprites/boxes/box24_sheet.png",

        description = "All the merging you've done has led up to this. The ultimate three-dimensional being.",
        quote = "nil",
        name = "?@%%%&&",

        -- animation = {
        --     frameWidth = 100,
        --     frameHeight = 100,
        --     frameCount = 39,
        --     fps = 24
        -- },

        mergeReward = 2400,

        mergeSoundData = {soundPath = "assets/sounds/merge/box24.wav"},

        weight = 2400,
        scale = 2.4,
        tier = 24,
    }
}