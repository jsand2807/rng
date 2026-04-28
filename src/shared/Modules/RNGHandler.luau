local module = {}

local Auras = require(script.Parent.Auras)

function GetFirstSuitableAura(luck)
	for i = 1, #Auras.RaritiesInOrder do
		if luck >= Auras.RaritiesInOrder[i] then
			continue
		else
			return math.max(1, i - 1)
		end
	end
	return #Auras.RaritiesInOrder
end

function module.GetRandomAura(luck)
	local MinimumIndex = GetFirstSuitableAura(luck)
	local weights = {}
	local totalWeight = 0
	for i = MinimumIndex, #Auras.RaritiesInOrder do
		weights[i] = math.min(1, luck / Auras.RaritiesInOrder[i])
		totalWeight += weights[i]
	end
	local Random = Random.new():NextNumber(0, totalWeight)
	for i = MinimumIndex, #Auras.RaritiesInOrder do
		if Random > weights[i] then
			Random -= weights[i]
		else
			return Auras.AuraInfo[i]
		end
	end
end

return module
