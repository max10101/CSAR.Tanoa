_oldUnit = _this select 0;
_corpse = _this select 1;
if (local _oldUnit) then {

    _respawnUnit = [_oldUnit,_corpse,list WestUnits] call CSAR_fnc_findNearestUnit;
    while {isPlayer _respawnUnit} do {
        player sideChat "DEBUG --- Selected a Player to spawn into, trying again ---";
         sleep 1;
        _respawnUnit = [_oldUnit,_corpse,list WestUnits] call CSAR_fnc_findNearestUnit;
    };


    if (!(isNull _respawnUnit)) then {
        selectPlayer _respawnUnit;
        waitUntil {player == _respawnUnit && isPlayer _respawnUnit && local _respawnUnit};
        _oldUnit setPos [0,0,1000];
        [_oldUnit] join grpNull;
        deleteVehicle _oldUnit;
    }  else
    {
        player setPos getMarkerPos("spawn_airbase");
    }
}