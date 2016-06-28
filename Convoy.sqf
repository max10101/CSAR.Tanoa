
_MaxConvoys = 1;
_connected = 0;
_ArmedCars = ["O_LSV_02_unarmed_F","I_G_Offroad_01_armed_F"];
_Trucks = ["I_Truck_02_covered_F","I_Truck_02_transport_F"];
_Cars = ["I_G_Offroad_01_F","I_G_Van_01_transport_F","I_C_Offroad_02_unarmed_F"];
_spawns = CSAR_CampLocations;
_spawn = selectrandom _spawns;
_ConvoyWaypoints = [];

//SPAWN A CAR WITH TWO CREW - [_type,_pos] call _Spawncar
_SpawnCar = compile '
private ["_vehicle","_grp","_leader","_gunner"];
	_vehicle = (_this select 0) createvehicle (_this select 1);

	_grp = createGroup Independent;
	_leader = _grp createUnit ["I_C_Soldier_Bandit_7_F", [0,0,0], [], 0, "FORM"];
	_gunner = _grp createUnit ["I_C_Soldier_Bandit_7_F", [0,0,0], [], 0, "FORM"];
	_leader moveindriver _vehicle;
	IF (_vehicle emptypositions "Gunner" >= 1) then {_gunner moveingunner _vehicle} else {_gunner moveincargo _vehicle};
	_grp addvehicle _vehicle;
	_vehicle
';


// COMPILE NEAREST ROADS TO POTENTIAL CAMP LOCATIONS
{_NearRoads = (getpos _x) NearRoads 100;IF (count _NearRoads >= 1) then {_ConvoyWaypoints = _ConvoyWaypoints + [_NearRoads select 0]}} foreach _spawns;
CSAR_ConvoyRoads = _ConvoyWaypoints;
IF (CSAR_DEBUG) then {{_marker = createMarker[format ["Road (%1)",random 9999], getPos _x];_marker setMarkerSize [0.7, 0.7];_marker setMarkerColor "ColorRed";_marker setMarkerType "o_motor_inf";} foreach _ConvoyWaypoints;};


_i = 0;
While {_i < _MaxConvoys} do {

//SPAWN A CAR ON A ROAD
_randomroad = (selectrandom _ConvoyWaypoints);
_Convoywaypoints = _Convoywaypoints - [_randomroad];
_vehicle = [Selectrandom (_ArmedCars + _Cars),getpos _randomroad] call _spawncar;
IF (count (roadsConnectedTo _randomroad) > 0) then {_connected = (roadsConnectedTo _randomroad) select 0} else {_connected = _randomroad};
_dir = ((getpos _randomroad select 0)-((getPos _connected) select 0)) atan2 ((getpos _randomroad select 1)-(getPos _connected select 1));
_vehicle setdir _dir;
_grp = group (leader (driver _vehicle));
_vehicle addeventhandler ["Dammaged",{_this execvm "brokenwheel.sqf"}];
_vehicle setUnloadInCombat [true, false];

//MAYBE SPAWN A BACKUP CAR
sleep 0.1;
IF (random 1 > 0) then {
_selection = selectrandom (_Trucks + _Cars);
_BackupPos = (getpos _randomroad) findEmptyPosition [10, 100, _selection];
_vehicle2 = [_selection,_backuppos] call _spawncar;
_dir = ((getpos _vehicle select 0)-(getPos _vehicle2 select 0)) atan2 ((getpos _vehicle select 1)-(getPos _vehicle2 select 1));
_vehicle2 setdir _dir;
_vehicle2 addeventhandler ["Dammaged",{_this execvm "brokenwheel.sqf"}];
_vehicle2 setUnloadInCombat [true, false];

//JOIN GROUP AND SET WAYPOINT
(crew _vehicle2) join _grp;
_grp addvehicle _vehicle2;
//player moveincargo _vehicle2;
//[player] join _grp;
};
_grp setbehaviour "SAFE";
_grp setspeedmode "LIMITED";
_grp setformation "COLUMN";

_movepos = getpos (SelectRandom _ConvoyWaypoints);
_wp = _grp addWaypoint [_movepos, 0];
_wp setWaypointStatements ["true", "this execvm ""ConvoyNewWaypoint.sqf"""];
_wp setwaypointtype "MOVE";
_wp setWaypointCompletionRadius 30;
{_x limitspeed 30} foreach (units _grp);
_i = _i + 1;
sleep 1;
};
