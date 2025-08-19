--[[
    
    Created Tuesday, July 1st 2025, 7:08:57 pm
    RealEncryptal
    
--]]

local Controller = {
    Priority = 0,
    Signals = {},

    Profiles = {},
    InitialData = {}
}

local Players = game:GetService("Players")
local ProfileService, Constants
function Controller:Init()
    ProfileService = shared.Import "ProfileService"
    Constants = shared.Import "Constants"

    Controller.ProfileStore = ProfileService.GetProfileStore(
        "PlayerData",
        Constants.PROFILE_TEMPLATE
    )    

    -- In case Players have joined the server earlier than this script ran:
    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(Controller.Signals.PlayerAdded, player)
    end
end

-- Signals
function Controller.Signals.PlayerAdded(player)
    local profile = Controller.ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
    if profile ~= nil then
        profile:AddUserId(player.UserId) -- GDPR compliance
        profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
        profile:ListenToRelease(function()
            Controller.Profiles[player] = nil
            -- The profile could've been loaded on another Roblox server:

            Constants:Debug("[ProfileController] Player profile released: ", player)
            player:Kick()
        end)
        if player:IsDescendantOf(Players) == true then
            Controller.Profiles[player] = profile
        else
            -- Player left before the profile loaded:
            profile:Release()
        end

        if not Constants.PROFILE_SAVE then
            profile.Data = Constants.PROFILE_TEMPLATE
        end

        -- store initial data for backup
        Controller.InitialData[player] = profile.Data

        -- create interface
        local DataFolder = Controller:DataToFolder(profile.Data)
        DataFolder.Parent = player
        DataFolder.Name = "Data"

        for _, Folder:Folder in ipairs(DataFolder:GetDescendants()) do
            Folder.AttributeChanged:Connect(function()
                profile.Data = Controller:FolderToData(player:FindFirstChild("Data"))
            end)
        end

        -- create leaderstats
        local Leaderstats = Instance.new("Folder")
        Leaderstats.Name = "leaderstats"
        Leaderstats.Parent = player

        for _, DataName in ipairs(Constants.PROFILE_LEADERSTATS) do
            local Value = Instance.new("IntValue")
            Value.Name = DataName
            Value.Value = DataFolder:GetAttribute(DataName)
            Value.Parent = Leaderstats

            DataFolder:GetAttributeChangedSignal(DataName):Connect(function()
                Value.Value = DataFolder:GetAttribute(DataName)
            end)
        end
    end
end

function Controller.Signals.PlayerRemoving(player)
    local profile = Controller.Profiles[player]

    Controller.Profiles[player].Data = Controller:FolderToData(player:FindFirstChild("Data"))
    if player:GetAttribute("DataFailed") then
       Controller.Profiles[player].Data = Controller.InitialData[player] 
    end

    if profile ~= nil then
        profile:Release()
    end
end

function Controller.Signals.PlayerRemoving(player)
    local profile = Controller.Profiles[player]
    Controller.Profiles[player].Data = Controller:FolderToData(player:FindFirstChild("Data"))
    if profile ~= nil then
        profile:Release()
    end
end

-- Data Interface
function Controller:FolderToData(Directory)
    if not Directory then 
        Constants:Debug("[ProfileController] FolderToData: Directory is nil: ", Directory)
        return
    end
    local Data = Directory:GetAttributes()

    for _, Folder in ipairs(Directory:GetChildren()) do
        Data[Folder.Name] = Controller:FolderToData(Folder)
    end

    return Data
end

function Controller:DataToFolder(Data): Folder
    local Folder = Instance.new("Folder")

    for Index, Value in pairs(Data) do
        if type(Value) == "table" then
            local NewFolder = Controller:DataToFolder(Value)
            NewFolder.Name = Index
            NewFolder.Parent = Folder
        else
            Folder:SetAttribute(Index, Value)
        end
    end

    return Folder
end

function Controller:GetProfile(player)
    if player:IsA("Player") then
        return Controller.Profiles[player]
    elseif type(player) == "number" then--userid
        for Player, Profile in pairs(Controller.Profiles) do
            if Player.UserId == player then
                return Profile
            end
        end
    elseif type(player) == "string" then--username
        for Player, Profile in pairs(Controller.Profiles) do
            if Player.Name == player then
                return Profile
            end
        end
    end
end

return Controller