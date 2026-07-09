Bothax Helper Functions

A lightweight helper library built on top of the Bothax API.

This library provides utility functions that simplify common scripting tasks such as movement, inventory management, floating object collection, and world navigation.

---

Installation

Load the helper library before using any function.

pcall(load(MakeRequest("https://raw.githubusercontent.com/zydsc/b0th4x/refs/heads/main/call-Api.lua", "GET").content))

After loading the library, all helper functions become available globally.

---

Table of Contents

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

disconnect()

Checks whether the bot has been disconnected.

Returns

Type| Description
boolean| "true" if disconnected, otherwise "false".

Example

if disconnect() then
    return
end

---

getBotTile()

Returns the bot's current tile position.

Returns

Type| Description
number| X coordinate
number| Y coordinate

Example

local x, y = getBotTile()

LogToConsole(x .. ", " .. y)

---

paths(targetX, targetY)

Moves the bot to the specified destination using a smart pathfinding algorithm.

Unlike the standard "FindPath()", which simply attempts to move directly to a destination, "paths()" first searches for an entire valid route before moving.

Internally, this helper uses the Breadth-First Search (BFS) algorithm to explore walkable tiles and determine the shortest available path from the bot's current position to the target tile.

Once a valid route has been found, the helper automatically walks through every tile in sequence until the destination is reached.

Why use "paths()"?

- Calculates the complete route before moving.
- Uses Breadth-First Search (BFS) to find the shortest valid path.
- Automatically avoids blocked or non-walkable tiles.
- More reliable than repeatedly calling "FindPath()".
- Similar to custom pathfinding systems used by advanced scripts (such as Lucifer Path), while remaining simple to use.

Parameters

Name| Type| Description
targetX| number| Destination X tile
targetY| number| Destination Y tile

Example

paths(50, 25)

Instead of writing multiple movement checks, simply call:

paths(80, 40)

The helper will automatically:

1. Determine the bot's current position.
2. Search for the shortest reachable path using BFS.
3. Reconstruct the route.
4. Walk through every tile until the destination is reached.

---

Sleeps(min, max)

Sleeps for a random duration between two values.

Useful for randomized delays.

Parameters

Name| Type
min| Minimum milliseconds
max| Maximum milliseconds

Example

Sleeps(300, 600)

---

scanObject(id)

Counts every floating object with the specified item ID.

Parameters

Name| Type
id| Item ID

Returns

Returns the total amount of matching floating objects.

Example

local gems = scanObject(112)

LogToConsole(gems)

---

inventory(id)

Returns how many items of the specified ID exist in the inventory.

Parameters

Name| Type
id| Item ID

Returns

Returns the item amount.

Example

local amount = inventory(112)

if amount >= 200 then
    LogToConsole("Enough items.")
end

---

collect(id)

Collects nearby floating objects matching the specified item ID.

Parameters

Name| Type
id| Item ID

Example

collect(112)

---

getFloat(id)

Automatically searches for, walks to, and collects floating objects.

The helper combines smart pathfinding and automatic collection into a single function.

Collection stops automatically when:

- Inventory contains 200 of the item.
- No matching floating objects remain.

Parameters

Name| Type
id| Item ID

Example

getFloat(112)

---

isInsideDoor()

Checks whether the bot is currently inside a door.

Returns

Returns "true" if the bot is inside a door.

Example

if isInsideDoor() then
    LogToConsole("Inside door.")
end

---

inWhiteDoor()

Checks whether the bot is currently inside a white door.

Returns

Returns "true" if standing inside a white door.

Example

if inWhiteDoor() then
    LogToConsole("Waiting...")
end

---

joinWorldWithDoorId(world, id)

Automatically joins a world through the specified door ID.

The helper repeatedly sends join requests until the target world has been entered successfully.

Parameters

Name| Type
world| World name
id| Door ID

Returns

Returns "true" once the world has been joined.

Example

joinWorldWithDoorId("NAME_WORLD", "DOOR_ID")
---

Complete Example

pcall(load(MakeRequest("https://raw.githubusercontent.com/zydsc/b0th4x/refs/heads/main/call-Api.lua", "GET").content))

joinWorldWithDoorId("ABCDE", "ABCD123")

local x, y = getBotTile()

LogToConsole("Current Tile: " .. x .. ", " .. y)

paths(45, 20)

getFloat(112)

LogToConsole("Inventory: " .. inventory(112))

---

Notes

- Designed for the Bothax API.
- All coordinates use tile coordinates.
- These helpers simplify repetitive scripting tasks while keeping scripts clean and readable.
- "paths()" is recommended whenever you need reliable movement, as it performs intelligent route searching before the bot starts walking.
