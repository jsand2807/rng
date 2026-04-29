local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

local TweenService = game:GetService("TweenService")

local Player = game.Players.LocalPlayer
local Data = Player:WaitForChild("Data")

local MainGUI = Player.PlayerGui
local Roll = MainGUI.Roll
local RollButton = Roll.Roll

local debounces = {
    Roll = false
}

function DisplayWarning()

end

RollButton.MouseButton1Click:Connect(function()
    if debounces.Roll then return end
    debounces.Roll = true

    local AuraList = Remotes.Roll:InvokeServer()

    local Info = TweenInfo.new(.5)

    local OpeningTween = TweenService:Create(MainGUI.RollDisplay, Info, {BackgroundTransparency = 0.8})

    OpeningTween:Play()
    OpeningTween.Completed:Wait()

    local function IsFinalAuraDisplayed()
        local Rarity = AuraList[#AuraList].OneIn
        if Data.Settings.AutoRollEnabled.Value then
            if Rarity >= Data.Settings.DeleteWarningRarity.Value then
                DisplayWarning()
                return true
            end
            if Rarity >= Data.Settings.SwapWarningRarity.Value and Rarity >= Data.Settings.AutoEquipRarity.Value then
                return true
            end
            return false
        end
        return true
    end    

    for i,v in ipairs(AuraList) do
        local AuraFrame = game.ReplicatedStorage.AuraStuff.Frames:FindFirstChild(v.Name)

        local TimeBetweenTicks = .25
    end
end)