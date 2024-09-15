local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Librarian = {}

--[[
    Librarian

    Librarian allows the quick and easy importing of modules from a shared context.

    Encryptal
    2024-03-20
]]

function Librarian.Import(Name)
    return require(Librarian.Modules[Name])
end

function Librarian:Init(Paths)
    Librarian.Modules = {}

    for _, Path in ipairs(Paths) do
        if Path.Name == "Packages" and Path.Parent == ReplicatedStorage then
            for _, Module in ipairs(Path:GetChildren()) do
                if Module:IsA("ModuleScript") then
                    Librarian.Modules[Module.Name] = Module
                end
            end
            continue    
        end
        for _, Module in ipairs(Path:GetDescendants()) do
            if Module:IsA("ModuleScript") then
                Librarian.Modules[Module.Name] = Module
            end
        end
    end
    
    shared.Import = Librarian.Import
end

return Librarian