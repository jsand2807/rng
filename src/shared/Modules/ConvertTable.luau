local module = {}

function Type(Value)
    return typeof(Value)
end

function GetObjectType(Value)
    if Type(Value) == "string" then
        return "StringValue"
    elseif Type(Value) == "boolean" then
        return "BoolValue"
    elseif Type(Value) == "number" then
        if tonumber(Value) % 1 == 0 then
            return "IntValue"
        end
        return "NumberValue"
    end
    return "Folder"
end

function InitObject(Value, ObjectData)
    local Type = GetObjectType(Value)
    local Object = Instance.new(Type)
    Object.Parent = ObjectData.ParentObject
    Object.Name = ObjectData.ObjectName
    Object.Value = ObjectData.ObjectValue
end

function module.CreateDataObject(Table)
    
end

return module