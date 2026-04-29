local module = {}

function module.new()
    local AuraData = {
        Aura = {
            Name = "",
            MutationOf = nil,
            OneIn = 0
        },
        Date = "",
        Luck = 0,
        Locked = false
    }
end

function module.CreateAura(Inventory: Folder, AuraData: table)
    
end

return module