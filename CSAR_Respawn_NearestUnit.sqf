_oldUnit = _this select 0;
_corpse = _this select 1;

_progress = [] spawn {
startLoadingScreen ["Respawning..."];
_i = 0;
while {_i < 3} do {_i = _i + 0.05;uisleep 0.05;progressLoadingScreen _i;};
endLoadingScreen;
};

if (local _oldUnit) then {

    _respawnUnit = [_oldUnit,_corpse,playableunits] call CSAR_fnc_findNearestUnit;
	uisleep 1.5;
    if (!(isNull _respawnUnit && alive _respawnUnit)) then {
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
		systemchat "Respawn unit died - choosing base location";
    }
}