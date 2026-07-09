function disconnect()
    return GetWorld() == nil or GetLocal() == nil
end

function stopped()
    return not isRunning
end

function getBotTile()
    local me = GetLocal()
    if not me then return end
    local x = math.floor(me.pos.x / 32)
    local y = math.floor(me.pos.y / 32)
    return x, y
end

function paths(targetX, targetY)
    local player = GetLocal()
    if not player then return end

    local startX = math.floor(player.pos.x / 32)
    local startY = math.floor(player.pos.y / 32)

    local world = GetWorld()
    if not world then return end
    local width, height = world.width, world.height

    local queue = {{x = startX, y = startY}}
    local visited = {}
    local cameFrom = {}
    visited[startX .. "," .. startY] = true

    local dirs = {
        {x=1, y=0}, {x=-1, y=0},
        {x=0, y=1}, {x=0, y=-1}
    }

    -- BFS
    while #queue > 0 do
    	if disconnect() or stopped() then
        	return
    	end
        local current = table.remove(queue, 1)
        if current.x == targetX and current.y == targetY then
            break
        end

        for _, d in ipairs(dirs) do
            local nx, ny = current.x + d.x, current.y + d.y
            if nx >= 0 and nx < width and ny >= 0 and ny < height then
                local key = nx .. "," .. ny
                if not visited[key] and CheckPath(nx, ny) then
                    visited[key] = true
                    cameFrom[key] = current
                    table.insert(queue, {x = nx, y = ny})
                end
            end
        end
    end

    -- Rekonstruksi path
    local path = {}
    local current = {x = targetX, y = targetY}
    while current and not (current.x == startX and current.y == startY) do
        table.insert(path, 1, current)
        current = cameFrom[current.x .. "," .. current.y]
    end

    if #path == 0 then
        LogToConsole("Path tidak ditemukan.")
        return
    end

    -- Jalanin path
    for _, pos in ipairs(path) do
    	if disconnect() or stopped() then
        	return
    	end
        FindPath(pos.x, pos.y)
        Sleep(100)
    end
end

function Sleeps(min, max)
    return Sleep(math.random(min, max))
end

function scanObject(id)
    local object = GetObjectList()
    if not object then
        return 0
    end
    local count = 0
    for _, object in pairs(object) do
        if object.id == id then
            count = count + object.amount
        end
    end
    return count
end

function inventory(b)
    local invs = GetInventory()
    if not invs then
		return 0
	end
    for _, a in pairs(invs) do
        if a.id == b then return a.amount end
    end
    return 0
end

function collect(id)
    local object = GetObjectList()
    local player = GetLocal()
    if not object or not player then
        return
    end
    for _, obj in pairs(object) do
        if obj.id == id and
           math.abs(player.pos.x - obj.pos.x) < 64 and
           math.abs(player.pos.y - obj.pos.y) < 64 then
            SendPacketRaw(false, {
                x = obj.pos.x,
                y = obj.pos.y,
                value = obj.oid,
                type = 11
            })
            Sleep(50)
        end
    end
end

function getFloat(id)
    local objectList = GetObjectList()
    if not objectList then return end
    for _, object in pairs(objectList) do
        if disconnect() or stopped() then
            return
        end
        if object.id == id then
            paths(
                math.floor(object.pos.x / 32),
                math.floor(object.pos.y / 32)
            )
            collect(id)
            Sleeps(300, 500)
            if inventory(id) >= 200 or scanObject(id) == 0 then
                break
            end
        end
    end
end

function isInsideDoor()
    local me = GetLocal()
    if not me then
        return false
    end
    local x = math.floor(me.pos.x / 32)
    local y = math.floor(me.pos.y / 32)
    local tile = GetTile(x, y)
    return tile and tile.fg ~= 6
end

function inWhiteDoor()
    local me = GetLocal()
    if not me then
        return true
    end
    local x = math.floor(me.pos.x / 32)
    local y = math.floor(me.pos.y / 32)
    local tile = GetTile(x, y)
    return not tile or tile.fg == 6
end

function joinWorldWithDoorId(world, id)
    while true do

        local currentWorld = GetWorld()

        if currentWorld and
           currentWorld.name and
           currentWorld.name:upper() == world:upper() and
           not inWhiteDoor()
        then
            return true
        end

        SendPacket(
            3,
            "action|join_request\nname|" ..
            world .. "|" .. id
        )

        Sleeps(4500, 5000)
    end
end
