# Bothax Helper Functions

**A lightweight helper library built on top of the Bothax API.**
Simplify your scripts with reusable functions for movement, pathfinding, inventory management, floating object collection, and world navigation.

![API](https://img.shields.io/badge/API-Bothax-blue?style=for-the-badge)
![Language](https://img.shields.io/badge/Language-Lua-success?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Stable-brightgreen?style=for-the-badge)

---

## 📥 Installation

Load the helper library once before using any function.

```lua
pcall(load(MakeRequest("https://raw.githubusercontent.com/zydsc/b0th4x/refs/heads/main/call-Api.lua", "GET").content))
```

After loading, all helper functions become available globally.

---

## 📚 API Reference

| Function | Description |
|---|---|
| `disconnect()` | Check whether the bot is disconnected. |
| `getBotTile()` | Get the bot's current tile position. |
| `paths(x, y)` | Smart BFS pathfinding to a destination tile. |
| `Sleeps(min, max)` | Randomized sleep helper. |
| `scanObject(id)` | Count floating objects by item ID. |
| `inventory(id)` | Get the amount of an item in inventory. |
| `collect(id)` | Collect nearby floating objects. |
| `getFloat(id)` | Automatically pathfind and collect floating objects. |
| `isInsideDoor()` | Check whether the bot is inside a door. |
| `inWhiteDoor()` | Check whether the bot is inside a white door. |
| `joinWorldWithDoorId(world, id)` | Join a world through a specific Door ID. |

---

## `disconnect()`

Returns whether the bot is currently disconnected.

### Returns

| Type | Description |
|---|---|
| `boolean` | `true` if disconnected, otherwise `false`. |

### Example

```lua
if disconnect() then
    LogToConsole("Bot disconnected.")
    return
end
```

---

## `getBotTile()`

Returns the bot's current tile coordinates.

### Returns

| Type | Description |
|---|---|
| `number` | X tile |
| `number` | Y tile |

### Example

```lua
local x, y = getBotTile()
LogToConsole("Current Tile: " .. x .. ", " .. y)
```

---

## `paths(targetX, targetY)`

A smart pathfinding helper built on top of the Bothax API.

Unlike the native `FindPath()` function, which simply attempts to walk toward a destination, `paths()` first searches for the shortest valid route before moving.

Internally, it uses the Breadth-First Search (BFS) algorithm to explore all reachable tiles around the bot until the destination is found. After a route has been calculated, the helper reconstructs the path and walks through each tile one by one. This makes movement more reliable, especially when obstacles or complicated layouts are present.

### Features

- 🧠 Smart BFS pathfinding.
- 📍 Finds the shortest reachable route.
- 🚧 Avoids blocked or non-walkable tiles.
- 🔄 Automatically reconstructs the complete path.
- 🚶 Walks tile-by-tile until the destination is reached.
- ⚡ Easy to use — only destination coordinates are required.

### Parameters

| Name | Type | Description |
|---|---|---|
| `targetX` | `number` | Destination X tile |
| `targetY` | `number` | Destination Y tile |

### Example

```lua
paths(45, 20)
```

---

## `Sleeps(min, max)`

Sleeps for a random duration. Useful for making scripts appear more natural.

### Parameters

| Name | Type | Description |
|---|---|---|
| `min` | `number` | Minimum delay (ms) |
| `max` | `number` | Maximum delay (ms) |

### Example

```lua
Sleeps(300, 500)
```

---

## `scanObject(id)`

Counts all floating objects with the specified item ID.

### Parameters

| Name | Type | Description |
|---|---|---|
| `id` | `number` | Item ID |

### Returns

| Type | Description |
|---|---|
| `number` | Total floating items found. |

### Example

```lua
local gems = scanObject(112)
LogToConsole(gems)
```

---

## `inventory(id)`

Returns the amount of an item currently stored in the inventory.

### Parameters

| Name | Type | Description |
|---|---|---|
| `id` | `number` | Item ID |

### Returns

| Type | Description |
|---|---|
| `number` | Inventory amount. |

### Example

```lua
local amount = inventory(112)
LogToConsole(amount)
```

---

## `collect(id)`

Collects nearby floating objects with the specified item ID.

### Parameters

| Name | Type | Description |
|---|---|---|
| `id` | `number` | Item ID |

### Example

```lua
collect(112)
```

---

## `getFloat(id)`

Automatically searches, pathfinds, and collects floating objects.

Collection stops automatically when:

- Inventory reaches 200 of the specified item.
- No more matching floating objects exist.

### Parameters

| Name | Type | Description |
|---|---|---|
| `id` | `number` | Item ID |

### Example

```lua
getFloat(112)
```

---

## `isInsideDoor()`

Checks whether the bot is currently standing inside a door.

### Returns

| Type | Description |
|---|---|
| `boolean` | Door status. |

### Example

```lua
if isInsideDoor() then
    LogToConsole("Inside door.")
end
```

---

## `inWhiteDoor()`

Checks whether the bot is standing inside a white door.

### Returns

| Type | Description |
|---|---|
| `boolean` | `true` if standing inside a white door. |

### Example

```lua
if inWhiteDoor() then
    LogToConsole("Waiting...")
end
```

---

## `joinWorldWithDoorId(world, id)`

Automatically joins a world through a specified Door ID. The helper continuously sends join requests until the bot successfully enters the destination world.

### Parameters

| Name | Type | Description |
|---|---|---|
| `world` | `string` | Target world name |
| `id` | `string \| number` | Door ID |

### Returns

| Type | Description |
|---|---|
| `boolean` | `true` after successfully entering the world. |

### Examples

Join a world using a numeric Door ID:

```lua
joinWorldWithDoorId("BUYGEMS", "123")
```

Join a world using a text Door ID:

```lua
joinWorldWithDoorId("FARMWORLD", "KEYDOORID")
```

---

## 🚀 Complete Example

```lua
pcall(load(MakeRequest("https://raw.githubusercontent.com/zydsc/b0th4x/refs/heads/main/call-Api.lua", "GET").content))

joinWorldWithDoorId("WORLDNAME123", "KEYDOORID123")

local x, y = getBotTile()
LogToConsole("Current Tile: " .. x .. ", " .. y)

paths(45, 20)

getFloat(112)
LogToConsole("Current Inventory: " .. inventory(112))
```

---

## 📝 Notes

- Designed for the Bothax API.
- All coordinates are tile coordinates, not pixel coordinates.
- These helpers are wrappers around the Bothax API, making scripts shorter, cleaner, and easier to maintain.
- `paths()` is recommended over directly calling `FindPath()` whenever reliable navigation is required, thanks to its BFS-based route calculation.
- Simply load the helper once, then use the functions anywhere in your script.
