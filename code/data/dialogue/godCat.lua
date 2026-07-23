-- ~/code/data/dialogue/godCat.lua

local NEUTRAL = "assets/sprites/portraits/godCat/neutral.png"
local HAPPY = "assets/sprites/portraits/godCat/happy.png"

local DialogueConstructor = require("code.data.constructors.dialogueConstructor")

return {
    SacrificeUnlockSequence = {
        DialogueConstructor.new("Hark, mortal... thy collection hath grown beyond the common realm.", NEUTRAL),
        DialogueConstructor.new("Thou hast reached the twentieth box, and mine eyes have taken notice.", NEUTRAL),
        DialogueConstructor.new("The time hath come for thee to offer thy possessions unto the divine flame.", NEUTRAL),
        DialogueConstructor.new("From this day forth, sacrifice shall be granted unto thee.", NEUTRAL),
    },

    ShopUnlockSequence = {
        DialogueConstructor.new("Incredible... thou hast reached the twenty-fifth box.", NEUTRAL),
        DialogueConstructor.new("The highest realm hath opened before thee.", NEUTRAL),
        DialogueConstructor.new("Thou may now sacrifice this pinnacle of creation for Holy Catnip.", HAPPY),
        DialogueConstructor.new("With this sacred currency, thou may purchase blessings from mine hidden shop.", NEUTRAL),
        DialogueConstructor.new("Use it wisely, for Holy Catnip is no ordinary herb.", HAPPY),
    },

    Greetings = {
        DialogueConstructor.new("Hark, mortal. Thy presence hath once more graced mine sacred domain.", NEUTRAL),
        DialogueConstructor.new("The Great Cat Above observeth thy journey. Continue thy pursuit of greatness.", NEUTRAL),
        DialogueConstructor.new("What seeketh thee today? Guidance, or perhaps a blessing from beyond?", NEUTRAL),
    },

    Sacrifice = {
        DialogueConstructor.new("Thy sacrifice hath been accepted. The divine favor floweth unto thee.", NEUTRAL),
        DialogueConstructor.new("Then shall this blessing be thine, though its grace shall not last forever.", NEUTRAL),
        DialogueConstructor.new("Use this gift wisely, for its grace shall remain with thee only for a time.", NEUTRAL),
    },

    Farewell = {
        DialogueConstructor.new("Fare thee well, mortal. May fortune follow thy every step.", HAPPY),
        DialogueConstructor.new("Go forth and continue thy ascent toward greatness.", HAPPY),
        DialogueConstructor.new("I shall remember thy devotion, mortal.", HAPPY),
    },

    Idle = {
        DialogueConstructor.new("The path of ascension is long, yet patience bringeth reward.", NEUTRAL),
        DialogueConstructor.new("Many seek divine favor, but few possess the resolve to continue.", NEUTRAL),
        DialogueConstructor.new("The highest peaks are reached only by those who persist.", NEUTRAL),
    },

    BuyItem = {
        DialogueConstructor.new("Then shall this blessing be thine.", NEUTRAL),
        DialogueConstructor.new("The blessing is thine. May it bring fortune to thy paws.", NEUTRAL),
        DialogueConstructor.new("Another blessing departs my infinite vaults and enters thy care.", NEUTRAL),
    },

    SacrificeIdle = {
        DialogueConstructor.new("Many boxes hath passed through these halls, yet few reach enlightenment.", NEUTRAL),
        DialogueConstructor.new("The journey upward is long, but the reward is most sacred.", NEUTRAL),
        DialogueConstructor.new("Even a mighty cat must wait patiently for the perfect nap.", HAPPY),
    },

    ShopIdle = {
        DialogueConstructor.new("Thy Holy Catnip shineth with divine promise. Spend it with wisdom.", NEUTRAL),
        DialogueConstructor.new("Prithee, take thy time. Even the finest hunters must choose their prey carefully.", NEUTRAL),
        DialogueConstructor.new("The sacred shelves are prepared. What blessing shall thou claim?", NEUTRAL),
    },
}