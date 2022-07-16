local rpc = {outcoming = {}, incoming = {}}

-- OUTCOMING RPC
rpc.outcoming[26] = {
    {'vehicleId', 'int16', false},
    {'passenger', 'bool8', false},
}

rpc.outcoming[23] = {
    {'playerId', 'int16', false},
    {'source', 'int8', false}
}

rpc.outcoming[25] = {
    {'version', 'int32', false},
    {'mod', 'int8', false},
    {'nickname', 'string8', false},
    {'challengeResponse', 'int32', false},
    {'joinAuthKey', 'int8', false},
    {'clientVer', 'string8', false},
    {'unk', 'int32', false},
}

rpc.outcoming[27] = {
    {'type', 'int32', false},
    {'objectId', 'int16', false},
    {'model', 'int32', false},
    {'position', 'vector3d', false}
}

rpc.outcoming[50] = {
    {'command', 'string32', false}
}

rpc.outcoming[52] = {} -- пустая таблица, в логах просто отобразиться уведомление об RPC
rpc.outcoming[53] = {
    {'reason', 'int8', false},
    {'killerId', 'int16', false},
}

rpc.outcoming[62] = {
    {'dialogId', 'int16', false},
    {'button', 'int8', false},
    {'listBoxId', 'int16', false},
    {'input', 'string8', false},
}

rpc.outcoming[83] = {
    {'textDrawId', 'int16', false}
}

rpc.outcoming[96] = {
    {'vehicleId', 'int32', false},
    {'param1', 'int32', false},
    {'param2', 'int32', false},
    {'event', 'int32', false}
}

rpc.outcoming[101] = {
    {'message', 'string8', false}
}

rpc.outcoming[103] = {
    {'flags', 'int8', false},
    {'unk1', 'int32', false},
    {'unk2', 'int8', false},
}

rpc.outcoming[106] = {
    {'vehicleId', 'int16', false},
    {'panelDmg', 'int32', false},
    {'doorDmg', 'int32', false},
    {'lights', 'int8', false},
    {'tires', 'int8', false}
}

rpc.outcoming[116] = {
    {'response', 'int32', false},
    {'index', 'int32', false},
    {'model', 'int32', false},
    {'bone', 'int32', false},
    {'position', 'vector3d', false},
    {'rotation', 'vector3d', false},
    {'scale', 'vector3d', false},
    {'color1', 'int32', false},
    {'color2', 'int32', false}
}

rpc.outcoming[117] = {
    {'playerObject', 'bool', false},
    {'objectId', 'int16', false},
    {'response', 'int32', false},
    {'position', 'vector3d', false},
    {'rotation', 'vector3d', false},
}

rpc.outcoming[118] = {
    {'interior', 'int8', false}
}

rpc.outcoming[119] = {
    {'position', 'vector3d', false}
}

rpc.outcoming[128] = {
    {'classId', 'int32', false},
}

rpc.outcoming[129] = {}

rpc.outcoming[131] = {
    {'pickupId', 'int32', false}
}

rpc.outcoming[132] = {
    {'row', 'int8', false}
}

rpc.outcoming[136] = {
    {'vehicleId', 'int16', false}
}

rpc.outcoming[140] = {}

rpc.outcoming[154] = {
    {'vehicleId', 'int16', false}
}

rpc.outcoming[155] = {}

rpc.outcoming[115] = {
    {'take', 'bool', false},
    {'playerId', 'int16', false},
    {'damage', 'float', false},
    {'weapon', 'int32', false},
    {'bodyPart', 'int32', false},
}

-- INCOMING RPC
rpc.incoming[139] = { -- onInitGame
    {'zoneNames', 'bool', false},
    {'useCJWalk', 'bool', false},
    {'allowWeapons', 'bool', false},
    {'limitGlobalChatRadius', 'bool', false},
    {'globalChatRadius', 'float', false},
    {'nametagDrawDist', 'float', false},
    {'disableEnterExits', 'bool', false},
    {'nametagLOS', 'bool', false},
    {'tirePopping', 'bool', false},
    {'classesAvailable', 'int32', false},
    {'playerId', 'int16', false},
    {'showPlayerTags', 'bool', false},
    {'playerMarkersMode', 'int32', false},
    {'worldTime', 'int8', false},
    {'worldWeather', 'int8', false},
    {'gravity', 'float', false},
    {'lanMode', 'bool', false},
    {'deathMoneyDrop', 'int32', false},
    {'instagib', 'bool', false},
    {'normalOnfootSendrate', 'int32', false},
    {'normalIncarSendrate', 'int32', false},
    {'normalFiringSendrate', 'int32', false},
    {'sendMultiplier', 'int32', false},
    {'lagCompMode', 'int32', false},
    {'hostname', 'string8', false},
    {'vehicleModels', 'GameVehicleModels', false},
    {'unknown', 'int32', false}
}

rpc.incoming[137] = {
    {'playerId', 'int16', false},
    {'color', 'int32', false},
    {'isNPC', 'bool8', false},
    {'nickname', 'string8', false},
}

rpc.incoming[138] = {
    {'playerId', 'int16', false},
    {'reason', 'int8', false}
}

rpc.incoming[128] = {
    {'canSpawn', 'bool8', false},
    {'team', 'int8', false},
    {'skin', 'int32', false},
    {'unk', 'int8', false},
    {'position', 'vector3d', false},
    {'rotation', 'float', false},
    {'weapons', 'Int32Array3', false},
    {'ammo', 'Int32Array3', false},
}

rpc.incoming[129] = {
    {'response', 'bool8', false}
}

rpc.incoming[11] = {
    {'playerId', 'int16', false},
    {'nickname', 'string8', false},
    {'success', 'bool8', false},
}

rpc.incoming[12] = {
    {'position', 'vector3d', false},
}

rpc.incoming[13] = {
    {'position', 'vector3d', false}
}

rpc.incoming[14] = {
    {'health', 'float', false}
}

rpc.incoming[15] = {
    {'controllable', 'bool8', false}
}

rpc.incoming[16] = {
    {'soundId', 'int32', false},
    {'position', 'vector3d', false}
}

rpc.incoming[17] = {
    {'maxX', 'float', false},
    {'minX', 'float', false},
    {'maxY', 'float', false},
    {'minY', 'float', false},
}

rpc.incoming[18] = {
    {'money', 'int32', false}
}

rpc.incoming[19] = {
    {'angle', 'float', false}
}

rpc.incoming[20] = {}
rpc.incoming[21] = {}

rpc.incoming[22] = {
    {'weaponId', 'int32', false},
    {'ammo', 'int32', false}
}

rpc.incoming[28] = {}
rpc.incoming[29] = {
    {'hour', 'int8', false},
    {'minute', 'int8', false}
}

rpc.incoming[30] = {
    {'state', 'bool8', false}
}

rpc.incoming[32] = {
    {'playerId', 'int16', false},
    {'team', 'int8', false},
    {'model', 'int32', false},
    {'positon', 'vector3d', false},
    {'rotation', 'float', false},
    {'color', 'int32', false},
    {'fightingStyle', 'int8', false},
}

rpc.incoming[33] = {
    {'name', 'string256', false}
}

rpc.incoming[34] = {
    {'playerId', 'int16', false},
    {'skill', 'int32', false},
    {'level', 'int16', false},
}

rpc.incoming[35] = {
    {'drunkLevel', 'int32', false}
}

rpc.incoming[36] = {
    {'id', 'int16', false},
    {'color', 'int32', false},
    {'position', 'vector3d', false},
    {'distance', 'float', false},
    {'testLOS', 'bool8', false},
    {'attachedPlayerId', 'int16', false},
    {'attachedVehicleId', 'int16', false},
    {'text', 'encodedString4096', false}
}

rpc.incoming[37] = {}

rpc.incoming[38] = {
    {'type', 'int8', false},
    {'position', 'vector3d', false},
    {'nextPosition', 'vector3d', false},
    {'size', 'float', false}
}

rpc.incoming[39] = {}
rpc.incoming[40] = {}

rpc.incoming[41] = {
    {'url', 'string8', false},
    {'position', 'vector3d', false},
    {'radius', 'float', false},
    {'usePosition', 'bool8', false},
}

rpc.incoming[42] = {}

rpc.incoming[43] = {
    {'modelId', 'int32', false},
    {'position', 'vector3d', false},
    {'radius', 'float', false}
}

rpc.incoming[44] = { -- onCreateObject
    {'objectId', 'int16', false},
    {'model', 'int32', false},
    {'position', 'vector3d', false},
    {'rotation', 'vector3d', false},
    {'drawDistance', 'float', false},
    {'noCameraCol', 'bool8', false},
    {'attachData', 'objectAttachData', false},
    {'texturesCount', 'int8', false},
    {'materialData', 'objectMaterialData', false},
}

rpc.incoming[45] = {
    {'objectId', 'int16', false},
    {'position', 'vector3d', false},
}

rpc.incoming[46] = {
    {'objectId', 'int16', false},
    {'rotation', 'vector3d', false},
}

rpc.incoming[47] = {
    {'objectId', 'int16', false}
}

rpc.incoming[55] = {
    {'killerId', 'int16', false},
    {'victimId', 'int16', false},
    {'weapon', 'int8', false}
}

rpc.incoming[56] = {
    {'iconId', 'int8', false},
    {'position', 'vector3d', false},
    {'type', 'int8', false},
    {'color', 'int32', false},
    {'style', 'int8', false}
}

rpc.incoming[57] = {
    {'vehicleId', 'int16', false},
    {'componentId', 'int16', false},
}

rpc.incoming[58] = {
    {'textLabelId', 'int16', false}
}

rpc.incoming[59] = {
    {'playerId', 'int16', false},
    {'color', 'int32', false},
    {'distance', 'float', false},
    {'duration', 'int32', false},
    {'message', 'string8', false}
}

rpc.incoming[60] = {
    {'time', 'int32', false}
}

rpc.incoming[61] = {
    {'dialogId', 'int16', false},
    {'style', 'int8', false},
    {'title', 'string8', false},
    {'button1', 'string8', false},
    {'button2', 'string8', false},
    {'text', 'encodedString4096', false}
}

rpc.incoming[63] = {
    {'id', 'int32', false}
}

rpc.incoming[65] = {
    {'vehicleId', 'int16', false},
    {'interiorId', 'int8', false},
}

rpc.incoming[66] = {
    {'armour', 'float', false}
}

rpc.incoming[67] = {
    {'weaponId', 'int32', false}
}

rpc.incoming[68] = {
    {'team', 'int8', false},
    {'skin', 'int32', false},
    {'unk', 'int8', false},
    {'position', 'vector3d', false},
    {'rotation', 'float', false},
    {'weapons', 'Int32Array3', false},
    {'ammo', 'Int32Array3', false}
}

rpc.incoming[69] = {
    {'playerId', 'int16', false},
    {'teamId', 'int8', false}
}

rpc.incoming[70] = {
    {'vehicleId', 'int16', false},
    {'seatId', 'int8', false}
}

rpc.incoming[71] = {}

rpc.incoming[72] = {
    {'playerId', 'int16', false},
    {'color', 'int32', false}
}

rpc.incoming[73] = {
    {'style', 'int32', false},
    {'time', 'int32', false},
    {'text', 'string32', false}
}

rpc.incoming[74] = {}

rpc.incoming[75] = {
    {'objectId', 'int16', false},
    {'playerId', 'int16', false},
    {'offsets', 'vector3d', false},
    {'rotation', 'vector3d', false},
}

rpc.incoming[76] = { -- onInitMenu
    {'menuId', 'int8', false},
    {'twoColumns', 'bool32', false},
    {'menuTitle', 'string256', false},
    {'X/Y', 'vector2d', false},
    {'colWidth', 'vector2d', false},
    {'menu', 'int32', false},
    -- rows и columns убраны из-за того что их сложно реализовать (P.S Весь onInitMenu нужно реализовывать в одном пункте...)
}

rpc.incoming[77] = {
    {'menuId', 'int8', false}
}

rpc.incoming[78] = {
    {'menuId', 'int8', false}
}

rpc.incoming[79] = {
    {'position', 'vector3d', false},
    {'style', 'int32', false},
    {'radius', 'float', false}
}

rpc.incoming[80] = {
    {'playerId', 'int16', false},
    {'show', 'bool8', false},
}

rpc.incoming[81] = {
    {'objectId', 'int16', false}
}

rpc.incoming[82] = {
    {'setPos', 'bool', false},
    {'fromPos', 'vector3d', false},
    {'destPos', 'vector3d', false},
    {'time', 'int32', false},
    {'mode', 'int8', false},
}

rpc.incoming[85] = {
    {'zone', 'int16', false}
}

rpc.incoming[86] = {
    {'playerId', 'int16', false},
    {'animLib', 'string8', false},
    {'animName', 'string8', false},
    {'loop', 'bool', false},
    {'lockX', 'bool', false},
    {'lockY', 'bool', false},
    {'freeze', 'bool', false},
    {'time', 'int32', false},
}

rpc.incoming[87] = {
    {'playerId', 'int16', false},
}

rpc.incoming[88] = {
    {'actionId', 'int8', false},
}

rpc.incoming[89] = {
    {'playerId', 'int16', false},
    {'styleId', 'int8', false},
}

rpc.incoming[90] = {
    {'velocity', 'vector3d', false}
}

rpc.incoming[91] = {
    {'turn', 'bool8', false},
    {'velocity', 'vector3d', false},
}

rpc.incoming[93] = {
    {'color', 'int32', false},
    {'message', 'string32', false}
}

rpc.incoming[94] = {
    {'hour', 'int8', false},
}

rpc.incoming[95] = {
    {'id', 'int32', false},
    {'model', 'int32', false},
    {'pickupType', 'int32', false},
    {'position', 'vector3d', false},
}

rpc.incoming[99] = {
    {'objectId', 'int16', false},
    {'fromPos', 'vector3d', false},
    {'destPos', 'vector3d', false},
    {'speed', 'float', false},
    {'rotation', 'vector3d', false},
}

rpc.incoming[104] = {
    {'state', 'bool', false}
}

rpc.incoming[105] = {
    {'id', 'int16', false},
    {'text', 'string16', false},
}

rpc.incoming[107] = {
    {'position', 'vector3d', false},
    {'radius', 'float', false},
}

rpc.incoming[108] = {
    {'zoneId', 'int16', false},
    {'squareStart', 'vector2d', false},
    {'squareEnd', 'vector2d', false},
    {'color', 'int32', false}
}

rpc.incoming[112] = {
    {'suspectId', 'int16', false},
    {'unk', 'Int32Array3', false},
    {'crime', 'int32', false},
    {'coordinates', 'vector3d', false},
}

rpc.incoming[120] = {
    {'zoneId', 'int16', false},
}

rpc.incoming[121] = {
    {'zoneId', 'int16', false},
    {'color', 'int32', false}
}

rpc.incoming[122] = {
    {'objectId', 'int16'}
}

rpc.incoming[123] = {
    {'vehicleId', 'int16', false},
    {'text', 'string8', false}
}

rpc.incoming[124] = {
    {'state', 'bool32', false},
}

rpc.incoming[126] = {
    {'playerId', 'int16', false},
    {'camType', 'int8', false},
}

rpc.incoming[127] = {
    {'vehicleId', 'int16', false},
    {'camType', 'int8', false},
}

rpc.incoming[134] = {
    {'textDrawId', 'int16', false},
    {'flags', 'int8', false},
    {'letterWidth', 'float', false},
    {'letterHeight', 'float', false},
    {'letterColor', 'int32', false},
    {'lineWidth', 'float', false},
    {'lineHeight', 'float', false},
    {'boxColor', 'int32', false},
    {'shadow', 'int8', false},
    {'outline', 'int8', false},
    {'bgColor', 'int32', false},
    {'style', 'int8', false},
    {'selectable', 'int8', false},
    {'position', 'vector2d', false},
    {'modelId', 'int16', false},
    {'rotation', 'vector3d', false},
    {'zoom', 'float', false},
    {'color', 'int32', false},
    {'text', 'string16', false},
}

rpc.incoming[133] = {
    {'wantedLevel', 'int8', false},
}

rpc.incoming[135] = {
    {'textDrawId', 'int16', false},
}

rpc.incoming[144] = {
    {'iconId', 'int8', false},
}

rpc.incoming[145] = {
    {'weaponId', 'int8', false},
    {'ammo', 'int16', false},
}

rpc.incoming[146] = {
    {'gravity', 'float', false}
}

rpc.incoming[147] = {
    {'vehicleId', 'int16', false},
    {'health', 'float', false},
}

rpc.incoming[148] = {
    {'trailerId', 'int16', false},
    {'vehicleId', 'int16', false},
}

rpc.incoming[149] = {
    {'vehicleId', 'int16', false}
}

rpc.incoming[152] = {
    {'weatherId', 'int8', false}
}

rpc.incoming[153] = {
    {'playerId', 'int16', false},
    {'skinId', 'int32', false},
}

rpc.incoming[156] = {
    {'interior', 'int8', false}
}

rpc.incoming[157] = {
    {'camPos', 'vector3d', false},
}

rpc.incoming[158] = {
    {'lookAtPos', 'vector3d', false},
    {'cutType', 'int8', false},
}

rpc.incoming[159] = {
    {'vehicleId', 'int16', false},
    {'position', 'vector3d', false}
}

rpc.incoming[160] = {
    {'vehicleId', 'int16', false},
    {'angle', 'float', false}
}

rpc.incoming[161] = {
    {'vehicleId', 'int16', false},
    {'objective', 'bool8', false},
    {'doorsLocked', 'bool8', false},
}

rpc.incoming[162] = {}

rpc.incoming[101] = {
    {'playerId', 'int16', false},
    {'text', 'string8', false}
}

rpc.incoming[130] = {
    {'reason', 'int8', false}
}

rpc.incoming[163] = {
    {'playerId', 'int16', false}
}

rpc.incoming[164] = {
    {'vehicleId', 'int16', false},
    {'type', 'int32', false},
    {'position', 'vector3d', false},
    {'rotation', 'float', false},
    {'interiorColor1', 'int8', false},
    {'interiorColor2', 'int8', false},
    {'health', 'float', false},
    {'interiorId', 'int8', false},
    {'doorDamageStatus', 'int32', false},
    {'panelDamageStatus', 'int32', false},
    {'lightDamageStatus', 'int8', false},
    {'addSiren', 'int8', false},
    {'modSlots', 'vehicleModSlots', false},
    {'paintJob', 'int8', false},
    {'bodyColor1', 'int32', false},
    {'bodyColor2', 'int32', false},
    {'unk', 'int8', false},
}

rpc.incoming[165] = {
    {'vehicleId', 'int16', false}
}

rpc.incoming[166] = {
    {'playerId', 'int16', false},
}

rpc.incoming[26] = {
    {'playerId', 'int16', false},
    {'vehicleId', 'int16', false},
    {'passenger', 'bool8', false}
}

rpc.incoming[155] = {
   -- {'playerList', 'PlayerScorePingMap', false} -- я думаю при вызове все умрет, но хз
}

rpc.incoming[84] = {
    {'objectId', 'int16', false},
    {'materialData', 'objectMaterialDataSet', false}
}

rpc.incoming[171] = {
    {'actorId', 'int16', false},
    {'skinId', 'int32', false},
    {'position', 'vector3d', false},
    {'rotation', 'float', false},
    {'health', 'float', false},
}

rpc.incoming[83] = {
    {'state', 'bool', false},
    {'hovercolor', 'int32', false,}
}

rpc.incoming[24] = {
    {'vehicleId', 'int16', false},
    {'engine', 'int8', false},
    {'lights', 'int8', false},
    {'alarm', 'int8', false},
    {'doors', 'int8', false},
    {'bonnet', 'int8', false},
    {'boot', 'int8', false},
    {'objective', 'int8', false},
    {'unk', 'int8', false},
    {'driver', 'int8', false},
    {'passenger', 'int8', false},
    {'backleft', 'int8', false},
    {'backright', 'int8', false},
    {'windows_driver', 'int8', false},
    {'windows_passenger', 'int8', false},
    {'windows_backleft', 'int8', false},
    {'windows_backright', 'int8', false},
}

rpc.incoming[113] = {
    {'playerId', 'int16', false},
    {'index', 'int32', false},
    {'create', 'bool', false},
    {'modelId', 'int32', false},
    {'bone', 'int32', false},
    {'offset', 'vector3d', false},
    {'rotation', 'vector3d', false},
    {'scale', 'vector3d', false},
    {'color1', 'int32', false},
    {'color2', 'int32', false},
}

return rpc 