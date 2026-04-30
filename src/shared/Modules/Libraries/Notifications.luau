local module = {}

local NotifDebounces = {}

local TweenService = game:GetService("TweenService")

local ActiveNotifications = {}

function TweenIn(Notification)
    local TweenInfo = TweenInfo.new(.75)

    local Tween = TweenService:Create(Notification, TweenInfo, {TextTransparency = 0})
    Tween:Play()
    Tween.Completed:Wait()
end

function TweenOut(Notification)
    local TweenInfo = TweenInfo.new(.75)

    local Tween = TweenService:Create(Notification, TweenInfo, {TextTransparency = 1})
    Tween:Play()
    Tween.Completed:Wait()
end

function module.CreateNotification(NotifData, Player)
    if NotifDebounces[Player] then return end
    NotifDebounces[Player] = true
    local Notification = script.Notification:Clone()
    Notification.Text = NotifData.Text
    Notification.TextColor3 = NotifData.Color
    local PlayerGui = Player.PlayerGui
    local Container = PlayerGui.Notifications.Container

    Notification.Parent = Container

    local Index = #ActiveNotifications + 1

    ActiveNotifications[Index] = Notification 

    task.spawn(function()
        TweenIn(Notification)
        local ElapsedTime = 0
        while ElapsedTime < .25 do
            ElapsedTime += task.wait()
        end
        NotifDebounces[Player] = nil
        while ElapsedTime < NotifData.Duration do
            ElapsedTime += task.wait()
        end
        TweenOut(Notification)
        Notification:Destroy()
    end)
end

return module