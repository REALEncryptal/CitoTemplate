local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Type definitions
--[[
    @type ModuleMap
    A mapping of module names to their ModuleScript instances
    Key: module name (string)
    Value: module script instance (ModuleScript)
]]
type ModuleMap = {[string]: ModuleScript}

--[[
    @class LibrarianInstance
    Manages module discovery and provides a simplified importing system
    @field Modules ModuleMap? - Mapping of module names to their instances
    @field Import (moduleName: string) -> any - Function to import modules by name
    @field Init (self: LibrarianInstance, paths: {Instance}) -> () - Initialize the module discovery
]]
type LibrarianInstance = {
    Modules: ModuleMap?,
    Import: (moduleName: string) -> any,
    Init: (self: LibrarianInstance, paths: {Instance}) -> ()
}

local Librarian = {} :: LibrarianInstance

--[[
    Librarian

    Librarian allows the quick and easy importing of modules from a shared context.
    
    Features:
    - Simplified module importing using module names
    - Automatic module discovery from specified paths
    - Global Import function available via shared.Import
    - Error handling for module loading

    Encryptal
    2024-03-20
]]

--[[
    @function Librarian.Import
    Imports a module by name from the modules discovered during initialization
    
    @param moduleName string - The name of the module to import
    @return any - The required module or nil if error occurred
    @error "Cannot import module: Librarian has not been initialized" - If Import called before Init
    @error "Module not found: <moduleName>" - If the requested module doesn't exist
    @error "Failed to require module <moduleName>: <error>" - If the module exists but failed to load
]]
function Librarian.Import(moduleName: string): any
    if not Librarian.Modules then
        error("[Librarian] Cannot import module: Librarian has not been initialized", 2)
        return nil
    end
    
    local moduleScript = Librarian.Modules[moduleName]
    if not moduleScript then
        error("[Librarian] Module not found: " .. moduleName, 2)
        return nil
    end
    
    local success, module = pcall(require, moduleScript)
    if not success then
        error("[Librarian] Failed to require module " .. moduleName .. ": " .. tostring(module), 2)
        return nil
    end
    
    return module
end

--[[
    @function Librarian:Init
    Initializes the Librarian by discovering modules from the provided paths
    
    @param paths {Instance} - Array of Instances to search for modules
    
    Special handling:
    - For ReplicatedStorage.Packages, only direct children are indexed
    - For all other paths, all descendants are searched recursively
    
    After initialization, sets up the global Import function via shared.Import
]]
function Librarian:Init(paths: {Instance})
    assert(paths, "[Librarian] Paths cannot be nil")
    assert(typeof(paths) == "table", "[Librarian] Paths must be a table")
    
    -- Create a new modules table
    Librarian.Modules = {}

    for _, path in ipairs(paths) do
        if not path or not path:IsA("Instance") then
            warn("[Librarian] Invalid path provided, skipping")
            continue
        end

        -- Special handling for ReplicatedStorage.Packages
        if path.Name == "Packages" and path.Parent == ReplicatedStorage then
            -- For Packages, only index direct children (not descendants)
            for _, module in ipairs(path:GetChildren()) do
                if module:IsA("ModuleScript") then
                    -- Check for duplicate module names
                    if Librarian.Modules[module.Name] then
                        warn("[Librarian] Duplicate module name detected: " .. module.Name)
                    end
                    Librarian.Modules[module.Name] = module
                end
            end
            continue    
        end

        -- Process all descendants for other paths
        for _, module in ipairs(path:GetDescendants()) do
            if module:IsA("ModuleScript") then
                -- Check for duplicate module names
                if Librarian.Modules[module.Name] then
                    warn("[Librarian] Duplicate module name detected: " .. module.Name)
                end
                Librarian.Modules[module.Name] = module
            end
        end
    end
    
    -- Set up the global import function
    local success, err = pcall(function()
        shared.Import = Librarian.Import
    end)
    
    if not success then
        warn("[Librarian] Failed to set up global Import function: " .. tostring(err))
    end
end

return Librarian