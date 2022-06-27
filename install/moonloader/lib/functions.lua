--test
module = {}

local tCarsName = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter",
"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo",
"RCBandit", "Romero","Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
"Yankee", "Caddy", "Solair", "Berkley'sRCVan", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
"Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick",
"Boxvillde", "Benson", "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey", "Bike",
"MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000",
"CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
"Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
"FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "NewsVan",
"Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox", "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar",
"PoliceCar", "PoliceRanger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage A", "Luggage B", "Stairs", "Boxville", "Tiller",
"UtilityTrailer"}

local function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
end

function module.getMyNick()
	result, id = sampGetPlayerIdByCharHandle(playerPed)
	if result then
		nick = sampGetPlayerNickname(id)
	end
	return nick
end

function module.getMyId()
	_, id = sampGetPlayerIdByCharHandle(playerPed)
	return id
end

function module.getIdByHandle(ped)
	if ped ~= '' then
		_, id = sampGetPlayerIdByCharHandle(ped)
		return id
	end
end

function module.getHandleById(id)
	if id ~= '' then
		_, ped = sampGetCharHandleBySampPlayerId(id)
		return ped
	end
end

function module.getNickById(id)
	if id ~= '' then
		nick = sampGetPlayerNickname(id)
	end
	return nick
end

function module.getId(handle)
	if handle ~= '' then
		_, id = sampGetPlayerIdByCharHandle(handle)
		return id
	end
end

function module.getIdNick(nick)
	if nick ~= '' then
		nickname = sampGetPlayerIdByNickname(nick)
	end
	return nickname
end

function module.getInfoRandom3dText()
	for i = 1, 2048 do
		local text, color, x, y, z, distance, ignoreWalls, pID, vID = sampGet3dTextInfoById(i)
		return text, color, x, y, z, distance, ignoreWalls, pID, vID
	end
end

function module.getInfo3dTextId(id)
	if id ~= '' then
		local text, color, x, y, z, distance, ignoreWalls, pID, vID = sampGet3dTextInfoById(id)
		return text, color, x, y, z, distance, ignoreWalls, pID, vID
	end
end

function module.getDialogId()
	if sampIsDialogActive() then
		id = sampGetCurrentDialogId()
	end
	return id
end

function module.getDialogType()
	if sampIsDialogActive() then
		type = sampGetCurrentDialogType()
	end
	return type
end

function module.deleteAllPickups()
	for k,v in ipairs(getAllPickups()) do
		removePickup(v)
	end
end

function module.deleteAllChars()
	for k,v in ipairs(getAllChars()) do
		deleteChar(v)
	end
end

function module.shAllChars(bool)
	if bool then
		for k,v in ipairs(getAllChars()) do
			setCharVisible(v, true)
		end
	else
		for k,v in ipairs(getAllChars()) do
			setCharVisible(v, false)
		end
	end
end

function module.deleteAllCars()
	for k,v in ipairs(getAllVehicles()) do
		deleteCar(v)
	end
end

function module.shAllCars(bool)
	if bool then
		for k,v in ipairs(getAllVehicles()) do
			setCarVisible(v, true)
		end
	else
		for k,v in ipairs(getAllVehicles()) do
			setCarVisible(v, false)
		end
	end
end

function module.deleteAllObjects()
	for k,v in ipairs(getAllObjects()) do
		deleteObject(v)
	end
end

function module.shAllObjects(bool)
	if bool then
		for k,v in ipairs(getAllObjects()) do
			setObjectVisible(v, true)
		end
	else
		for k,v in ipairs(getAllObjects()) do
			setObjectVisible(v, false)
		end
	end
end

function module.fPlayerNick(radius)
	pos = {getCharCoordinates(playerPed)}
	result, ped = findAllRandomCharsInSphere(pos[1], pos[2], pos[3], radius, true, true)
	if result then
		result, id = sampGetPlayerIdByCharHandle(ped)
		if result then
			nick = sampGetPlayerNickname(id)
		end
	end
	return nick
end

function module.fPlayerId(radius)
	pos = {getCharCoordinates(playerPed)}
	result, ped = findAllRandomCharsInSphere(pos[1], pos[2], pos[3], radius, true, true)
	if result then
		_, id = sampGetPlayerIdByCharHandle(ped)
		return id
	end
end

function module.fPlayerHandle(radius)
	pos = {getCharCoordinates(playerPed)}
	_, ped = findAllRandomCharsInSphere(pos[1], pos[2], pos[3], radius, true, true)
	return ped
end

function module.GetAngleBeetweenTwoPoints(x1, y1, x2, y2)
	local plus = 0.0
    local mode = 1
    if x1 < x2 and y1 > y2 then plus = math.pi/2; mode = 2; end
    if x1 < x2 and y1 < y2 then plus = math.pi; end
    if x1 > x2 and y1 < y2 then plus = math.pi*1.5; mode = 2; end
    local lx = x2 - x1
    local ly = y2 - y1
    lx = math.abs(lx)
    ly = math.abs(ly)
    if mode == 1 then ly = ly/lx;
    else ly = lx/ly; end
    ly = math.atan(ly)
    ly = ly + plus
    return ly
end

function module.getSquare()
    local KV = {
        [1] = "А",
        [2] = "Б",
        [3] = "В",
        [4] = "Г",
        [5] = "Д",
        [6] = "Ж",
        [7] = "З",
        [8] = "И",
        [9] = "К",
        [10] = "Л",
        [11] = "М",
        [12] = "Н",
        [13] = "О",
        [14] = "П",
        [15] = "Р",
        [16] = "С",
        [17] = "Т",
        [18] = "У",
        [19] = "Ф",
        [20] = "Х",
        [21] = "Ц",
        [22] = "Ч",
        [23] = "Ш",
        [24] = "Я",
    }
    local X, Y, Z = getCharCoordinates(playerPed)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = KV[Y]
    local KVX = (Y.."-"..X)
    return KVX
end

function module.getPlayerSeatId(playerid)
	local result, ped = sampGetCharHandleBySampPlayerId(playerid)
	if result and isCharInAnyCar(ped) then
		local car = storeCarCharIsInNoSave(ped)
		for i = 0, getMaximumNumberOfPassengers(car) do
			if not isCarPassengerSeatFree(car, i) and getCharInCarPassengerSeat(car, i) == ped then
				return i
			end
		end
	end
	return nil
end

function module.getDownKeys()
    local keyslist = ""
    local bool =false
    for k, v in pairs(vkeys) do
        if isKeyDown(v) and (v == VK_MENU or v == VK_CONTROL or v == VK_SHIFT or v == VK_LMENU or v == VK_RMENU or v == VK_RCONTROL or v == VK_LCONTROL or v == VK_LSHIFT or v == VK_RSHIFT) then
            if v ~= VK_MENU and v ~= VK_CONTROL and v ~= VK_SHIFT then
                keyslist = v
            end
        end
        if isKeyDown(v) and v ~= VK_MENU and v ~= VK_CONTROL and v ~= VK_SHIFT and v ~= VK_LMENU and v ~= VK_RMENU and v ~= VK_RCONTROL and v~= VK_LCONTROL and v ~= VK_LSHIFT and v ~= VK_RSHIFT then
            if tostring(keyslist):len() == 0 then
                    keyslist = v
                else
                    keyslist = keyslist .. " " .. v
            end
            bool = true
        end
    end
    return keyslist, bool
end

function module.isKeysDown(keylist)
    local tKeys = string.split(keylist, " ")
    local bool = false
    local isDownIndex = 0
    local key = #tKeys < 2 and tonumber(tKeys[1]) or tonumber(tKeys[2])
    local modified = tonumber(tKeys[1])
    if #tKeys < 2 then
        if not isKeyDown(VK_RMENU) and not isKeyDown(VK_LMENU) and not isKeyDown(VK_LSHIFT) and not isKeyDown(VK_RSHIFT) and not isKeyDown(VK_LCONTROL) and not isKeyDown(VK_RCONTROL) then
            if wasKeyPressed(key) then
                bool = true
            end
        end
    else
        if isKeyDown(modified) and not wasKeyReleased(modified) then
            if wasKeyPressed(key) then
                bool = true
            end
        end
    end
    if nextLockKey == keylist then
        bool = false
        nextLockKey = ""
    end
    return bool
end

function module.clearChat()
    local memory = require "memory"
    memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200)
    memory.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0)
    memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1)
end

function module.getCarName()
	if isCharInAnyCar(playerPed) then
		local veh = storeCarCharIsInNoSave(playerPed)
		local carModel = getCarModel(veh)
		carName = tCarsName[carModel - 399]
		return carName
	end
end

function module.getCarNameByPlayerId(id)
	if id ~= '' then
		local result, ped = sampGetCharHandleBySampPlayerId(id)
		if result then
			local veh = storeCarCharIsInNoSave(ped)
			local carModel = getCarModel(veh)
			local carName = tCarsName[carModel - 399]
			return carName
		end
	end
end

function module.getCarId()
	if isCharInAnyCar(playerPed) then
		local veh = storeCarCharIsInNoSave(playerPed)
		_, car = sampGetVehicleIdByCarHandle(veh)
		return car
	end
end

function module.getCarIdByPlayerId(id)
	if id ~= '' then
		result, ped = sampGetCharHandleBySampPlayerId(id)
		if result then
			if isCharInAnyCar(ped) then
				local veh = storeCarCharIsInNoSave(ped)
				_, car = sampGetVehicleIdByCarHandle(veh)
				return car
			end
		end
	end
end

function module.getCarHandle()
	if isCharInAnyCar(playerPed) then
		local veh =	storeCarCharIsInNoSave(playerPed)
		return veh
	end
end

function module.getCarHandleByPlayerId(id)
	if id ~= '' then
		result, ped = sampGetCharHandleBySampPlayerId(id)
		if result then
			local veh = storeCarCharIsInNoSave(ped)
			return veh
		end
	end
end

-- new functions

function module.getHealth() -- получаем свое хп
	hp = getCharHealth(playerPed)
	return hp
end

function module.getPlayerHealth(id) -- получаем чужое хп
	if id ~= '' then
		result, ped = sampGetCharHandleBySampPlayerId(id)
		if result then
			hp = getCharHealth(ped)
			return hp
		end
	end
end

function module.gCarHealh() -- получаем хп авто
	if isCharInAnyCar(playerPed) then
		veh = storeCarCharIsInNoSave(playerPed)
		hp = getCarHealth(veh)
	end
	return hp
end

function module.gCarHealthByPlayerId(id) -- получаем хп авто в котором сидит игрок ( по ид )
	if id ~= '' then
		result, ped = sampGetCharHandleBySampPlayerId(id)
		if result then
			if isCharInAnyCar(ped) then
				veh = storeCarCharIsInNoSave(ped)
				hp = getCarHealth(veh)
			end
		end
	end
	return hp
end

function module.gCharCoords() -- получаем свои координаты
	pos = {getCharCoordinates(playerPed)}
	return pos[1], pos[2], pos[3]
end

function module.gPlayerCoords(id) -- получаем координаты игрока ( по ид )
	if id ~= '' then
		result, ped = sampGetCharHandleBySampPlayerId(id)
		if result then
			pos = {getCharCoordinates(ped)}
		end
	end
	return pos[1], pos[2], pos[3]
end

function module.setCarEngine(bool) -- вкл/выкл двигатель
	if isCharInAnyCar(playerPed) then
		veh = storeCarCharIsInNoSave(playerPed)
		if bool then
			switchCarEngine(veh, true)
		else
			switchCarEngine(veh, false)
		end
	end
end

function module.setCarSiren(bool) -- вкл/выкл сирены
	if isCharInAnyCar(playerPed) then
		veh = storeCarCharIsInNoSave(playerPed)
		if bool then
			switchCarSiren(veh, true)
		else
			switchCarSiren(veh, false)
		end
	end
end

function module.gCarCoords(x, y, z) -- телепорт машины на координаты
	if isCharInAnyCar(playerPed) then
		veh = storeCarCharIsInNoSave(playerPed)
		carGotoCoordinates(veh, x, y, z)
	end
end

function module.searchMarker(posX, posY, posZ, radius, isRace) -- поиск маркера
    local ret_posX = 0.0
    local ret_posY = 0.0
    local ret_posZ = 0.0
    local isFind = false

    for id = 0, 31 do
        local MarkerStruct = 0
        if isRace then MarkerStruct = 0xC7F168 + id * 56
        else MarkerStruct = 0xC7DD88 + id * 160 end
        local MarkerPosX = representIntAsFloat(readMemory(MarkerStruct + 0, 4, false))
        local MarkerPosY = representIntAsFloat(readMemory(MarkerStruct + 4, 4, false))
        local MarkerPosZ = representIntAsFloat(readMemory(MarkerStruct + 8, 4, false))

        if MarkerPosX ~= 0.0 or MarkerPosY ~= 0.0 or MarkerPosZ ~= 0.0 then
            if getDistanceBetweenCoords3d(MarkerPosX, MarkerPosY, MarkerPosZ, posX, posY, posZ) < radius then
                ret_posX = MarkerPosX
                ret_posY = MarkerPosY
                ret_posZ = MarkerPosZ
                isFind = true
                radius = getDistanceBetweenCoords3d(MarkerPosX, MarkerPosY, MarkerPosZ, posX, posY, posZ)
            end
        end
    end

    return isFind, ret_posX, ret_posY, ret_posZ
end

function module.search3Dtext(x, y, z, radius, patern) -- поиск 3д текста
    local text = ""
    local color = 0
    local posX = 0.0
    local posY = 0.0
    local posZ = 0.0
    local distance = 0.0
    local ignoreWalls = false
    local player = -1
    local vehicle = -1
    local result = false

    for id = 0, 2048 do
        if sampIs3dTextDefined(id) then
            local text2, color2, posX2, posY2, posZ2, distance2, ignoreWalls2, player2, vehicle2 = sampGet3dTextInfoById(id)
            if getDistanceBetweenCoords3d(x, y, z, posX2, posY2, posZ2) < radius then
                if string.len(patern) ~= 0 then
                    if string.match(text2, patern, 0) ~= nil then result = true end
                else
                    result = true
                end
                if result then
                    text = text2
                    color = color2
                    posX = posX2
                    posY = posY2
                    posZ = posZ2
                    distance = distance2
                    ignoreWalls = ignoreWalls2
                    player = player2
                    vehicle = vehicle2
                    radius = getDistanceBetweenCoords3d(x, y, z, posX, posY, posZ)
                end
            end
        end
    end

    return result, text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle
end

function module.setMaxCarSpeed(speed) -- установка максимальной скорости
	if isCharInAnyCar(playerPed) then
		veh = storeCarCharIsInNoSave(playerPed)
		setCarCruiseSpeed(veh, speed)
	end
end

function module.setCarDriveStyle(number) -- установка стиля вождения
	if isCharInAnyCar(playerPed) then
		veh = storeCarCharIsInNoSave(playerPed)
		setCarDrivingStyle(veh, number)
	end
end

return module