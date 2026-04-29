local module = {}

local DSS = game:GetService("DataStoreService")
local DataVer = 0
local ExtraStr = DataVer
if game["Run Service"]:IsStudio() then
    ExtraStr ..= "STUDIO"
end

local ConvertTable = require(game.ReplicatedStorage.Shared.Modules.ConvertTable)
local DataTemplate = require(script.DataTemplate)

module.DataStores = {
    PlayerData = DSS:GetDataStore("PlayerData"..ExtraStr)
}

function module.LoadData(Player)
    
end

return module