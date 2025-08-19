--[[
    
    Created Saturday, July 19th 2025, 10:47:56 pm
    RealEncryptal
    
--]]

-- creates instance if it doesn't exist

return function (Name:string, Type:string, Parent:Instance)
    local ExpectedInstance = Parent:FindFirstChild(Name)
    if ExpectedInstance then return ExpectedInstance end

    ExpectedInstance = Instance.new(Type)
    ExpectedInstance.Name = Name
    ExpectedInstance.Parent = Parent

    return ExpectedInstance
end