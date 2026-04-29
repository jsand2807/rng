local module = {}

function module.new()
    local Data = {
        Inventory = {},
        Boosts = {},
        Stats = {
            Rolls = 0,
            CollectedStat = 0,
            MaxInventory = 20,
            Coins = 0
        },
        Collected = {},
        Products = {
            FastRoll = false
        },
        Settings = {
            AutoRollEnabled = false,
            FastRollEnabled = false,
            DeleteWarningRarity = 1000,
            SwapWarningRarity = 1000,
            AutoEquipRarity = 250,
            CutsceneSkipRarity = 250
        }
    }
    return Data
end

return module