# Cito Framework

<div align="center">
  <pre>
   ______  __  ______  ______       
  / ____/ / / /_  __/ / __ \        
 / /     / /   / /   / / / /        
/ /___  / /___/ /_  / /_/ /         
\____/ /_____/\__/  \____/          
  </pre>
  <p><em>A powerful, lightweight module loader for Roblox game development</em></p>
  
  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
  [![Roblox Compatible](https://img.shields.io/badge/Roblox-Compatible-blue.svg)](https://www.roblox.com)
  [![Luau](https://img.shields.io/badge/Language-Luau-blue.svg)](https://luau-lang.org/)
</div>

## 🌟 Features

- **Priority-Based Initialization** - Fine-grained control over module loading order
- **Signal Management** - Built-in event handling for common Roblox events
- **Simple Module Importing** - Clean, easy-to-use module importing system
- **Error Handling** - Robust error handling throughout the framework
- **Type Definitions** - Full type definitions for improved IDE support

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
    local Event = shared.Import("Event")
    
    -- Your initialization code here
    print("Controller initialized!")
    
    -- Example of listening to an event
    Event:Listen("MyEvent", function(message)
        print("Event received: " .. message)
    end)
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

The framework uses a priority system (1-1000) to determine initialization order:

| Priority Range | Constant | Purpose |
|----------------|----------|---------|
| 1-100 | PRIORITY.FIRST / PRIORITY.CORE | Core services (data stores, critical systems) |
| 101-300 | PRIORITY.EARLY | Game systems (world, physics) |
| 301-700 | PRIORITY.NORMAL | Standard gameplay elements |
| 701-900 | PRIORITY.INTERFACE | UI systems |
| 901-1000 | PRIORITY.LATE / PRIORITY.LAST | Non-critical systems |

## 🛠️ Built-in Libraries

- **Event** - Robust cross-server event handling
- **EzShake** - Camera shake implementation
- **ProfileService** - Data persistence ([loleris/ProfileService](https://github.com/MadStudioRoblox/ProfileService))

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
│   │   └── init.server.luau
│   └── shared/            # Shared code
│       ├── Cito/          # Framework core
│       ├── Data/          # Game data
│       └── Libraries/     # Shared libraries
└── default.project.json   # Roblox project configuration
```

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👏 Credits

Created by [Encryptal](https://github.com/REALEncryptal)