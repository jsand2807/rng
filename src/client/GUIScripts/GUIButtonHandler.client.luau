local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

local TweenService = game:GetService("TweenService")

local Player = game.Players.LocalPlayer
local Data = Player:WaitForChild("Data")

local MainGUI = Player.PlayerGui:WaitForChild("MainGUI")
local Roll = MainGUI.Roll
local RollButton = Roll.Button

local Notifications = require(Modules.Libraries.Notifications)

local AuraFrame

local debounces = {
    Roll = false
}

function DisplayDeleteWarning()

end

RollButton.MouseButton1Click:Connect(function()
    if debounces.Roll then return end
    
    local AuraList = Remotes.Roll:InvokeServer()

    if AuraList.Failed then
        Notifications.CreateNotification(AuraList, Player)
        return
    end

    debounces.Roll = true
    Roll.Visible = false

    local Info = TweenInfo.new(.5)

    local OpeningTween = TweenService:Create(MainGUI.RollDisplay, Info, {BackgroundTransparency = 0.8})

    OpeningTween:Play()
    OpeningTween.Completed:Wait()

    --[[local function IsFinalAuraDisplayed()
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
    end]]

    for i,v in ipairs(AuraList) do
        local Aura = game.ReplicatedStorage.AuraStuff.Frames:FindFirstChild(v.Name)

        if not Aura then warn("Aura not found! Name: "..v.Name) continue end

        AuraFrame = Aura:Clone()

        AuraFrame.Parent = MainGUI.RollDisplay
        AuraFrame.Position = UDim2.new(0.327, 0, 0.3, 0)

        local TimeBetweenTicks = .05 * (i + 1)

        local Info = TweenInfo.new(TimeBetweenTicks)
        local TweenData = {
            Position = UDim2.new(0.327, 0, 0.35, 0)
        }

        if i == #AuraList then
            AuraFrame.Chances.Visible = true
        end

        Player.PlayerGui.Audio.Click:Play()
        local SwitchTween = TweenService:Create(AuraFrame, Info, TweenData)
        SwitchTween:Play()
        SwitchTween.Completed:Wait()
        Player.PlayerGui.Audio.Click:Stop()
        Player.PlayerGui.Audio.Click.TimePosition = 0
        if i ~= #AuraList then
            AuraFrame:Destroy()
        end
    end

    MainGUI.RollDisplay.Keep.Visible = true
    MainGUI.RollDisplay.Delete.Visible = true
end)

MainGUI.RollDisplay.Keep.Button.MouseButton1Click:Connect(function()
    Remotes.AuraResponse:FireServer(true)

    MainGUI.RollDisplay.Keep.Visible = false
    MainGUI.RollDisplay.Delete.Visible = false
    AuraFrame:Destroy()

    local Info = TweenInfo.new(.5)

    local ClosingTween = TweenService:Create(MainGUI.RollDisplay, Info, {BackgroundTransparency = 1})

    ClosingTween:Play()

    Roll.Visible = true
    
    task.wait(1)
    debounces.Roll = false
end)

MainGUI.RollDisplay.Delete.Button.MouseButton1Click:Connect(function()
    Remotes.AuraResponse:FireServer(false)

    MainGUI.RollDisplay.Keep.Visible = false
    MainGUI.RollDisplay.Delete.Visible = false
    AuraFrame:Destroy()

    local Info = TweenInfo.new(.5)

    local ClosingTween = TweenService:Create(MainGUI.RollDisplay, Info, {BackgroundTransparency = 1})

    ClosingTween:Play()

    Roll.Visible = true
    
    task.wait(1)
    debounces.Roll = false
end)