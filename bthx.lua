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
        FindPath(pos.x, pos.y)
        Sleep(100)
    end
end

function inventory(b)
    local invs = GetInventory()
    if not invs then return end
    for _, a in pairs(invs) do
        if a.id == b then return a.amount end
    end
    return 0
end

function collect()
	local object = GetObjectList()
    if not object then return end
    for _, obj in pairs(object) do
        if math.abs(GetLocal().pos.x - obj.pos.x) < 64 and math.abs(GetLocal().pos.y - obj.pos.y) < 64 then
            SendPacketRaw(false, {x = obj.pos.x, y = obj.pos.y, value = obj.oid, type = 11})
            Sleep(50)
        end
    end
end 
