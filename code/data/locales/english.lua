-- ~/code/data/locales/english.lua

--[[
English (source language). Every other locale copies this file and
translates the values inside the quotes. NEVER change the keys.

{curlyBraces} are placeholders filled in by the game. Keep them exactly
as written, but feel free to move them around in the sentence.
--]]

return {
    meta = {
        name = "English", -- shown in the language picker, always in its own language
        sortOrder = 1
    },

    -- Shared / general UI
    common = {
        back = "Back",
    },

    shared = {
        creditsValue = "{amount} C$", -- Change "C" to the first letter of the word "Credits" in your language
    },

    mainMenu = {
        play = "Play Game",
        quit = "Quit Game",
    },

    saveFiles = {
        slot = "Slot {n}",
        loadFile = "Load File",
        resetFile = "Reset File",
        resetConfirm = "Are you sure?",
        resetDone = "Bye bye!",
        highestTier = "Highest Tier: {tier}",
    },

    boxRanch = {
        spawnBox = "Spawn Box!",
        spawnCooldown = "{time}s",
        autoSpawn = "Auto Spawn ({state})",
        on = "ON",
        off = "OFF",
    },

    upgradeShop = {
        cost = "{amount} Credits",
        maxed = "MAX",
    },

    -- Settings menu
    settings = {
        categories = {
            audio = "Audio",
            graphics = "Graphics",
            accessibility = "Accessibility",
        },

        -- Setting names
        masterVolume = "Master volume",
        soundVolume = "Sound volume",
        trackVolume = "Music volume",
        muteGame = "Mute game?",

        contrast = "Contrast",
        gamma = "Gamma",
        fullscreen = "Fullscreen?",
        vsync = "VSync?",
        uiAnimationsEnabled = "Enable UI animations?",
        cursorAnimationsEnabled = "Enable cursor animations?",
        transitionsEnabled = "Enable transitions?",
        particlesEnabled = "Enable particles?",

        colorblindMode = "Colorblindness mode",
        screenFlashEnabled = "Enable screen flashes?",

        language = "Language",

        colorblindModes = {
            none = "None",
            protanopia = "Protanopia",
            deuteranopia = "Deuteranopia",
            tritanopia = "Tritanopia",
        },
    },

    upgrades = {
        spawnCooldown = {
            name = "Spawn Cooldown",
            description = "Decrease spawn cooldown by .1 seconds per stack.",
        },

        spawnTier = {
            name = "Spawn Tier",
            description = "Increase spawn tier by 1 per stack.",
        },

        autoSpawn = {
            name = "Auto Spawn",
            description = "Adds a toggle to automatically spawn boxes. (Doesn't work while away from the ranch.)",
        },

        luckyRoll = {
            name = "Lucky Roll",
            description = "Each spawned box has a chance to spawn one tier higher. Each stack increases the chance by 10%.",
        },

        multiSpawn = {
            name = "Multi Spawn",
            description = "Spawn an extra box per stack.",
        },

        pullPower = {
            name = "Pull Power",
            description = "Increases the strength of your pull. Useful for pulling large boxes. Each stack increases power by 100%.",
        },
    },

    -- Don't translate the box's names into your language, or translate the word Box into your language. "Box" is the name of the species.
    boxes = {
        -- Special
        goldenGerald = {
            name = "Golden Gerald",
            description = "A quick little box who occasionally zips around in the area. Click him for a buff!",
            quote = "Golden Gerald.",
        },

        -- Box o' Matter's fakes
        geraldo = {
            name = "Geraldo",
            description = "One of the camouflages Box o' Matter can become. This one is a low quality fake of Gerald.",
            quote = "Geraldo.",
        },

        jambo = {
            name = "Jambo",
            description = "One of the camouflages Box o' Matter can become. This one is a low quality fake of Jimbo.",
            quote = "What!? You caught me!?",
        },

        glungus = {
            name = "Glungus",
            description = "One of the camouflages Box o' Matter can become. This one is a low quality fake of Glumbo.",
            quote = "Hehehe, they're never going to find us THAT way!",
        },

        -- Normal
        gerald = {
            name = "Gerald",
            description = "C'mon, it's Gerald! Do I really need to describe him? He's perfect!",
            quote = "Gerald.",
        },

        jimbo = {
            name = "Jimbo",
            description = "Jimbo is constantly shocked at everything, always horrified by what comes next.",
            quote = "WHAT??",
        },

        glumbo = {
            name = "Glumbo",
            description = "Glumbo's constantly planning on taking over the world, but that'll never happen because he's telling his plans to everyone. He's the reason his brother Jimbo is constantly shocked.",
            quote = "And that's how I'll take over the world!",
        },

        jeremy = {
            name = "Jeremy",
            description = "Jeremy loves to remind the teacher about the homework. Nobody likes Jeremy.",
            quote = "Ermm... actually! :nerd:",
        },

        muncher = {
            name = "Muncher",
            description = "An overweight box that most definitely ate that cookie.",
            quote = "I didn't eat that cookie!",
        },

        dylan = {
            name = "Dylan",
            description = "Dylan loves clothes shopping at \"Cold Subject\". He isn't very talkative.", -- Backslashes are used to put quotes inside quotes
            quote = "...",
        },

        carlos = {
            name = "Carlos",
            description = "A really enthusiastic box who loves bothering people. Annoying.",
            quote = "HEY!!!",
        },

        goobsterGoobingtonIII = {
            name = "Goobster Goobington III",
            description = "This goofy goober of a box loves sticking out his tongue! A very silly creature indeed.",
            quote = "Blehhhh!",
        },

        mark = {
            name = "Mark",
            description = "A box that doesn't look familiar at all... It's new around here, so it will be quite curious and observant of its surroundings.",
            quote = "Oh that's new...",
        },

        frigidWendyhot = {
            name = "Frigid Wendyhot",
            description = "An extremely cool cube, who apparently has terrible parents. Who in their right mind would name their child \"Frigid Wendyhot\"? Also, who shaved off his other eyebrow?",
            quote = "Sup, twin?",
        },

        dizzy = {
            name = "Dizzy",
            description = "A box whose perception is always a few seconds behind reality. It reacts to things that already happened.",
            quote = "Whuh? wha-?",
        },

        gochged = {
            name = "Gochged",
            description = "A granite-man transformed into a box. He is the original artist behind every face you see on the boxes.",
            quote = "ROCK NOISES!!!",
        },

        mtBox = {
            name = "Mt. Box",
            description = "A box that grew so big, it became classifiable as a mountain! Going past this point may not be wise... He looks a little funny though.",
            quote = "Big back, big back! Big back, big back! Yeah, my back is loaded up with snacks and different foods!",
        },

        unstable = {
            name = "Unstable",
            description = "This box is so massive that it became red-hot from the outside! Being able to fuse so much matter into one point is inhuman.",
            quote = "RAAAAAAAAAHHH!!!",
        },

        transcended = {
            name = "Transcended",
            description = "A box that has been enlightened with the knowledge of everything, even the fact that it's in a game! It has become mute and unreactive, trying to process everything at once.",
            quote = "...",
        },

        omnibox = {
            name = "Omnibox",
            description = "A mesmerizing box which is hard to look at. You have fused so much matter into one being that it is starting to spill.",
            -- Base64 for the word "everything". Encode the word "everything" in your language into Base64
            quote = "ZXZlcnl0aGluZw==",
        },

        devoided = {
            name = "Devoided",
            description = "A sinister and unstable box. It has become so big that its weight is in the negatives.",
            quote = "MUAHAHAHAHA!",
        },

        boxOMatter = {
            name = "Box o' Matter",
            description = "Quite a playful box that likes to mess around with its shapeshifting ability. It will occasionally shapeshift into the lower-tier boxes, while still being counted as the same tier.",
            quote = "Hide and seek! Will you find me?",
        },

        greatOldGrumpyOne = {
            name = "Great Old Grumpy One",
            description = "An ancient cosmic entity that has existed since before the universe. It was in the middle of the best nap it has ever had.",
            quote = "I was SLEEPING!!",
        },

        luckrollBox = {
            name = "Luckroll Box",
            description = "A box so lucky it constantly gets accused of cheating in various games.",
            quote = "Trust me, it's luck!",
        },

        mellowBox = {
            name = "Mellow Box",
            description = "A carefree little box who doesn't care what happens around her. Bears a striking resemblance to the creator of this game.",
            quote = "yea",
        },

        theCollector = {
            name = "The Collector",
            description = "A box that loves to collect little stickers and trinkets. It's covered in them. They're everywhere. How is that thing still breathing?",
            quote = "A little bit of everything, all of the time!",
        },

        glitcherson = {
            name = "Glitcherson",
            description = "A funky-looking box with a weird typing quirk. Staring at it for too long may cause a migraine.",
            -- Try and recreate the same "glitchy" feel in your language.
            quote = "H4H4H4H4HH4H4H4H4H4HH4H4H4H4H44444!!!!! 1 L0V3 B31NG 1N5UFF3R1BL3!!!! W00H000!!!",
        },
    },
}