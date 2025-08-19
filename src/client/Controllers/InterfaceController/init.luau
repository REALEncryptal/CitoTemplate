--[[
    
    Created Friday, July 4th 2025, 12:04:04 am
    RealEncryptal
    
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Controller = {
    Priority = 50,
    Signals = {},
    Interfaces = {},
}

local SoundController
function Controller:Init()
    SoundController = shared.Import "SoundController"

    Controller.Instance = Players.LocalPlayer.PlayerGui:WaitForChild("Interface")

    Controller.ActiveFrame = nil

    for _, InterfaceModule in ipairs(script:GetChildren()) do
        Controller.Interfaces[InterfaceModule.Name] = InterfaceModule
    end

    Controller:InitInterfaces({})
end

function Controller:InitInterfaces(Interfaces: {string})
    for _, Interface in ipairs(Interfaces) do
        print("  [InterfaceController] Initializing " .. Interface)
        Controller.Interfaces[Interface] = require(Controller.Interfaces[Interface])
        Controller.Interfaces[Interface]:Init(Controller)
    end
end

--

function Controller:CreateFrameToggle(Frame:Frame): ()
    local Toggled = false
    Frame.Visible = false

    local GoalPosition = Frame.Position
    local OutPosition = UDim2.new(
        GoalPosition.X.Scale,
        GoalPosition.X.Offset,
        GoalPosition.Y.Scale,
        GoalPosition.Y.Offset + 100
    )
    local TweenInfoIn = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local TweenInfoOut = TweenInfo.new(0.1)

    local ShowTween = TweenService:Create(Frame, TweenInfoIn, {Position = GoalPosition})
    local HideTween = TweenService:Create(Frame, TweenInfoOut, {Position = OutPosition})

    HideTween.Completed:Connect(function()
        Frame.Visible = false
    end)

    HideTween:Play()
    
    local Toggle
    Toggle = function()
        if Controller.ActiveFrame and Controller.ActiveFrame ~= Toggle then
            Controller.ActiveFrame()
        end

        if Toggled then
            Frame.Visible = false-- temp
            HideTween:Play()
            Controller.ActiveFrame = nil
        else
            ShowTween:Play()
            Frame.Visible = true
            Controller.ActiveFrame = Toggle
        end

        Toggled = not Toggled
    end

    return Toggle
end

function Controller:AnimateButton(Button:GuiButton, AffectedInstance:GuiObject?, HoverScale:number?, ClickScale:number)
    AffectedInstance = AffectedInstance or Button
    local HoverScale = HoverScale or 1.04
    local ClickScale = ClickScale or 0.96

    local InitialSize = AffectedInstance.Size

    local HoverSize = UDim2.new(
        InitialSize.X.Scale * HoverScale,
        InitialSize.X.Offset,
        InitialSize.Y.Scale * HoverScale,
        InitialSize.Y.Offset
    )

    local ClickSize = UDim2.new(
        InitialSize.X.Scale * ClickScale,
        InitialSize.X.Offset,
        InitialSize.Y.Scale * ClickScale,
        InitialSize.Y.Offset
    )

    local TweenInfoInitial = TweenInfo.new(0.1)
    local TweenInfoHover = TweenInfo.new(0.1)
    local TweenInfoClick = TweenInfo.new(0.1)

    local InitialTween = TweenService:Create(AffectedInstance, TweenInfoInitial, {Size = InitialSize})
    local HoverTween = TweenService:Create(AffectedInstance, TweenInfoHover, {Size = HoverSize})
    local ClickTween = TweenService:Create(AffectedInstance, TweenInfoClick, {Size = ClickSize})

    ClickTween.Completed:Connect(function()
        InitialTween:Play()
    end)

    Button.MouseButton1Down:Connect(function()
        ClickTween:Play()
        SoundController:PlaySound("UIDown")
    end)

    Button.Activated:Connect(function()
        SoundController:PlaySound("UIClick")
    end)

    Button.MouseEnter:Connect(function()
        SoundController:PlaySound("UIHoverIn")
        HoverTween:Play()
    end)

    Button.MouseLeave:Connect(function()
        SoundController:PlaySound("UIHoverOut")
        InitialTween:Play()
    end)
end

-- 
function Controller.Signals.Update(DeltaTime:number)
    for InterfaceName, Interface in pairs(Controller.Interfaces) do
        if not Interface.Update then continue end
        local Success, Message = pcall(function()
            Interface.Update(DeltaTime)
        end)
        if not Success then
            warn("[InterfaceController] Interface update failed for " .. InterfaceName .. ": " .. Message)
        end
    end
end

return Controller