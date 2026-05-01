local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Player = game.Players.LocalPlayer
local Data = Player:WaitForChild("Data")

local MainGUI = Player.PlayerGui:WaitForChild("MainGUI")
local Roll = MainGUI.Roll
local RollButton = Roll.Button

local camera = game.Workspace.CurrentCamera

local CinematicFrame1 = Player.PlayerGui:WaitForChild("MainGUI"):WaitForChild("RollDisplay"):WaitForChild("CinematicFrame1")
local CinematicFrame2 = Player.PlayerGui:WaitForChild("MainGUI"):WaitForChild("RollDisplay"):WaitForChild("CinematicFrame2")

local Notifications = require(Modules.Libraries.Notifications)
local BuildGUIOrder = require(Modules.Libraries.BuildGUIOrder)

local AuraFrame

local cameraTweenIn1 = TweenService:Create(camera, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { FieldOfView = 30 })
local cameraTweenIn2 = TweenService:Create(camera, TweenInfo.new(0.75, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { FieldOfView = 30 })
local cameraTweenOut = TweenService:Create(camera, TweenInfo.new(0.75, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { FieldOfView = 70 })

local CinematicFrame1TweenIn = TweenService:Create(CinematicFrame1, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.05, 0) })
local CinematicFrame2TweenIn = TweenService:Create(CinematicFrame2, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.95, 0) })
local CinematicFrame1TweenOut = TweenService:Create(CinematicFrame1, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, -0.05, 0) })
local CinematicFrame2TweenOut = TweenService:Create(CinematicFrame2, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 1.05, 0) })

local InventoryButton = Player.PlayerGui:WaitForChild("MainGUI"):WaitForChild("OpenInventory")
local InventoryFrame = Player.PlayerGui:WaitForChild("MainGUI"):WaitForChild("Inventory")

local MenuBlur = game.Lighting:WaitForChild("MenuBlur")

local InventoryOpenTween = TweenService:Create(InventoryFrame, TweenInfo.new(0.75, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)})
local InventoryCloseTween = TweenService:Create(InventoryFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0.65, 0)})

local MenuBlurTweenIn = TweenService:Create(MenuBlur, TweenInfo.new(0.75, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = 10})
local MenuBlurTweenOut = TweenService:Create(MenuBlur, TweenInfo.new(0.75, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = 0})

local debounces = {
	Roll = false,
	Inventory = false
}

--[[function DisplayDeleteWarning()

end]]

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
	
    if InventoryFrame.Visible then
        InventoryCloseTween:Play()
        InventoryFrame.Visible = false
    end
    InventoryButton.Visible = false
	CinematicFrame1.Visible = true
	CinematicFrame2.Visible = true
	cameraTweenIn1:Play()
    OpeningTween:Play()
	OpeningTween.Completed:Wait()
	CinematicFrame1TweenIn:Play()
	CinematicFrame2TweenIn:Play()
	
	

    --[[local function IsFinalAuraDisplayed() -- used later
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

        AuraFrame.Parent = MainGUI.RollDisplay.CanvasGroup
        AuraFrame.Position = UDim2.new(0.5, 0, -.75, 0)

        local TimeBetweenTicks = .05 * (i + 2)

        local Info = TweenInfo.new(TimeBetweenTicks)
        local TweenData

        if i ~= #AuraList then
            TweenData = {
                Position = UDim2.new(0.5, 0, 1.25, 0)
            }
        else
            AuraFrame.Chances.Visible = true
            TweenData = {
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }
        end

        Player.PlayerGui.Audio.SFX.Click:Play()
        local SwitchTween = TweenService:Create(AuraFrame, Info, TweenData)
        SwitchTween:Play()
        SwitchTween.Completed:Wait()
        Player.PlayerGui.Audio.SFX.Click:Stop()
        Player.PlayerGui.Audio.SFX.Click.TimePosition = 0
        if i ~= #AuraList then
            AuraFrame:Destroy()
        end
	end
	
	CinematicFrame1TweenOut:Play()
	CinematicFrame2TweenOut:Play()
	
    MainGUI.RollDisplay.Keep.Visible = true
    MainGUI.RollDisplay.Delete.Visible = true
end)

function BuildInventory()
    local Inventory = Data:FindFirstChild("Inventory")
    if not Inventory then return end

    for i,v in MainGUI.Inventory.AuraContainer:GetChildren() do
        if v:IsA("Frame") then v:Destroy() end
    end

    local AuraList = {}

    for i,v in Inventory:GetChildren() do
        AuraList[i] = {
            Name = v.Aura:FindFirstChild("Name").Value,
            OneIn = v.Aura.OneIn.Value,
            Luck = v.Luck.Value,
            Date = v.Date.Value,
            Rolls = v.Rolls.Value
        }
    end

    table.sort(AuraList, function(a,b)
        return a.OneIn > b.OneIn
    end)

    for i, aura in AuraList do
        local Frame = game.ReplicatedStorage.AuraStuff.InventorySlots:FindFirstChild(aura.Name)
        if not Frame then warn("Aura not found! Name: "..aura.Name) return end
        local Clone = Frame:Clone()
        Clone.Name = BuildGUIOrder.CreateOrderString(i)
        Clone.Parent = MainGUI.Inventory.AuraContainer
        Clone.Button.MouseButton1Click:Connect(function()
            
        end)
    end
end

BuildInventory()

MainGUI.RollDisplay.Keep.Button.MouseButton1Click:Connect(function()
	cameraTweenOut:Play()
	
    Remotes.AuraResponse:FireServer(true)

    MainGUI.RollDisplay.Keep.Visible = false
    MainGUI.RollDisplay.Delete.Visible = false
    AuraFrame:Destroy()

    local Info = TweenInfo.new(.5)

    local ClosingTween = TweenService:Create(MainGUI.RollDisplay, Info, {BackgroundTransparency = 1})

    ClosingTween:Play()

    BuildInventory()

	Roll.Visible = true
	InventoryButton.Visible = true
    
    task.wait(1)
    debounces.Roll = false
end)

MainGUI.RollDisplay.Delete.Button.MouseButton1Click:Connect(function()
	cameraTweenOut:Play()

    Remotes.AuraResponse:FireServer(false)

    MainGUI.RollDisplay.Keep.Visible = false
    MainGUI.RollDisplay.Delete.Visible = false
    AuraFrame:Destroy()

    local Info = TweenInfo.new(.5)

    local ClosingTween = TweenService:Create(MainGUI.RollDisplay, Info, {BackgroundTransparency = 1})

    ClosingTween:Play()

	Roll.Visible = true
	InventoryButton.Visible = true
    
    task.wait(1)
    debounces.Roll = false
end)

InventoryButton.MouseButton1Click:Connect(function()
	if debounces.Inventory then return end
	
	if InventoryFrame.Visible == false then
		cameraTweenIn2:Play()
		InventoryFrame.Visible = true
		InventoryOpenTween:Play()
		MenuBlurTweenIn:Play()
		debounces.Inventory = true
		task.wait(.75)
		debounces.Inventory = false
	else
		InventoryCloseTween:Play()
		cameraTweenOut:Play()
		MenuBlurTweenOut:Play()
		debounces.Inventory = true
		InventoryCloseTween.Completed:Wait()
		InventoryFrame.Visible = false
		debounces.Inventory = false
	end
end)