--[[
    
    Created Sunday, July 6th 2025, 9:34:03 pm
    RealEncryptal
    
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Controller = {
    Priority = 0,
}

local Net
function Controller:Init()
    Net = shared.Import "net"

    Net:RemoteEvent("PlaySound").OnClientEvent:Connect(function(SoundName)
        Controller:PlaySound(SoundName)
    end)
end

function Controller:PlaySound(SoundName:string)
    local Sound = ReplicatedStorage.Assets.Sounds:FindFirstChild(SoundName)
    if not Sound then return end
    
    SoundService:PlayLocalSound(Sound)
end

return Controller