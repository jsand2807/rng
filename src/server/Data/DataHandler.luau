local module = {}

local DSS = game:GetService("DataStoreService")
local DataVer = 0
local ExtraStr = DataVer
if game["Run Service"]:IsStudio() then
    ExtraStr ..= "STUDIO"
end

local ConvertTable = require(game.ReplicatedStorage.Modules.Libraries.ConvertTable)
local DataTemplate = require(script.Parent.DataTemplate)

module.DataStores = {
    PlayerData = DSS:GetDataStore("PlayerData"..ExtraStr)
}

function module.LoadData(Player)
    local ID = Player.UserId
    local Data = DataTemplate.new()
    local Saved = module.DataStores.PlayerData:GetAsync(ID)

    if Saved then
        Data = Saved
    end
    
    local DataObject = ConvertTable.CreateDataObject(Data)
    DataObject.Name = "Data"
    DataObject.Parent = Player

    print("Loaded "..Player.Name.."'s data successfully")
end

function module.SaveData(Player, Data)
    local ID = Player.UserId
    local DataTable = ConvertTable.CreateTable(Data)

    module.DataStores.PlayerData:SetAsync(ID, DataTable)

    print("Saved "..Player.Name.."'s data successfully")
end

return module