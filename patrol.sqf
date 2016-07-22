sleep 1;
_group = _this;

CSAR_fnc_InjectPatrolWP = compile '
private ["_current","_newWP","_newpos","_group"];
_group = _this select 0;
_newpos = _this select 1;
_current = currentWaypoint _group;
[_group,_current] setWaypointStatements ["true",""];
_newWP = _group addWaypoint [_newPos, 0];
call compile format ["_newWP setWaypointStatements [""true"", ""group this setcurrentwaypoint [group this,%1];""]",_current];
_group setcurrentwaypoint _newWP;
_newWP
';

//slider for how many known contacts vs maximum refo groups that should be attacking
_refoarray = [[3,2],[8,3],[14,4],[20,6]];

//CSAR_ContactArray
_Defend = false;
_CountWP = count (waypoints _Group);
IF (_countWP <= 0) then {_Defend = true};
_Origpatrol = waypoints _group;
_AttackDistance = 1000;
_BreakOffDistance = _AttackDistance + 250;
_EngageRadius = 50;
_leader = leader _group;
_nearest = [];
_group setvariable ["CSAR_ENGAGED",false];
_Engageloop = false;
_Engagepos = [0,0,0];
_Engageunit = pow;
_i = 0;
While {true} do {

CSAR_EngagedGroups = [[player,getpos player],[q1,getpos q1]];
sleep 5;
IF (({alive _x} count (units _group)) <= 0) Exitwith {};

IF (!_Engageloop) then {
//FIRST - opfor group finds nearest contact (that is within attackdistance, and not in the air)
_NearContacts = ([CSAR_ContactArray,[],{_leader distance (_x select 0)},"ASCEND",{(((_x select 0) distance _leader) <= _AttackDistance) && ((getpos (_x select 0)) select 2) < 10 && (count CSAR_ContactArray >= 1)}] call BIS_fnc_sortBy);
IF ((Count _NearContacts) >= 1) then {
	_Nearest = _NearContacts select 0;
	_Engagepos = getpos (_Nearest select 0);
	_Engageunit = _Nearest select 0;
	//SECOND - how many SPOTTED units
	_ContactSize = _Nearest select 1;
	
	//THIRD - count how many OTHER groups are currently 'attacking' the general area (have a engaging WP within x meters (engageradius))
	_EngagedGroups = [CSAR_EngagedGroups,[],{[(_x select 1),_Nearest select 0] call BIS_fnc_distance2D},"ASCEND",{([(_x select 1),_Nearest select 0] call BIS_fnc_distance2D) < _EngageRadius}] call BIS_fnc_sortBy;
//	player sidechat str _EngagedGroups;
	
	//FOURTH - determine if current amount of reinforcing groups is enough to deal with the target threat value - if not then assist
	_refo = 1;
	{IF (_ContactSize >= (_x select 0)) then {_refo = (_x select 1)}} foreach _refoarray;
	
	IF (Count _EngagedGroups < _refo) then {
		
		//FIFTH - set waypoint to engage, add waypoint to csar_engagegroups as [group,waypointposition]
		_pos = [(getpos (_nearest select 0) select 0)+CSAR_ContactAreaSize-random(CSAR_ContactAreaSize*2),(getpos (_nearest select 0) select 0)+CSAR_ContactAreaSize - random(CSAR_ContactAreaSize*2),0];
		_EngageWP = [_group,_pos] call CSAR_fnc_InjectPatrolWP;
		_Engagewp setwaypointtype "SAD";
		_engagewp setWaypointCompletionRadius 15;
		_engagewp setWaypointStatements ["true", "(group this) setvariable [""CSAR_ENGAGED"",false];"];
		_group setvariable ["CSAR_ENGAGED",true];
		CSAR_EngagedGroups = CSAR_EngagedGroups + [_EngageWP];
		_Engageloop = true;
	
	};
};
};
	//SIXTH WHILE WP EXISTS WAIT IN ENGAGELOOP
IF (_Engageloop) then {
	//if dead - disengage
	IF (({alive _x} count (units _group)) <= 0) Exitwith {};
	
	//if group to engage moves too far away - disengage
	IF ((leader _Group) distance (_Nearest select 0) > _BreakOffDistance) then {_Engageloop = false;deletewaypoint _EngageWP;_group setvariable ["CSAR_ENGAGED",false]};

	//if they've reached WP - disengage (will probably just re-engageWP anyway)
	IF (!(_group getvariable "CSAR_ENGAGED") && _engageloop) then {_Engageloop = false;deletewaypoint _EngageWP;};

	//if unit they are attacking is over 250m from his original position - disengage
	IF (([_Engagepos,_EngageUnit] call bis_fnc_distance2D) >= 250 && _engageloop) then {_Engageloop = false;deletewaypoint _EngageWP;};
	
	//if over 5 minutes pass, disengage to catch anything i missed
	IF (_i > (60 * 5)) then {_i = 0;_Engageloop = false;deletewaypoint _EngageWP;};
	sleep 30;
	IF (_engageloop) then {_i = _i + 30;};
	};

};