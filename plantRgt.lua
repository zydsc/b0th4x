local cfg = _G.PlantConfig

worldPlants = cfg.worldPlants

worldStorage = cfg.worldStorage
doorIdWorldStorage = cfg.doorStorage

seedID = cfg.seedId
rangePlant = cfg.rangePlant

worldXs = cfg.worldXStart
worldXe = cfg.worldXEnd

worldYs = cfg.worldYStart
worldYe = cfg.worldYEnd

delayPaths = cfg.delayPaths
delayPlant = cfg.delayPlant

currentPlantIndex = 1

function getCurrentPlant()
    return worldPlants[currentPlantIndex]
end

function nextPlantWorld()
    currentPlantIndex = currentPlantIndex + 1
    if currentPlantIndex > #worldPlants then
        currentPlantIndex = 1
    end
end

-- function call sample api
pcall(load(MakeRequest("https://raw.githubusercontent.com/zydsc/sample-api/refs/heads/main/bthx.lua", "GET").content)) 

function serverRaw(s, v, x, y)
    local me = GetLocal()
    if not me then return end
    local packet = {
        state = s,
        netid = me.netid,
        value = v,
        px = x,
        py = y,
        x = me.pos.x,
        y = me.pos.y
    }
    packet.type = 0
    SendPacketRaw(false, packet)
    Sleep(100)
    packet.type = 3
    SendPacketRaw(false, packet)
end

function worldFinished()
    if disconnect() then
        return false
    end
    for y = worldYs, worldYe, 2 do
        for x = worldXs, worldXe do
            if disconnect() then
                return false
            end
            local tile = GetTile(x, y)
            if not tile then
                return false
            end
            if tile.fg == 0 then
                return false
            end
        end
    end
    return true
end

function plantingPhase()
	if disconnect() then return end
    local direction = 1
    local range = rangePlant

    for y = worldYs, worldYe, 2 do
    	if disconnect() then return end
        local startX = (direction == 1) and worldXs or worldXe
        local endX   = (direction == 1) and worldXe or worldXs
        local stepX  = (direction == 1) and 1 or -1

        local v = seedID
        local s = (direction == 1) and 3104 or 3120
        -- state 3104 kanan state 3120 kiri

        for x = startX, endX, stepX do
        	if disconnect() then return end
            local tile1 = GetTile(x, y)
            local tile2 = GetTile(x, y + 1)
            if not disconnect() and inventory(v) >= 1 and tile1 and tile1.fg == 0 and tile1.fg ~= v and tile2 and tile2.fg ~= 0 then
                paths(x, y)
                Sleeps(delayPaths, delayPaths + 20)

                for i = 0, range do
                	if disconnect() then return end
                    local px = (direction == 1) and (x + i) or (x - i)
                    local t = GetTile(px, y)
                    if not disconnect() and inventory(v) >= 1 and t and t.fg == 0 and t.fg ~= v then
                        serverRaw(s, v, px, y)
                        Sleeps(delayPlant, delayPlant + 30)
                        if inventory(v) <= 0 then
                        	break
                        end
                    end
                end
            end
        end

        direction = -direction
    end
end

function mainPlantingPhase()
    local plant = getCurrentPlant()
    if inventory(seedID) >= 1 then
        local world = GetWorld()
        if not world or world.name ~= plant.world or not isInsideDoor() then
            joinWorldWithDoorId(plant.world, plant.door)
        end
        plantingPhase()
        if not disconnect() and worldFinished() then
            nextPlantWorld()
        end
    else
        if GetWorld().name ~= worldStorage
        or not isInsideDoor() then
            joinWorldWithDoorId(worldStorage, doorIdWorldStorage)
        end
        getFloat(seedID)
    end
end

while isRunning do
    if disconnect() then
        Sleep(3000)
        local plant = getCurrentPlant()
        joinWorldWithDoorId(plant.world, plant.door)
        while disconnect() do
            Sleep(1000)
        end
    else
        mainPlantingPhase()
    end
    Sleep(500)
end