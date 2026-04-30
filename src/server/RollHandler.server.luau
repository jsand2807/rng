local Modules = game.ReplicatedStorage.Modules
local RNGHandler = require(Modules.RNGHandler)
local CreateAura = require(Modules.CreateAura)
local RandomID = require(Modules.Libraries.RandomID)

local Remotes = game.ReplicatedStorage.Remotes
local RollEvent = Remotes.Roll
local ResponseEvent = Remotes.AuraResponse

local PlayerDebounces = {}
local ResponseDebounces = {}

local PendingResponse = {}

game.Players.PlayerAdded:Connect(function(player)
    PlayerDebounces[player] = false
end)

game.Players.PlayerRemoving:Connect(function(player)
    PlayerDebounces[player] = nil
end)

RollEvent.OnServerInvoke = function(player)
    if PlayerDebounces[player] then 
        local NotifData = {
            Text = "Please wait a second!",
            Color = Color3.new(0.792156, 0.054901, 0.054901),
            Duration = 7.5,
            Failed = true
        }
        return NotifData
    end

    local Data = player:FindFirstChild("Data")
    if not Data then player:Kick("Error: No data found!") end

    local MaxInventory = Data.Stats.MaxInventory.Value

    if #Data.Inventory:GetChildren() == MaxInventory then
        local NotifData = {
            Text = "[Warning] Inventory is full!",
            Color = Color3.new(0.792156, 0.054901, 0.054901),
            Duration = 7.5,
            Failed = true
        }
        return NotifData
    end
    
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
        Locked = false,
        ID = RandomID.GetRandomID(15)
    }

    PendingResponse[player] = AuraData

    return AuraList
end

ResponseEvent.OnServerEvent:Connect(function(player, response)
    if not PendingResponse[player] then
        warn("Pending response not found! Try again")
        return
    end
    if ResponseDebounces[player] then
        return
    end
    ResponseDebounces[player] = true
    if response then
        CreateAura.AddAura(player.Data.Inventory, PendingResponse[player])
    end
    PendingResponse[player] = nil
    task.delay(.5, function()
        ResponseDebounces[player] = nil
    end)
end)