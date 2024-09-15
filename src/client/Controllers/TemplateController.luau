--[[

    CITO CONTROLLER
    A template for a controller module.

    PreInit is the first function that runs when all modules are required. Do not use this function to reference other modules.
    Init is the second function that runs when all modules have been preinitialized. Use this function to reference other modules.

    Update, InputBegan, InputEnded, CharacterAdded, and CharacterRemoving are roblox events that are built in to the controller.
    These events are connected to the controller before preinit is ran.

    Encryptal 

--]]

local Controller = {}

function Controller:PreInit() end -- ran after all modules are loaded

function Controller:Init() end -- ran after all controllers are pre-initialized

function Controller.Update(deltaTime) end -- ran every frame

function Controller.InputBegan(input, gameProccessed) end -- ran when input is detected

function Controller.InputEnded(input, gameProccessed) end -- ran when input is no longer detected

function Controller.CharacterAdded(character) end -- ran when the character is added

function Controller.CharacterRemoving(character) end -- ran when the character is removed

return Controller