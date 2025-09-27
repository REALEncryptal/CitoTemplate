# Cito Framework

<div align="center">
  <pre>
  .oooooo.   ooooo ooooooooooooo   .oooooo.   
 d8P'  `Y8b  `888' 8'   888   `8  d8P'  `Y8b  
888           888       888      888      888 
888           888       888      888      888 
888           888       888      888      888 
`88b    ooo   888       888      `88b    d88' 
 `Y8bood8P'  o888o     o888o      `Y8bood8P'      
  </pre>
  <p><em>A powerful, lightweight module loader for Roblox game development</em></p>
  
  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
  [![Roblox](https://img.shields.io/badge/Roblox-blue.svg)](https://www.roblox.com)
  [![Luau](https://img.shields.io/badge/Language-Luau-blue.svg)](https://luau-lang.org/)
</div>

## 🌟 Features

- **Priority-Based Initialization** - Fine-grained control over module loading order
- **Signal Management** - Built-in event handling for common Roblox events
- **Simple Module Importing** - Clean, easy-to-use module importing system
- **Error Handling** - Robust error handling throughout the framework

## 📋 Installation

1. Use the [Roblox GitHub template](https://github.com/new?template_name=CitoTemplate&template_owner=REALEncryptal)
2. OR clone this repository:
   ```bash
   git clone https://github.com/REALEncryptal/CitoTemplate.git
   ```
3. Open the project in Roblox Studio

## 🚀 Quick Start

### Creating a Controller

```lua
-- src/client/Controllers/YourController.luau
local Controller = {}

Controller.Signals = {}
Controller.Priority = 500 -- Normal priority (default)

function Controller:Init()
    -- Your initialization code here
    print("Controller initialized!")
end

-- Signal handlers
function Controller.Signals.Update(deltaTime)
    -- Called every frame
end

return Controller
```

### Supported Events

Controllers can have the following signal handlers:

| Signal | Client | Server | Description |
|--------|--------|--------|-------------|
| Update | ✓ | ✓ | Called every frame with deltaTime |
| InputBegan | ✓ | ❌ | Called when input is detected |
| InputEnded | ✓ | ❌ | Called when input is no longer detected |
| CharacterAdded | ✓ | ❌ | Called when the local player's character is added |
| CharacterRemoving | ✓ | ❌ | Called when the local player's character is removed |
| PlayerAdded | ✓ | ✓ | Called when a player joins the game |
| PlayerRemoving | ✓ | ✓ | Called when a player leaves the game |

### Importing Modules

```lua
-- Import a module
local MyModule = shared.Import("ModuleName")
```

## 📚 Module Priorities

The framework uses a priority system (1-1000) to determine initialization order. Lower numbers are high priority while high numbers are low priority.
## 🛠️ Built-in Libraries
- **EzShake** - Camera shake implementation
- **ProfileService** - Data persistence ([loleris/ProfileService](https://github.com/MadStudioRoblox/ProfileService))
- + Other libraries are available in the [Packages](Packages) directory.

## 🔍 Example Controllers

- [Client Template Controller](src/client/Controllers/TemplateController.luau)
- [Server Template Controller](src/server/Controllers/TemplateController.luau)

## 📁 Project Structure

```
CitoTemplate/
├── src/
│   ├── client/            # Client-side code
│   │   ├── Controllers/   # Client controllers
│   │   └── init.client.luau  
│   ├── server/            # Server-side code
│   │   ├── Controllers/   # Server controllers
│   │   ├── Libraries/     # Server Libraries
│   │   ├── Data/          # Server Data
│   │   └── init.server.luau
│   └── shared/            # Shared code
│       ├── Cito/          # Framework core
│       ├── Data/          # Game data
│       ├── Libraries/     # Shared libraries
│       ├── Classes/       # Classes
│       └── Utils/         # Smaller Utilities
└── default.project.json   # Roblox project configuration
```

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👏 Credits

Created by [Encryptal](https://github.com/REALEncryptal)