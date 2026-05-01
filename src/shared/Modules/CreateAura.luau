local module = {}

local ConvertTable = require(game.ReplicatedStorage.Modules.Libraries.ConvertTable)
local RandomID = require(game.ReplicatedStorage.Modules.Libraries.RandomID)

function module.new()
    local AuraData = {
        Aura = {
            Name = "",
            MutationOf = nil,
            OneIn = 0
        },
        Date = "",
        Luck = 0,
        Locked = false,
        ID = "",
        Rolls = 0
    }
end

function module.AddAura(Inventory: Folder, AuraData: table)
    local Object
    local s,e = pcall(function()
        Object = ConvertTable.CreateDataObject(AuraData)
        Object.Name = AuraData.ID
        Object.Parent = Inventory
    end)
    
    if not s then warn(e) return false end

    return true, Object
end

return module