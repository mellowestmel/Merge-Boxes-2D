-- ~/code/data/easing.lua

return {
    easeInOutQuad = function(t)
        if t < .5 then
            return 2 * t * t
        else
            return -1 + (4 - 2 * t) * t
        end
    end,
    easeOutQuad = function(t)
        return t * (2 - t)
    end,
    easeInQuad = function(t)
        return t * t
    end
}