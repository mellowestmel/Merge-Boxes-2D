-- ~/code/data/dialogue/godCat.lua

local NEUTRAL = "assets/sprites/boxes/godcatangry.png"
local HAPPY = "assets/sprites/boxes/godcathappy.png"

local DialogueConstructor = require("code.data.constructors.dialogueConstructor")

return {
    SacrificeUnlockSequence = {
        DialogueConstructor.new("Hark, mortal... thy collection has grown beyond the common realm.", NEUTRAL),
        DialogueConstructor.new("Thou hast reached the twentieth box. Mine eyes have taken notice.", NEUTRAL),
        DialogueConstructor.new("The time has come for thee to offer thy possessions unto the divine flame.", NEUTRAL),
        DialogueConstructor.new("From this day forth, sacrifice shall be granted unto thee.", NEUTRAL),
    },

    Greetings = {
        DialogueConstructor.new("Hark, mortal. Thy presence graces mine sacred domain once more.", NEUTRAL),
        DialogueConstructor.new("What seekest thou today? Guidance, or perhaps a blessing?", NEUTRAL),
    },

    Sacrifice = {
        DialogueConstructor.new("Thy sacrifice has been accepted. Divine favor now flows unto thee.", NEUTRAL),
        DialogueConstructor.new("Then shall this blessing be thine, though its grace shall not last forever.", NEUTRAL),
        DialogueConstructor.new("Use this gift wisely. Its grace shall remain with thee only for a time.", NEUTRAL),
    },

    Farewell = {
        DialogueConstructor.new("Fare thee well, mortal. May fortune follow thy every step.", HAPPY),
        DialogueConstructor.new("Go forth, and continue thy ascent toward greatness.", HAPPY),
        DialogueConstructor.new("I shall remember thy devotion, mortal.", HAPPY),
    },

    Idle = {
        DialogueConstructor.new("The path of ascension is long, yet patience brings its reward.", NEUTRAL),
        DialogueConstructor.new("Many seek divine favor, but few have the will to continue.", NEUTRAL),
        DialogueConstructor.new("The highest peaks are reached only by those who persist.", NEUTRAL),
    },
}