--[[
    Each matrix adjusts the RGB values to simulate how different
    types of color blindness affect color perception.

    Alpha isn't being changed for obvious reasons 
    (Yes, my favorite type of colorblindness, the "makeeverythingslightlytransparent" one)
]]

return {
    none = {},

    protanopia = {
        .567, .433, .000, 0,
        .558, .442, .000, 0,
        .000, .242, .758, 0,
        0,     0,     0,     1
    },

    deuteranopia = {
        .625, .375, .000, 0,
        .700, .300, .000, 0,
        .000, .300, .700, 0,
        0,     0,     0,     1
    },

    tritanopia = {
        .950, .050, .000, 0,
        .000, .433, .567, 0,
        .000, .475, .525, 0,
        0,     0,     0,     1
    }
}