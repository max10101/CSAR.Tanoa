CSAR_fnc_respawnMenuposition_Killed = false;
CSAR_fnc_findNearestUnit = compile preprocessFile "CSAR_Respawn_fn_FindNearestUnit.sqf";
CSAR_Respawn_NearestUnit = compile preprocessFile "CSAR_Respawn_NearestUnit.sqf";
/* MOVED TO INIT
CSAR_fnc_initSpawn = compile '
    _unit = _this;
    if (local _unit) then {
        mattzig_earPlugsInUse = false;
        1 fadeSound 1;
		_unit setunittrait ["Engineer",1];
        _unit addEventHandler ["HandleRating", "_rating = (_this select 1);if (_rating < 0) then {_rating = 0;}; _rating"];
        _unit enablefatigue false;
        _putEarOn = ["<t color=""#ffff33"">Put on ear plugs</t>",{1 fadeSound 0.3; mattzig_earPlugsInUse = true;},[],-90,false,true,"","!mattzig_earPlugsInUse && vehicle player == vehicle _target"];
        _takeEarOff = ["<t color=""#ffff33"">Take off ear plugs</t>",{1 fadeSound 1; mattzig_earPlugsInUse = false;},[],-90,false,true,"","mattzig_earPlugsInUse && vehicle player == vehicle _target"];
        _unit addAction _putEarOn;
        _unit addAction _takeEarOff;
        if (!(isPlayer (leader group _unit))) then {
            if (local (leader group _unit)) then {
                (group _unit) selectLeader _unit;
            } else {
                [group _unit, _unit] remoteExec ["selectLeader", leader group _unit];
            };
         };
        [_unit] execVM "Support\addActions.sqf";
        //[] spawn FAR_Player_Init;
    };
';
*/
 disableserialization;

_markerSpawnNearest = createMarkerLocal["spawn_nearest",getpos Player];
    _markerSpawnNearest setMarkerTypeLocal "flag_Canada";
    _markerSpawnNearest setMarkerTextLocal "Closest Unit";
    _markerSpawnNearest setMarkerAlphaLocal 0;


sleep 1;

//[west, "WEST1"] call BIS_fnc_addRespawnInventory;
//[west, "WEST2"] call BIS_fnc_addRespawnInventory;
[west,"spawn_nearest","Closest Unit",-1,false] call BIS_fnc_addRespawnPosition;
[west, "spawn_airbase","Airbase",-1,false] call BIS_fnc_addRespawnPosition;
[west, "spawn_fob", "FOB",-1,false] call BIS_fnc_addRespawnPosition;

_justDied = false;
_timeOfDeath = time;
_corpse = objnull;
_spawnMarker = "";
_num = 1;

while {true} do {
    _num = _num + 1;
	sleep 0.05;
	if (local player) then {
        if (!alive player) then {
            if (!_justDied) then {
                //player sideChat "Just Died";
                _corpse = player;
                _justDied = true;
                _timeOfDeath = time;
            };
            if (_num % 10 == 0) then {
                _num = 1;
                _list = uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlLocList";
                if (uiNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown",false]) then {_list = uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlLocList"};
                _curSel = if !(lbCurSel _list < 0) then {lbCurSel _list} else {0};
                if !(isNil {uiNamespace getVariable "BIS_RscRespawnControls_posMetadata"}) then {
                    _metadata = ["get",_curSel] call BIS_fnc_showRespawnMenuPositionMetadata;
                    _spawnMarker = (_metadata select 0) select 0;
                };
                _nearestUnit = [player,player,list WestUnits] call CSAR_fnc_findNearestUnit;
                if (!(isNull _nearestUnit)) then {
                    "spawn_nearest" setMarkerPosLocal (getPos _nearestUnit);
                    _name = "";
                    if (!isPlayer leader group _nearestUnit) then {_name = "AI";};
                    if (isPlayer (leader group _nearestUnit)) then {
                        if ((leader group _nearestUnit) == player) then {_name = "Your";}
                        else {_name = format ["%1's",name leader group _nearestUnit];};
                    };
                    "spawn_nearest" setMarkerTextLocal format ["Closest Unit (%1 Group)",_name];
                    if (markerAlpha "spawn_nearest" < 1) then {"spawn_nearest" setMarkerAlphaLocal 1;};
                };
            };
        } else {
            if (_justDied) then {
                if (_spawnMarker == "spawn_nearest") then {
                    [player,_corpse] call CSAR_Respawn_NearestUnit;
                };
                _justDied = false;
                if (markerAlpha "spawn_nearest" > 0) then {"spawn_nearest" setMarkerAlphaLocal 0;};
                player call CSAR_fnc_initSpawn;
            };
        };
	};
}