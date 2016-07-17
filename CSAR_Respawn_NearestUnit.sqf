_oldUnit = _this select 0;
_corpse = _this select 1;

if (local _oldUnit) then {

    _respawnUnit = [_oldUnit,_corpse,list WestUnits] call CSAR_fnc_findNearestUnit;
    while {isPlayer _respawnUnit} do {
         sleep 0.1;
        _respawnUnit = [_oldUnit,_corpse,list WestUnits] call CSAR_fnc_findNearestUnit;
    };


    if (!(isNull _respawnUnit)) then {
        addSwitchableUnit _respawnUnit;
		selectPlayer _respawnUnit;

        waitUntil {player == _respawnUnit && isPlayer _respawnUnit && local _respawnUnit};
		[] execvm "SelectPlayerRevive.sqf";
        _oldUnit setPos [0,0,1000];
        [_oldUnit] join grpNull;
        deleteVehicle _oldUnit;
    }  else
    {
        player setPos getMarkerPos("spawn_airbase");
    }
}