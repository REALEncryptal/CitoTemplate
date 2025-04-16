--[[

    CITO CONTROLLER - SERVER
    A template for a server controller module.

    Init is the function that initializes the controller according to its priority.
    
    Priority determines when this controller is initialized relative to others:
    - Lower numbers initialize earlier (e.g. 100 runs before 500)
    - The default is Constants.PRIORITY.NORMAL (500)
    
    Dependencies is an optional array of module names this controller depends on.
    Specified dependencies will always be initialized before this controller.

    All signals must be placed in the Signals table.

    Encryptal 

--]]

local Controller = {}

-- Initialize the Signals table to store all event handlers
Controller.Signals = {}

-- Priority determines initialization order (lower values initialize first)
-- Using the Constants.PRIORITY table is recommended
Controller.Priority = 500 -- Normal priority (same as Constants.PRIORITY.NORMAL)

-- Local references to imported modules
local Event

function Controller:Init() 
    -- Import dependencies using shared.Import
    -- These will already be available because they're listed in Dependencies
    Event = shared.Import("Event") --example usage of importing a module

    -- Example usage of the Event module - SERVER FIRES EVENT
    task.spawn(function()
        while true do
            -- Fire the event every 5 seconds
            Event:FireAllClients("HelloEvent", "Hello from server!")
            task.wait(1)
        end
    end)
end

-- All signals are now under the Signals table
function Controller.Signals.Update(deltaTime) end -- ran every frame

-- The following signals are server-specific
function Controller.Signals.PlayerAdded(player) 
    print("Player joined: " .. player.Name)
end

function Controller.Signals.PlayerRemoving(player) 
    print("Player left: " .. player.Name)
end

return Controller