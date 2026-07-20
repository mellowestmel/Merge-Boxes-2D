-- ~/code/data/dialogue/gerald.lua

--%note Swap in expression-specific portraits here once they're drawn.
local PORTRAIT = "assets/sprites/portraits/gerald/default.png"

return {
    RecruitToShop = {
        [1] = {
            dialogue = "Hey, looks like your box business is growing pretty quickly!",
            sprite = PORTRAIT
        },
        [2] = {
            dialogue = "If you want to speed things up, check out my shop! I've got plenty of upgrades.",
            sprite = PORTRAIT
        },
    },

    Greetings = {
        {
            dialogue = "Hi! Welcome to my shop!",
            sprite = PORTRAIT
        },
        {
            dialogue = "Looking for upgrades? You've come to the right place, friend!",
            sprite = PORTRAIT
        },
        {
            dialogue = "Hey! Welcome in! Need an upgrade? I've got plenty.",
            sprite = PORTRAIT
        },
        {
            dialogue = "Take your time and browse around! No pressure.",
            sprite = PORTRAIT
        },
    },

    BuyItem = {
        {
            dialogue = "Pleasure doing business with you!",
            sprite = PORTRAIT
        },
        {
            dialogue = "That should help you out nicely. Enjoy!",
            sprite = PORTRAIT
        },
        {
            dialogue = "That upgrade should serve you well. Enjoy!",
            sprite = PORTRAIT
        },
        {
            dialogue = "A wise investment, if I do say so myself.",
            sprite = PORTRAIT
        },
        {
            dialogue = "Sold! Good choice.",
            sprite = PORTRAIT
        }
    },

    OutOfStock = {
        {
            dialogue = "Sorry, sold out of that one!",
            sprite = PORTRAIT
        },
        {
            dialogue = "Huh, would you look at that... Nothing left.",
            sprite = PORTRAIT
        },
        {
            dialogue = "I'd sell you more, but I'm out of that one.",
            sprite = PORTRAIT
        },
    },

    TooPoor = {
        {
            dialogue = "Come back when your wallet's a little heavier, friend.",
            sprite = PORTRAIT
        },
        {
            dialogue = "Not quite enough Credits for that one.",
            sprite = PORTRAIT
        },
        {
            dialogue = "I'd give it to you for free, but the shop kinda needs money to run. Sorry, pal!",
            sprite = PORTRAIT
        },
    },

    Farewell = {
        {
            dialogue = "See you around!",
            sprite = PORTRAIT
        },
        {
            dialogue = "Hope to see you again!",
            sprite = PORTRAIT
        },
        {
            dialogue = "Thanks for stopping by!",
            sprite = PORTRAIT
        },
        {
            dialogue = "Come back anytime. I'll always be right here!",
            sprite = PORTRAIT
        },
    },

    Idle = {
        {
            dialogue = "Set up the stand right here by the sandbox years ago. Best spot in the whole park, if you ask me.",
            sprite = PORTRAIT
        },
        {
            dialogue = "You ever meet Frigid Wendyhot? He's the Tier 10. Seems a little shady... Wouldn't fully trust him if I were you.",
            sprite = PORTRAIT
        },
        {
            dialogue = [[Sometimes there's a golden fella zipping 'round the park who looks an awful lot like me. Weird coincidence, huh?]],
            sprite = PORTRAIT
        },
        {
            dialogue = [[Some folks treat boxes like we're just numbers going up. You're not one of 'em. Appreciate that.]],
            sprite = PORTRAIT
        }
    },
}