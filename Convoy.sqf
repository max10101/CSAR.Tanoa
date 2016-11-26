WaitUntil {CampsInitialised};
CSAR_fnc_InjectConvoyWP = compile '
private ["_current","_newWP","_newpos","_group"];
_group = _this select 0;
_newpos = _this select 1;
_current = currentWaypoint _group;
[_group,_current] setWaypointStatements ["true",""];
_newWP = _group addWaypoint [_newPos, 0];
call compile format ["_newWP setWaypointStatements [""true"", ""group this setcurrentwaypoint [group this,%1];""]",_current];
_group setcurrentwaypoint _newWP;
[_group,_current] setWaypointStatements ["true", "this execvm ""ConvoyNewWaypoint.sqf"""];
_newWP
';

sleep 3;
_MaxConvoys = 16;
_backupgroup = false;
_connected = 0;
_ArmedCars = ["O_LSV_02_unarmed_F","I_G_Offroad_01_armed_F"];
_Trucks = ["I_Truck_02_covered_F","I_Truck_02_transport_F"];
_Cars = ["I_G_Offroad_01_F","I_G_Van_01_transport_F","I_C_Offroad_02_unarmed_F"];
_spawns = EnemyCamps + BigEnemyCamps + [POWCamp,IntelMap,AACamp] ;
_spawn = selectrandom _spawns;
_ConvoyWaypoints = [];
_grp = objnull;
_backupPos = [0,0,0];
_vehicle2 = objnull;

_fillCar = compile '
private ["_vehicle","_grp","_leader","_gunner"];
	_vehicle = _this select 0;
	_grp = _this select 1;
	_leader = _grp createUnit ["I_C_Soldier_Bandit_7_F", [0,0,0], [], 0, "FORM"];
	_gunner = _grp createUnit ["I_C_Soldier_Bandit_7_F", [0,0,0], [], 0, "FORM"];
	_leader assignasdriver _vehicle;
	_leader moveindriver _vehicle;
	IF (_vehicle emptypositions "Gunner" >= 1) then {_gunner assignasgunner _vehicle;_gunner moveingunner _vehicle} else {_gunner assignascargo _vehicle;_gunner moveincargo _vehicle};
	_grp addvehicle _vehicle;
	_vehicle
';

// COMPILE NEAREST ROADS TO POTENTIAL CAMP LOCATIONS
{_NearRoads = (getpos _x) NearRoads 150;
IF (count _NearRoads >= 1) then {_ConvoyWaypoints = _ConvoyWaypoints + [_NearRoads select 0]}} foreach _spawns;
CSAR_ConvoyRoads = _ConvoyWaypoints;
//IF (_MaxConvoys > count _ConvoyWaypoints) then {_MaxConvoys = (count _ConvoyWaypoints)};
IF (CSAR_DEBUG) then {{_marker = createMarkerlocal[format ["Road (%1)",random 9999], getPos _x];_marker setMarkerSizelocal [0.7, 0.7];_marker setMarkerColorlocal "ColorRed";_marker setMarkerTypelocal "o_motor_inf";} foreach _ConvoyWaypoints;};


_i = 0;
While {_i < _MaxConvoys} do {

	//SPAWN A CAR ON A ROAD
	_randomroad = (selectrandom _ConvoyWaypoints);
	_Convoywaypoints = _Convoywaypoints - [_randomroad];
	_vehicle = (Selectrandom (_ArmedCars + _Cars)) createvehicle (getpos _randomroad);
	_grp = createGroup Independent;
	[_vehicle,_grp] call _fillCar;
	IF (count (roadsConnectedTo _randomroad) > 0) then {_connected = (roadsConnectedTo _randomroad) select 0} else {_connected = _randomroad};
	_dir = ((getpos _randomroad select 0)-((getPos _connected) select 0)) atan2 ((getpos _randomroad select 1)-(getPos _connected select 1));
	_vehicle setdir _dir;
	_vehicle addeventhandler ["Dammaged",{_this execvm "brokenwheel.sqf"}];
	_vehicle setUnloadInCombat [true, false];
	csar_zeus addCuratorEditableObjects [[_vehicle],true];
	IF (_vehicle in ["I_G_Offroad_01_armed_F"]) then {_vehicle addEventHandler ["Fired",{[_this] call RecoilFunction}];};
	_vehicle limitspeed 30;

	//MAYBE SPAWN A BACKUP CAR
	sleep 0.1;

	IF (random 1 > 0.3) then {
		_selection = selectrandom (_Trucks + _Cars);
		IF (_selection in _trucks) then {_backupgroup = true;} else {_backupgroup = false;};
		_BackupPos = (getpos _randomroad) findEmptyPosition [5, 100, _selection];
		IF (IsNil "_BackupPos") then {_BackupPos = [(getpos _randomroad select 0),(getpos _randomroad select 1)-15,0]};
		_vehicle2 = _selection createvehicle _backuppos;
		[_vehicle2,_grp] call _fillCar;
		_dir = ((getpos _vehicle select 0)-(getPos _vehicle2 select 0)) atan2 ((getpos _vehicle select 1)-(getPos _vehicle2 select 1));
		_vehicle2 setdir _dir;
		csar_zeus addCuratorEditableObjects [[_vehicle2],true];
		_vehicle2 addeventhandler ["Dammaged",{_this execvm "brokenwheel.sqf"}];
		_vehicle2 setUnloadInCombat [true, false];
		IF (_vehicle2 in ["I_G_Offroad_01_armed_F"]) then {_vehicle2 addEventHandler ["Fired",{[_this] call RecoilFunction}];};
		//JOIN GROUP AND SET WAYPOINT
		_vehicle2 limitspeed 30;
		
	};
	
	IF (count _Convoywaypoints <= 0) then {
		_Convoywaypoints = [];
		{_NearRoads = (getpos _x) NearRoads 125;
		IF (count _NearRoads >= 1) then {_ConvoyWaypoints = _ConvoyWaypoints + [_NearRoads select 0]}} foreach CSAR_CampLocations;
	};

	IF (_backupgroup) then {
		_backup = [_backuppos, Independent, CSAR_BanditGroupSmall] call BIS_fnc_spawnGroup;
		{_x assignascargo _vehicle2;_x moveincargo _vehicle2} foreach units _backup;
		(units _backup) join _grp;
		_backupgroup = false;
	};

	_grp setbehaviour "SAFE";
	_grp setspeedmode "LIMITED";
	_grp setformation "COLUMN";
	_movepos = getpos (SelectRandom (CSAR_Convoyroads - [_spawn]));
	_wp = _grp addWaypoint [_movepos, 0];
	_wp setWaypointStatements ["true", "this execvm ""ConvoyNewWaypoint.sqf"""];
	_wp setwaypointtype "MOVE";
	_wp setWaypointCompletionRadius 30;
	//{_x limitspeed 20} foreach (units _grp);
	_i = _i + 1;
	sleep 4;
	{[_x,false,false] call opfor_fnc_initUnit;_x setcombatmode "RED";} forEach units _grp;
};

ConvoysInitialised = true;
IF (CSAR_DEBUG) then {systemchat "Convoys initialised"};
