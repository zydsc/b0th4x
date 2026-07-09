# Bothax Simple Functions

A lightweight collection of helper functions built on top of the Bothax API.

These functions are designed to simplify common scripting tasks such as navigation, inventory checking, object collection, and world joining.

---

# Table of Contents

- disconnect()
- getBotTile()
- paths()
- Sleeps()
- scanObject()
- inventory()
- collect()
- getFloat()
- isInsideDoor()
- inWhiteDoor()
- joinWorldWithDoorId()

---

# disconnect()

Checks whether the bot is disconnected from the game.

### Returns

| Type | Description |
|------|-------------|
| boolean | `true` if disconnected, otherwise `false`. |

### Example

```lua
if disconnect() then
    LogToConsole("Bot disconnected.")
    return
end
```

---

# getBotTile()

Returns the current tile position of the bot.

### Returns

| Type | Description |
|------|-------------|
| number | X tile position |
| number | Y tile position |

### Example

```lua
local x, y = getBotTile()

LogToConsole("Bot Position: " .. x .. ", " .. y)
```

---

# paths(targetX, targetY)

Moves the bot to the specified tile using pathfinding.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| targetX | number | Destination X tile |
| targetY | number | Destination Y tile |

### Example

```lua
paths(50, 25)
```

---

# Sleeps(min, max)

Sleeps for a random duration between the given values.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| min | number | Minimum milliseconds |
| max | number | Maximum milliseconds |

### Example

```lua
Sleeps(300, 600)
```

---

# scanObject(id)

Counts all floating objects with the specified item ID.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| id | number | Item ID |

### Returns

| Type | Description |
|------|-------------|
| number | Total amount of floating objects |

### Example

```lua
local gems = scanObject(112)

LogToConsole(gems)
```

---

# inventory(id)

Returns the amount of an item currently in inventory.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| id | number | Item ID |

### Returns

| Type | Description |
|------|-------------|
| number | Item amount |

### Example

```lua
local blocks = inventory(2)

LogToConsole(blocks)
```

---

# collect(id)

Collects nearby floating objects with the specified item ID.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| id | number | Item ID |

### Example

```lua
collect(112)
```

---

# getFloat(id)

Automatically searches, walks to, and collects floating objects with the specified item ID.

The function stops collecting when:

- Inventory reaches **200** of the item.
- No more floating objects are found.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| id | number | Item ID |

### Example

```lua
getFloat(112)
```

---

# isInsideDoor()

Checks whether the bot is currently inside a door.

### Returns

| Type | Description |
|------|-------------|
| boolean | Door status |

### Example

```lua
if isInsideDoor() then
    LogToConsole("Inside door.")
end
```

---

# inWhiteDoor()

Checks whether the bot is standing inside a white door.

### Returns

| Type | Description |
|------|-------------|
| boolean | `true` if inside a white door |

### Example

```lua
if inWhiteDoor() then
    LogToConsole("Waiting to enter world...")
end
```

---

# joinWorldWithDoorId(world, id)

Joins a world through the specified door ID.

The function keeps attempting until the bot successfully enters the world.

### Parameters

| Name | Type | Description |
|------|------|-------------|
| world | string | World name |
| id | string | Door ID |

### Returns

| Type | Description |
|------|-------------|
| boolean | Returns `true` after successfully entering the target world |

### Example

```lua
joinWorldWithDoorId("START", "DOOR")
```

---

# Example Script

```lua
joinWorldWithDoorId("START", "MAIN")

local x, y = getBotTile()

LogToConsole("Current Tile: " .. x .. ", " .. y)

paths(30, 15)

getFloat(112)

LogToConsole("Inventory: " .. inventory(112))
```

---

# Notes

- These helper functions are built for the Bothax API.
- All coordinates use **tile coordinates**, not pixel coordinates.
- Some functions rely on the standard Bothax API such as `FindPath()`, `GetWorld()`, `GetObjectList()`, `SendPacket()`, and `Sleep()`.
