-- ~/src/data/boxes/cosmeticData.lua

local cosmetic = {
	-- Special
    ["goldenGerald"] = {
		spritePath = "assets/sprites/boxes/game/goldenGerald.png",
		scale = .7,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/default.wav" },

        shaders = {
            {
                name = "reflection",
                reflectionTexture = "assets/sprites/reflections/goldenGerald.png",
            },
        },
	},

	-- Normal
	["gerald"] = {
		spritePath = "assets/sprites/boxes/game/box1.png",
		scale = .7,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/default.wav" },
	},

	["jimbo"] = {
		spritePath = "assets/sprites/boxes/game/box2.png",
		scale = .75,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/default.wav" },
	},

	["glumbo"] = {
		spritePath = "assets/sprites/boxes/game/box3.png",
		scale = .8,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/default.wav" },
	},

	["jeremy"] = {
		spritePath = "assets/sprites/boxes/game/box4.png",
		scale = .9,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/default.wav" },
	},

	["muncher"] = {
		spritePath = "assets/sprites/boxes/game/box5.png",
		scale = 1,

		screenFlashFadeDuration = 1.2,
		flashScreen = true,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/special.wav" },
	},

	["dylan"] = {
		spritePath = "assets/sprites/boxes/game/box6.png",
		scale = 1.1,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/midsize.wav" },
	},

	["carlos"] = {
		spritePath = "assets/sprites/boxes/game/box7.png",
		scale = 1.2,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/midsize.wav" },
	},

	["goobsterGoobingtonIII"] = {
		spritePath = "assets/sprites/boxes/game/box8.png",
		scale = 1.3,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/midsize.wav" },
	},

	["mark"] = {
		spritePath = "assets/sprites/boxes/game/box9.png",
		scale = 1.4,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/midsize.wav" },
	},

	["frigidWendyhot"] = {
		spritePath = "assets/sprites/boxes/game/box10.png",
		scale = 1.5,

		screenFlashFadeDuration = 1.2,
		flashScreen = true,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/special.wav" },
	},

	["dizzy"] = {
		spritePath = "assets/sprites/boxes/game/box11.png",
		scale = 1.6,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/largesize.wav" },
	},

	["gochged"] = {
		spritePath = "assets/sprites/boxes/game/box12.png",
		scale = 1.7,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/largesize.wav" },
	},

	["mtBox"] = {
		spritePath = "assets/sprites/boxes/game/box13.png",
		scale = 1.8,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/largesize.wav" },
	},

    ["unstable"] = {
        spritePath = "assets/sprites/boxes/game/box14.png",
        scale = 1.9,

        mergeSoundData = { soundPath = "assets/audio/sfx/merge/largesize.wav" },

        shaders = {
            {
                name = "reflection",
                reflectionTexture = "assets/sprites/reflections/box14.png",
            },
        },
    },

	["transcended"] = {
		spritePath = "assets/sprites/boxes/game/box15.png",
		scale = 2,

		screenFlashFadeDuration = 2,
		screenFlashColor = {
			red = 255,
			blue = 255,
			green = 255,
			alpha = 0.5
		},
		flashScreen = true,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/special.wav" },
	},

    ["omnibox"] = {
        spritePath = "assets/sprites/boxes/game/box16.png",
        scale = 2.1,

        mergeSoundData = {
            soundPath = "assets/audio/sfx/merge/box16.wav"
        },

        shaders = {
            {
                name = "box16"
            }
        },
    },

    ["devoided"] = {
        spritePath = "assets/sprites/boxes/game/box17.png",
        scale = 2.2,

        mergeSoundData = { soundPath = "assets/audio/sfx/merge/box17.wav" },

        shaders = {
            {
                name = "reflection",
                reflectionTexture = "assets/sprites/reflections/box17.png",
            },
        },
    },

	["boxOMatter"] = {
		spritePath = "assets/sprites/boxes/game/box18.png",
		scale = 2.3,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/box18.wav" },
	},

	["greatOldGrumpyOne"] = {
		spritePath = "assets/sprites/boxes/game/box19.png",
		scale = 2.35,
	},

	["luckrollBox"] = {
		spritePath = "assets/sprites/boxes/game/box20.png",
		scale = 2.4,

		mergeSoundData = { soundPath = "assets/audio/sfx/merge/box20.wav" },
	},

	["mellowBox"] = {
		spritePath = "assets/sprites/boxes/game/box21.png",
		scale = 2.45,
	},

	["theCollector"] = {
		spritePath = "assets/sprites/boxes/game/box22.png",
		scale = 2.5,
	},

    ["glitcherson"] = {
        spritePath = "assets/sprites/boxes/game/box23.png",
        scale = 2.55,

        shaders = {
            {
                name = "reflection",
                reflectionTexture = "assets/sprites/reflections/box23.png",
            },
        },
    },
}

-- Box 18 fakes
cosmetic["geraldo"] = {
	spritePath = "assets/sprites/boxes/game/box18.png",
	scale = cosmetic["gerald"].scale,
}

cosmetic["jambo"] = {
	spritePath = "assets/sprites/boxes/game/box18_2.png",
	scale = cosmetic["jimbo"].scale,
}

cosmetic["glungus"] = {
	spritePath = "assets/sprites/boxes/game/box18_3.png",
	scale = cosmetic["glumbo"].scale,
}

return cosmetic