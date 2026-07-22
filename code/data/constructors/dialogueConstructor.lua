-- ~/code/data/constructors/dialogueConstructor.lua

local Module = {}

function Module.new(text, spritePath)
    assert(type(text) == "string", "Dialogue requires text")

    return {
        dialogue = text,
        sprite = spritePath
    }
end

return Module