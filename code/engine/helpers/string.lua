local Module = {}

-- Insert base functions into module
for key, value in pairs(string) do
    Module[key] = value
end

function Module.formatTime(seconds)
    local m = math.floor(seconds / 60)
    local s = seconds % 60
    return string.format("%02d:%02d:%02d", 0, m, s)
end

function Module.formatNumber(number)
    local suffixes = {
        "", "K", "M", "B", "T",
        "Qa", "Qi", "Sx", "Sp", "Oc", "No",
        "Dc", "Ud", "Dd", "Td", "Qad", "Qid",
        "Sxd", "Spd", "Ocd", "Nod", "Vg",
    }

    local abs = math.abs(number)

    if abs < 1000 then
        return tostring(number)
    end

    local index = math.floor(math.log(abs, 1000))

    if index < #suffixes then
        local value = number / (1000 ^ index)

        -- Changes made:
        -- 1. Strips whole-number decimals completely (e.g. 50.00K -> 50K)
        -- 2. Trims trailing zero on single decimals (e.g. 1.50M -> 1.5M)
        return string.format("%.2f%s", value, suffixes[index + 1])
            :gsub("%.00([A-Za-z]+)$", "%1")
            :gsub("0([A-Za-z]+)$", "%1")
    end

    return string.format("%.2e", number)
end

return Module