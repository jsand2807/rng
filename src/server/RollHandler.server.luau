local Modules = game.ReplicatedStorage.Modules
local RNGHandler = require(Modules.RNGHandler)
local CreateAura = require(modules.CreateAura)

local Remotes = game.ReplicatedStorage.Remotes
local RollEvent = Remotes.Roll

local PlayerDebounces = {}

game.Players.PlayerAdded:Connect(function(player)
    PlayerDebounces[player] = false
end)

game.Players.PlayerRemoving:Connect(function(player)
    PlayerDebounces[player] = nil
end)

RollEvent.OnServerInvoke = function(player)
    if PlayerDebounces[player] then return end

    local Data = player:FindFirstChild("Data")
    if not Data then player:Kick("Error: No data found!") end
    
    PlayerDebounces[player] = true

    local IsFastRoll = Data.Products:FindFirstChild("FastRoll").Value and Data.Settings:FindFirstChild("FastRollEnabled").Value
    
    local CalculatedLuck = 1

    local ListLength = 8
    if IsFastRoll then ListLength = 1 end
    local AuraList = {}
    local FinalAura = RNGHandler.GetRandomAura(CalculatedLuck)

    if ListLength > 1 then
        for i = 1, ListLength - 1 do
            AuraList[i] = RNGHandler.GetRandomAura(CalculatedLuck)
        end
    end
    AuraList[ListLength] = FinalAura

    task.delay(1, function()
        PlayerDebounces[player] = false
    end)

    Data.Stats.Rolls.Value += 1

    local AuraData = {
        Aura = FinalAura,
        Date = os.date(),
        Luck = CalculatedLuck,
        Locked = false
    }

    CreateAura(Data.Inventory, FinalAura)

    return AuraList
end