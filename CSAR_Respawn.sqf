CSAR_fnc_respawnMenuposition_Killed = false;
CSAR_fnc_findNearestUnit = compile preprocessFile "CSAR_Respawn_fn_FindNearestUnit2.sqf";
CSAR_Respawn_NearestUnit = compile preprocessFile "CSAR_Respawn_NearestUnit.sqf";
/* 
CSAR_fnc_initSpawn = compile '
MOVED TO INIT
*/
 disableserialization;

_markerSpawnNearest = createMarkerLocal["spawn_nearest",getpos Player];
    _markerSpawnNearest setMarkerTypeLocal "flag_Canada";
    _markerSpawnNearest setMarkerTextLocal "Closest Unit";
    _markerSpawnNearest setMarkerAlphaLocal 0;


sleep 1;

//[west, "WEST1"] call BIS_fnc_addRespawnInventory;
//[west, "WEST2"] call BIS_fnc_addRespawnInventory;
[west,"spawn_nearest","Group/Closest Unit",-1,false] call BIS_fnc_addRespawnPosition;
[west, "spawn_airbase","Airbase",-1,false] call BIS_fnc_addRespawnPosition;
[west, "spawn_fob", "Airbase",-1,false] call BIS_fnc_addRespawnPosition;

_justDied = false;
_timeOfDeath = time;
_corpse = objnull;
_spawnmarker = "";
_num = 1;

while {true} do {
    _num = _num + 1;
	sleep 0.05;
	if (local player) then {
        if (!alive player) then {
            if (!_justDied) then {

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
                    _spawnmarker = (_metadata select 0) select 0;
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
                if (_spawnmarker == "spawn_nearest") then {
                    [player,_corpse] call CSAR_Respawn_NearestUnit;

                };
                _justDied = false;
                if (markerAlpha "spawn_nearest" > 0) then {"spawn_nearest" setMarkerAlphaLocal 0;};
                player call CSAR_fnc_initSpawn;
            };
        };
	};
}