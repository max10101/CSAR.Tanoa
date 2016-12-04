_oldUnit = _this select 0;
_corpse = _this select 1;

if (local _oldUnit) then {

    _respawnUnit = [_oldUnit,_corpse,list WestContacts] call CSAR_fnc_findNearestUnit;

    if (!(isNull _respawnUnit)) then {

		selectPlayer _respawnUnit;
        waitUntil {player == _respawnUnit && isPlayer _respawnUnit && local _respawnUnit};
		[] execvm "SelectPlayerRevive.sqf";
        _oldUnit setPos [0,0,1000];
        [_oldUnit] join grpNull;
		_grp = group _oldUnit;
        deleteVehicle _oldUnit;
		deletegroup _grp;
    }  else
    {
        player setPos getMarkerPos("spawn_airbase");
    }
}