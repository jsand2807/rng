local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")

local Player = game.Players.LocalPlayer
local Data = Player:WaitForChild("Data")

local PlayerGui = Player.PlayerGui
local MainGUI = PlayerGui:WaitForChild("MainGUI")

local dt = 0.25

while true do
    task.wait(dt)
end