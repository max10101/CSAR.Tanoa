_groupleader = _this;
_group = group _groupleader;
IF (!Local _groupleader) ExitWith {};
_abandon = false;
_close = [];
_camps = CSAR_CampLocations;
//CHECK IF ALL UNITS ARE STILL IN A VEHICLE
IF (({Vehicle _x == _x} count (units _group)) >= 1) then {_abandon = true;};

_spawns = [IntelMap,POWCamp,AACamp];
_ImportantWaypoints = [];
{
	_NearRoads = (getpos _x) NearRoads 150;
	IF (count _NearRoads >= 1) then {
		_ImportantWaypoints = _ImportantWaypoints + [_NearRoads select 0]
	}
} foreach _spawns;


IF (_abandon) then {
//ABANDON VEHICLES AND MOVE TO NEAREST CAMP

_close = [_camps,[(leader _group)],{(leader _group) distance _x},"ASCEND",{(_input0 distance _x) < 500}] call BIS_fnc_sortBy;
IF (count _close <= 0) then {_close = [_groupleader]};
_closest = _close select 0;
{Unassignvehicle _x} foreach units _group;
(units _group) ordergetin false;

_movepos = [(getpos _closest select 0)+50-random 100,(getpos _closest select 1)+50-random 100,0];
_wp = _group addWaypoint [_movepos, 0];
_wp setWaypointStatements ["true", ""];
_wp setwaypointtype "MOVE";
_wp setWaypointCompletionRadius 30;

_wp = _group addWaypoint [_movepos, 0];
_wp setWaypointStatements ["true", ""];
_wp setwaypointtype "LOITER";

_group setbehaviour "SAFE";
_group setspeedmode "NORMAL";
_group setformation "COLUMN";
{_x limitspeed 30} foreach (units _Group);
} else {
//RETURN TO NORMAL BEHAVIOUR AND CHOOSE A NEW WP
_group setbehaviour "SAFE";
_group setspeedmode "LIMITED";
_group setformation "COLUMN";

_movepos = getpos (SelectRandom CSAR_ConvoyRoads);
IF ((count _ImportantWaypoints) > 0 && (random 1 > 0.3)) then {_movepos = getpos (SelectRandom _ImportantWaypoints)};
_wp = _group addWaypoint [_movepos, 0];
_wp setWaypointStatements ["true", "this execvm ""ConvoyNewWaypoint.sqf"""];
_wp setwaypointtype "MOVE";
_wp setWaypointCompletionRadius 30;
{_x limitspeed 30} foreach (units _Group);
};