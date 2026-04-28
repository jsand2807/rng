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
    Object.Parent = ObjectData.Parent
    Object.Name = ObjectData.Name
    if Type == "NumberValue" then
        Value = math.floor(Value)
    end
    Object.Value = Value
end

function CreateFolder(Table, ObjectData)
    local Folder = Instance.new("Folder")
    Folder.Name = ObjectData.Name
    Folder.Parent = ObjectData.Parent
    for Name, Value in Table do
        local ObjType = GetObjectType(Value)
        local Data = {
            Name = Name,
            Parent = Folder
        }
        if ObjType == "Folder" then
            CreateFolder(Value, Data)
        else
            InitObject(Value, Data)
        end
    end

    return Folder
end

function module.CreateDataObject(Table)
    local DataObject = Instance.new("Folder")

    for Name, Value in Table do
        local ObjType = GetObjectType(Value)
        local Data = {
            Name = Name,
            Parent = DataObject
        }
        if ObjType == "Folder" then
            CreateFolder(Value, Data)
        else
            InitObject(Value, Data)
        end
    end
    
    return DataObject
end

return module