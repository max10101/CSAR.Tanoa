_oldUnit = _this select 0;
_corpse = _this select 1;
diag_log format ["Begin respawn for %1",name player];

_progress = [] spawn {
startLoadingScreen ["Respawning..."];
_i = 0;
while {_i < 2} do {_i = _i + 0.05;uisleep 0.05;progressLoadingScreen _i;};
endLoadingScreen;
};

if (local _oldUnit) then {

    _respawnUnit = [_oldUnit,_corpse,playableunits] call CSAR_fnc_findNearestUnit;
	uisleep 0.1;
	10 preloadObject _respawnUnit;
	waitUntil {preloadCamera (getpos _respawnUnit)};
    if (!(isNull _respawnUnit && alive _respawnUnit)) then {
		diag_log format ["Player %3 respawning as %1 (Alive? %4), oldunit is %2",_respawnUnit,_oldUnit,name player,alive _respawnUnit];
		selectPlayer _respawnUnit;
        waitUntil {player == _respawnUnit && isPlayer _respawnUnit && local _respawnUnit};
		diag_log "Execute SelectPlayerRevive.sqf";
		[] execvm "SelectPlayerRevive.sqf";
		diag_log "Moving old unit";
        _oldUnit setPos [0,0,1000];
        [_oldUnit] join grpNull;
		_grp = group _oldUnit;
		diag_log "Deleting old unit";
        deleteVehicle _oldUnit;
		deletegroup _grp;
		
    }  else
    {
	diag_log "Respawn screwed, spawning airbase";
        player setPos getMarkerPos("spawn_airbase");
		systemchat "Respawn unit died - choosing base location";
    };
};
diag_log format ["Respawn completed for %1 at %2",name player,time];