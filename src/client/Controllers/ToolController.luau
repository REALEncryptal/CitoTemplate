local Controller = {
    Priority = 100,
    Signals = {}
}

function Controller:Init()
    print("Hello from the other side")
end

return Controller