_camp = _this;
_pos = getpos _camp;
_spawns = CSAR_CampLocations - [_camp];
_MaxWPs = 3;
_wps = [];
sleep (random 3);
_group = [[(_pos select 0)+50-random 100,(_pos select 1)+50-random 100,0], Independent, (configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "BanditCombatGroup")] call BIS_fnc_spawnGroup;

_closestcamps = [_spawns,[],{_camp distance _x},"ASCEND"] call BIS_fnc_sortBy;
_wp = _group addWaypoint [[(_pos select 0)+50-random 100,(_pos select 1)+50-random 100,0], 0];

_i = 0;
while {_i < (_MaxWPs + 1)} do {
	_wps = _wps + [(_closestcamps select _i)];
	_i = _i + 1;
	sleep 0.01;
};
_wps call BIS_fnc_arrayShuffle;
_i = 0;
while {_i < _MaxWPs} do {
	_wp = _group addWaypoint [[((getpos (_wps select _i)) select 0)+50-random 100,((getpos (_wps select _i)) select 1)+50-random 100,0], 0];
	//_wp = _group addWaypoint [[(_pos select 0)+50-random 100,(_pos select 1)+50-random 100,0], 0];
	_i = _i + 1;
	sleep 0.1;
};

//player sidechat str (waypoints _group);

{
_x setwaypointtype "MOVE";
_x setWaypointStatements ["true", ""];
} foreach (waypoints _group);

(waypoints _group) select ((count waypoints _group)-1) setwaypointtype "CYCLE";

_group setbehaviour "AWARE";
_group setvariable ["Patrol",1];
[_group,3,1500] execvm "groupreduction.sqf";