_camp = _this;
_pos = getpos _camp;
_spawns = CSAR_CampLocations - [_camp];
_MaxWPs = 3;
_add = 0;
_wps = [];
sleep (random 3);
_group = [[(_pos select 0)+50-random 100,(_pos select 1)+50-random 100,0], Independent, CSAR_BanditGroup] call BIS_fnc_spawnGroup;

_closestcamps = [_spawns,[],{_camp distance _x},"ASCEND"] call BIS_fnc_sortBy;
_wp = _group addWaypoint [[(_pos select 0)+50-random 100,(_pos select 1)+50-random 100,0], 0];

_i = 0;
while {_i < (_MaxWPs + 1)} do {
	_wps = _wps + [(_closestcamps select _i)];
	_i = _i + 1;
	sleep 0.01;
};
_wps call BIS_fnc_arrayShuffle;
_index = 0;
_rand = random 1;
IF (_rand > 0.33) then {_index = 1};
IF (_rand > 0.66) then {_index = 2};
IF ((_camp distance2d POWCamp) < 1500 && (_add <= 3)) then {_wps = _wps - [POWCamp];_wps set [_index,POWCamp];_add = _add + 1;};
_i = 0;
while {_i < _MaxWPs} do {
	_wp = _group addWaypoint [[((getpos (_wps select _i)) select 0)+50-random 100,((getpos (_wps select _i)) select 1)+50-random 100,0], 0];
	_i = _i + 1;
	sleep 0.1;
};

//player sidechat str (waypoints _group);

{
_x setwaypointtype "MOVE";
_x setWaypointStatements ["true", ""];
} foreach (waypoints _group);

(waypoints _group) select ((count waypoints _group)-1) setwaypointtype "CYCLE";

{[_x,true,true,true] call opfor_fnc_initUnit} forEach units _group;
_group setbehaviour "AWARE";
