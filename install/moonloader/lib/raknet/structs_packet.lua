local packets = {}

packets[207] = {
    recv = {
        {'leftRightKeys', 'int16', true},
        {'upDownKeys', 'int16', true},
        {'keysData', 'int16', false},
        {'position', 'vector3d', false},
        {'quaternion', 'normQuat', false},
        {'health/armor', 'decompressHealthAndArmor', false},
        {'weapon', 'int8', false},
        {'specialAction', 'int8', false},
        {'moveSpeed', 'compressedVector', false},
        {
            {'surfingVehicleId', 'surfingOffsets'}, {'int16', 'vector3d'}, true
        },
        {
            {'animationId', 'animationFlags'}, {'int16', 'int16'}, true
        }
    },
    send = {
        {'leftRightKeys', 'int16', false},
        {'upDownKeys', 'int16', false},
        {'keysData', 'int16', false},
        {'position', 'vector3d', false},
        {'quaternion', 'floatQuat', false},
        {'health', 'int8', false},
        {'armor', 'int8', false},
        {'weapon', 'int8', false},
        {'specialAction', 'int8', false},
        {'moveSpeed', 'vector3d', false},
        {'surfingOffsets', 'vector3d', false},
        {'surfingVehicleId', 'int16', false},
        {'animationId', 'int16', false},
        {'animationFlags', 'int16', false},
    }
}

packets[200] = {
    recv = {
        {'vehicleId', 'int16', false},
        {'leftRightKeys', 'int16', false},
        {'upDownKeys', 'int16', false},
        {'keysData', 'int16', false},
        {'quaternion', 'normQuat', false},
        {'position', 'vector3d', false},
        {'moveSpeed', 'compressedVector', false},
        {'vehicleHealth', 'int16', false},
        {'playerHealth/armor', 'decompressHealthAndArmor', false},
        {'weapon', 'int8', false},
        {'siren', 'bool', false},
        {'landingGear', 'bool', false},
        {'trainSpeed', 'float', true},
        {'trailerId', 'int16', true}
    },
    send = {
        {'vehicleId', 'int16', false},
        {'leftRightKeys', 'int16', false},
        {'upDownKeys', 'int16', false},
        {'keysData', 'int16', false},
        {'quaternion', 'floatQuat', false},
        {'position', 'vector3d', false},
        {'moveSpeed', 'vector3d', false},
        {'vehicleHealth', 'float', false},
        {'playerHealth', 'int8', false},
        {'armor', 'int8', false},
        {'weapon', 'int8', false},
        {'siren', 'int8', false},
        {'landingGearState', 'int8', false},
        {'trailerId', 'int16', false},
        {'trainSpeed', 'float', false},
    }
}

packets[211] = {
    {'vehicleId', 'int16', false},
    {'seatId', 'int8', false},
    {'weapon', 'int8', false},
    {'health', 'int8', false},
    {'armor', 'int8', false},
    {'leftRightKeys', 'int16', false},
    {'upDownKeys', 'int16', false},
    {'keysData', 'int16', false},
    {'position', 'vector3d', false},
}

packets[210] = {
    {'trailerId', 'int16', false},
    {'position', 'vector3d', false},
    {'roll', 'vector3d', false},
    {'direction', 'vector3d', false},
    {'speed', 'vector3d', false},
    {'unk', 'int32', false}
}

packets[209] = {
    {'vehicleId', 'int16', false},
    {'seatId', 'int8', false},
    {'roll', 'vector3d', false},
    {'direction', 'vector3d', false},
    {'position', 'vector3d', false},
    {'moveSpeed', 'vector3d', false},
    {'turnSpeed', 'vector3d', false},
    {'vehicleHealth', 'float', false},
}

packets[203] = {
    {'camMode', 'int8', false},
    {'camFront', 'vector3d', false},
    {'camPos', 'vector3d', false},
    {'aimZ', 'float', false},
    {'camExtZoom', 'int8', false},
    {'weaponState', 'int8', false},
    {'unk', 'int8', false},
}

packets[206] = {
    {'targetType', 'int8', false},
    {'targetId', 'int16', false},
    {'origin', 'vector3d', false},
    {'target', 'vector3d', false},
    {'center', 'vector3d', false},
    {'weapon', 'int8', false},
}

return packets