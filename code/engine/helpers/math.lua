local Module = {}

-- Insert base functions into module
for key, value in pairs(math) do
    Module[key] = value
end

-- Simple lerp
function Module.lerp(a, b, factor)
    return a + (b - a) * factor
end

-- Simple clamp
function Module.clamp(x, min, max)
    return math.max(min, math.min(x, max))
end

-- Simple round
function Module.round(x, place)
    local factor = 10 ^ (place or 0)
    return math.floor(x * factor + 0.5) / factor
end

-- Get sign
function Module.sign(x)
    if x > 0 then return 1 elseif x < 0 then return -1 else return 0 end
end

-- Get distance between two points in a 2D space
function Module.distance2D(x1, y1, x2, y2)
    x1 = x1 or 0
    y1 = y1 or 0
    x2 = x2 or 0
    y2 = y2 or 0

    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

-- Performs a bitwise XOR operation on two integers (0-255)
-- Returns a new integer where each bit is set to 1 if the corresponding bits of 'a' and 'b' are different, 0 if they are the same.
-- Example: xorByte(6, 3) -> 5
-- 6 = 110 (binary), 3 = 011 (binary), XOR = 101 (binary) = 5

function Module.xorByte(a, b)
    local result = 0
    local bitval = 1

    while a > 0 or b > 0 do
        local abit = a % 2
        local bbit = b % 2

        if (abit + bbit) == 1 then
            result = result + bitval
        end

        a = math.floor(a / 2)
        b = math.floor(b / 2)
        bitval = bitval * 2
    end

    return result
end

return Module