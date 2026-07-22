-- ~/code/data/dialogue/gerald.lua

--%note Swap in expression-specific portraits here once they're drawn.
local PORTRAIT = "assets/sprites/portraits/gerald/default.png"

local DialogueConstructor = require("code.data.constructors.dialogueConstructor")

return {
    ShopUnlockSequence = {
        DialogueConstructor.new("Hey, looks like your box business is growing pretty quickly!", PORTRAIT),
        DialogueConstructor.new("If you want to speed things up, check out my shop! I've got plenty of upgrades.", PORTRAIT)
    },

    Greetings = {
        DialogueConstructor.new("Hi! Welcome to my shop!", PORTRAIT),
        DialogueConstructor.new("Looking for upgrades? You've come to the right place, friend!", PORTRAIT),
        DialogueConstructor.new("Hey! Welcome in! Need an upgrade? I've got plenty.", PORTRAIT),
        DialogueConstructor.new("Take your time and browse around! No pressure.", PORTRAIT),
    },

    BuyItem = {
        DialogueConstructor.new("Pleasure doing business with you!", PORTRAIT),
        DialogueConstructor.new("That should help you out nicely. Enjoy!", PORTRAIT),
        DialogueConstructor.new("That upgrade should serve you well. Enjoy!", PORTRAIT),
        DialogueConstructor.new("A wise investment, if I do say so myself.", PORTRAIT),
        DialogueConstructor.new("Sold! Good choice.", PORTRAIT)
    },

    OutOfStock = {
        DialogueConstructor.new("Sorry, sold out of that one!", PORTRAIT),
        DialogueConstructor.new("Huh, would you look at that... Nothing left.", PORTRAIT),
        DialogueConstructor.new("I'd sell you more, but I'm out of that one.", PORTRAIT),
    },

    TooPoor = {
        DialogueConstructor.new("Come back when your wallet's a little heavier, friend.", PORTRAIT),
        DialogueConstructor.new("Not quite enough Credits for that one.", PORTRAIT),
        DialogueConstructor.new("I'd give it to you for free, but the shop kinda needs money to run. Sorry, pal!", PORTRAIT),
    },

    Farewell = {
        DialogueConstructor.new("See you around!", PORTRAIT),
        DialogueConstructor.new("Hope to see you again!", PORTRAIT),
        DialogueConstructor.new("Thanks for stopping by!", PORTRAIT),
        DialogueConstructor.new("Come back anytime. I'll always be right here!", PORTRAIT),
    },

    Idle = {
        DialogueConstructor.new("Set up the stand right here by the sandbox years ago. Best spot in the whole park, if you ask me.", PORTRAIT),
        DialogueConstructor.new("You ever meet Frigid Wendyhot? He's the Tier 10. Seems a little shady... Wouldn't fully trust him if I were you.", PORTRAIT),
        DialogueConstructor.new([[Sometimes there's a golden fella zipping 'round the park who looks an awful lot like me. Weird coincidence, huh?]], PORTRAIT),
        DialogueConstructor.new([[Some folks treat boxes like we're just numbers going up. You're not one of 'em. Appreciate that.]], PORTRAIT)
    },
}