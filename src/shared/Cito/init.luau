--[[

    CITO LOADER
    Requires, initializes, and connects events for all modules.

    Encryptal 

--]]


local Cito = {}
Cito.__index = Cito

local RunService  = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Librarian = require(script.Librarian)

function Cito.new()
	local self = setmetatable({}, Cito)

	self.Controllers = {}

	return self
end

function Cito:Discover(Path)
	self.Paths = Path

	Librarian:Init(self.Paths)

	return self
end

function Cito:PreInit(Path)

	for _, Module in ipairs(Path:GetDescendants()) do
		if not Module:IsA("ModuleScript") then continue end

		Module = require(Module)
		table.insert(self.Controllers, Module)

		if Module.PreInit then
			task.spawn(pcall, Module.PreInit)
		end
	end

	return self
end

function Cito:Init()
	for _, Module in ipairs(self.Controllers) do
		if Module.Init then
			task.spawn(pcall, Module.Init)
		end
	end

	local BuiltFunctions = {
		Update = function(Callback)
			if RunService:IsClient() then
				RunService.RenderStepped:Connect(Callback)
			else
				RunService.Heartbeat:Connect(Callback)
			end
		end,
		InputBegan = function(Callback)
			UserInputService.InputBegan:Connect(Callback)
		end,
		InputEnded = function(Callback)
			UserInputService.InputEnded:Connect(Callback)
		end,
		CharacterAdded = function(Callback)
			game.Players.LocalPlayer.CharacterAdded:Connect(Callback)
		end,
		CharacterRemoving = function(Callback)
			game.Players.LocalPlayer.CharacterRemoving:Connect(Callback)
		end
	}

	for Name, Function in pairs(BuiltFunctions) do
		for _, Module in ipairs(self.Controllers) do
			if not Module[Name] then return end
			task.spawn(pcall, Function(Module[Name]))
		end
	end

	return self
end

return Cito