local Modules = game.ReplicatedStorage.Modules
local DataHandler = require(script.Parent.Data.DataHandler)
local SavesOn = false

local loaded = {}

game.Players.PlayerAdded:Connect(function(player)
    DataHandler.LoadData(player)

    loaded[player] = true
end)

game.Players.PlayerRemoving:Connect(function(player)
    if not player:FindFirstChild("Data") then return end
    if not SavesOn then return end
    if not loaded[player] then return end

    DataHandler.SaveData(player, player.Data)

    loaded[player] = nil
end)