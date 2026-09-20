-- ~/code/data/dialogue/frigidWendyHot.lua

local PORTRAIT = "assets/sprites/boxes/box1.png"

local DialogueConstructor = require("code.data.constructors.dialogueConstructor")

return {
    ShopUnlockSequence = {
        DialogueConstructor.new("Psst... Hey Kid...", PORTRAIT),
        DialogueConstructor.new("Having trouble getting trinkets?", PORTRAIT),
        DialogueConstructor.new("I can help with that. Meet me in that suspicious alleyway over there.", PORTRAIT)
    },

    Greetings = {
        DialogueConstructor.new("'Sup.", PORTRAIT)
    },

    BuyItem = {
        DialogueConstructor.new("Don't ask where I got it.", PORTRAIT),
        DialogueConstructor.new("Pleasure doin' business. Now scram before someone sees us.", PORTRAIT),
        DialogueConstructor.new("Good choice. Don't go tellin' anyone where you got it.", PORTRAIT),
        DialogueConstructor.new("Cha-ching. Now get outta here, you're makin' me nervous.", PORTRAIT)
    },

    OutOfStock = {
        DialogueConstructor.new("Nah, sold outta that. Check back later, kid.", PORTRAIT),
        DialogueConstructor.new("Stock rotates. That one's gone for now.", PORTRAIT),
        DialogueConstructor.new("Not right now. Come back after I restock.", PORTRAIT),
    },

    TooPoor = {
        DialogueConstructor.new("I'm not runnin' a charity here, kid.", PORTRAIT),
        DialogueConstructor.new("Come back when you got s'more o' that C$.", PORTRAIT),
        DialogueConstructor.new("No handouts, kid.", PORTRAIT),
    },

    Farewell = {
        DialogueConstructor.new("Keep your mouth shut and we're square.", PORTRAIT),
        DialogueConstructor.new("See ya 'round. Or not. Depends who's askin'.", PORTRAIT),
        DialogueConstructor.new("Later, kid. Act normal on your way out.", PORTRAIT),
    },
}