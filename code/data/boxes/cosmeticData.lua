-- ~/code/data/boxDefinitions/cosmetic.lua

local cosmetic = {
	-- Special
    ["goldenGerald"] = {
		spritePath = "assets/sprites/boxes/goldenGerald.png",
		scale = 0.7,

		mergeSoundData = { soundPath = "assets/sounds/merge/default.wav" },

        shaders = {
            {
                name = "reflection",
                reflectionTexture = "assets/sprites/reflections/goldenGerald.png",
            },
        },
	},

	-- Normal
	["gerald"] = {
		spritePath = "assets/sprites/boxes/box1.png",
		scale = 0.7,

		mergeSoundData = { soundPath = "assets/sounds/merge/default.wav" },
	},

	["jimbo"] = {
		spritePath = "assets/sprites/boxes/box2.png",
		scale = 0.75,

		mergeSoundData = { soundPath = "assets/sounds/merge/default.wav" },
	},

	["glumbo"] = {
		spritePath = "assets/sprites/boxes/box3.png",
		scale = 0.8,

		mergeSoundData = { soundPath = "assets/sounds/merge/default.wav" },
	},

	["jeremy"] = {
		spritePath = "assets/sprites/boxes/box4.png",
		scale = 0.9,

		mergeSoundData = { soundPath = "assets/sounds/merge/default.wav" },
	},

	["muncher"] = {
		spritePath = "assets/sprites/boxes/box5.png",
		scale = 1,

		screenFlashFadeDuration = 1.2,
		flashScreen = true,

		mergeSoundData = { soundPath = "assets/sounds/merge/special.wav" },
	},

	["dylan"] = {
		spritePath = "assets/sprites/boxes/box6.png",
		scale = 1.1,

		mergeSoundData = { soundPath = "assets/sounds/merge/midsize.wav" },
	},

	["carlos"] = {
		spritePath = "assets/sprites/boxes/box7.png",
		scale = 1.2,

		mergeSoundData = { soundPath = "assets/sounds/merge/midsize.wav" },
	},

	["goobsterGoobingtonIII"] = {
		spritePath = "assets/sprites/boxes/box8.png",
		scale = 1.3,

		mergeSoundData = { soundPath = "assets/sounds/merge/midsize.wav" },
	},

	["mark"] = {
		spritePath = "assets/sprites/boxes/box9.png",
		scale = 1.4,

		mergeSoundData = { soundPath = "assets/sounds/merge/midsize.wav" },
	},

	["frigidWendyhot"] = {
		spritePath = "assets/sprites/boxes/box10.png",
		scale = 1.5,

		screenFlashFadeDuration = 1.2,
		flashScreen = true,

		mergeSoundData = { soundPath = "assets/sounds/merge/special.wav" },
	},

	["dizzy"] = {
		spritePath = "assets/sprites/boxes/box11.png",
		scale = 1.6,

		mergeSoundData = { soundPath = "assets/sounds/merge/largesize.wav" },
	},

	["gochged"] = {
		spritePath = "assets/sprites/boxes/box12.png",
		scale = 1.7,

		mergeSoundData = { soundPath = "assets/sounds/merge/largesize.wav" },
	},

	["mtBox"] = {
		spritePath = "assets/sprites/boxes/box13.png",
		scale = 1.8,

		mergeSoundData = { soundPath = "assets/sounds/merge/largesize.wav" },
	},

    ["unstable"] = {
        spritePath = "assets/sprites/boxes/box14.png",
        scale = 1.9,

        mergeSoundData = { soundPath = "assets/sounds/merge/largesize.wav" },

        shaders = {
            {
                name = "reflection",
                reflectionTexture = "assets/sprites/reflections/box14.png",
            },
        },
    },

	["transcended"] = {
		spritePath = "assets/sprites/boxes/box15.png",
		scale = 2,

		screenFlashFadeDuration = 1.2,
		flashScreen = true,

		mergeSoundData = { soundPath = "assets/sounds/merge/special.wav" },
	},

    ["omnibox"] = {
        spritePath = "assets/sprites/boxes/box16.png",
        scale = 2.1,

        mergeSoundData = {
            soundPath = "assets/sounds/merge/box16.wav"
        },

        shaders = {
            {
                name = "box16"
            }
        }
    },

    ["devoided"] = {
        spritePath = "assets/sprites/boxes/box17.png",
        scale = 2.2,

        mergeSoundData = { soundPath = "assets/sounds/merge/box17.wav" },

        shaders = {
            {
                name = "reflection",
                reflectionTexture = "assets/sprites/reflections/box17.png",
            },
        },
    },

	["boxOMatter"] = {
		spritePath = "assets/sprites/boxes/box18.png",
		scale = 2.3,

		mergeSoundData = { soundPath = "assets/sounds/merge/box18.wav" },
	},

	["greatOldGrumpyOne"] = {
		spritePath = "assets/sprites/boxes/box19.png",
		scale = 2.35,
	},

	["luckrollBox"] = {
		spritePath = "assets/sprites/boxes/box20.png",
		scale = 2.4,

		mergeSoundData = { soundPath = "assets/sounds/merge/box20.wav" },
	},

	["mellowBox"] = {
		spritePath = "assets/sprites/boxes/box21.png",
		scale = 2.45,
	},

	["theCollector"] = {
		spritePath = "assets/sprites/boxes/box22.png",
		scale = 2.5,
	},

    ["glitcherson"] = {
        spritePath = "assets/sprites/boxes/box23.png",
        scale = 2.55,

        shaders = {
            {
                name = "reflection",
                reflectionTexture = "assets/sprites/reflections/box23.png",
            },
        },
    },
}

return cosmetic