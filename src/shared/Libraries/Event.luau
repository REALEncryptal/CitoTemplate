local EventService = {
    _Connections = {}
}

--[[
    Remote Wrapper

    This module is a wrapper for RemoteEvents and RemoteFunctions. It allows for easy communication between the client and server.

    Usage:
    Server:
    :Listen(Name, Callback) - Listens for events and functions
    :FireAllClients(...) - Fires an event to all clients
    :FireClient(Player, ...) - Fires an event to a specific client
    :InvokeClient(Player, ...) - Invokes a function on a specific client
    
    Client:
    :Listen(Name, Callback) - Listens for events and functions
    :FireServer(Name, ...) - Fires an event to the server
    :InvokeServer(Name, ...) - Invokes a function on the server

    Encryptal - 2024 Jun 29 
]]

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Shared functions
function EventService:Listen(EventName, Callback)
    self._Connections[EventName] = self._Connections[EventName] or {}

    table.insert(self._Connections[EventName], Callback)
end

-- Scoped functions
if RunService:IsServer() then
    EventService._RemoteEvent = Instance.new("RemoteEvent")
    EventService._RemoteEvent.Name = "EventServiceRemote"
    EventService._RemoteEvent.Parent = ReplicatedStorage

    EventService._RemoteFunction = Instance.new("RemoteFunction")
    EventService._RemoteFunction.Name = "EventServiceFunction"
    EventService._RemoteFunction.Parent = ReplicatedStorage

    function EventService:FireAllClients(...)
        self._RemoteEvent:FireAllClients(...)
    end

    function EventService:FireClient(...)
        self._RemoteEvent:FireClient(...)
    end

    function EventService:InvokeClient(...)
        return self._RemoteFunction:InvokeClient(...)
    end

    EventService._RemoteEvent.OnServerEvent:Connect(function(Player, EventName, ...)
        if not EventService._Connections[EventName] then return end

        for _, Callback in ipairs(EventService._Connections[EventName]) do
            Callback(Player, ...)
        end
    end)

    EventService._RemoteFunction.OnServerInvoke = function(Player, EventName, ...)
        if not EventService._Connections[EventName] then return end

        for _, Callback in ipairs(EventService._Connections[EventName]) do
            Callback(Player, ...)
        end
    end
else
    EventService._RemoteEvent = ReplicatedStorage:WaitForChild("EventServiceEvent")
    EventService._RemoteFunction = ReplicatedStorage:WaitForChild("EventServiceFunction")

    function EventService:FireServer(EventName, ...)
        self._RemoteEvent:FireServer(EventName, ...)
    end

    function EventService:InvokeServer(EventName, ...)
        return self._RemoteFunction:InvokeServer(EventName, ...)
    end

    EventService._RemoteEvent.OnClientEvent:Connect(function(EventName, ...)
        if not EventService._Connections[EventName] then return end

        for _, Callback in ipairs(EventService._Connections[EventName]) do
            Callback(...)
        end
    end)

    EventService._RemoteFunction.OnClientInvoke = function(EventName, ...)
        if not EventService._Connections[EventName] then return end

        for _, Callback in ipairs(EventService._Connections[EventName]) do
            Callback(...)
        end
    end
end

return EventService