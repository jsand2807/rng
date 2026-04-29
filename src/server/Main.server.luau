local Modules = game.ReplicatedStorage.Modules
local DataHandler = require(script.Parent.Data.DataHandler)

game.Players.PlayerAdded:Connect(function(Player)
    DataHandler.LoadData(Player)
end)

game.Players.PlayerRemoving:Connect(function(Player)
    if not Player:FindFirstChild("Data") then return end
    DataHandler.SaveData(Player, Player.Data)
end)