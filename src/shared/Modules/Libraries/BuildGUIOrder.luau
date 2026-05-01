local module = {}

local alphabet = {}

for i = 0, 25 do
    alphabet[i + 1] = string.char(65 + i)
end

function module.CreateOrderString(Number)
    local FirstLetter = math.floor(Number / 26^2) + 1
    local SecondLetter = math.floor(Number / 26) % 26 + 1
    local LastLetter = 1 + (Number % 26)
    local str = ""
    str ..= alphabet[FirstLetter]
    str ..= alphabet[SecondLetter]
    str ..= alphabet[LastLetter]
    return str
end

return module