local Controller = {
    Priority = 0,
}

local Net
function Controller:Init()
    Net = shared.Import "net"

    Net:RemoteEvent("PlaySound")
end

return Controller