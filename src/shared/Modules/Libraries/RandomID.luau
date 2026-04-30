local module = {}

local alphabet = {}

for i = 48, 57 do --numbers
    table.insert(alphabet, string.char(i))
end

for i = 65, 90 do -- uppercase
    table.insert(alphabet, string.char(i))
end

for i = 97, 122 do --lowercase
    table.insert(alphabet, string.char(i))
end

local rng = Random.new()

function module.GetRandomID(Length: number)
    local str = ""
    
    for i = 1, Length do
        str ..= alphabet[rng:NextInteger(1, #alphabet)]
    end

    return str
end

return module