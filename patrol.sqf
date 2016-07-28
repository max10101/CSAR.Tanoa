sleep (random 10);
_group = _this;
IF (!Local (leader _group)) ExitWith {};
CSAR_fnc_InjectPatrolWP = compile '
private ["_current","_newWP","_newpos","_group"];
_group = _this select 0;
_newpos = _this select 1;
_current = currentWaypoint _group;
_group setvariable ["CSAR_OldWP",_current];
[_group,_current] setWaypointStatements ["true",""];
_newWP = _group addWaypoint [_newPos, 0];
call compile format ["_newWP setWaypointStatements [""true"", ""group this setcurrentwaypoint [group this,%1];(group this) setvariable [%2,false];""]",_current,str """CSAR_ENGAGED"""];
_group setcurrentwaypoint _newWP;
_newWP
';

//for ninja group escapes
CSAR_Smokebomb = compile '
private ["_group","_target","_smokeshells","_smoke","_dir"];
_group = _this select 0;
_target = _this select 1;
_smokeshells = ["G_40mm_SmokeRed","G_40mm_Smoke","G_40mm_SmokeOrange","G_40mm_SmokeBlue","G_40mm_SmokePurple"];
{if (random 2 > 0.7) then {
_smoke = (selectRandom _smokeshells) createVehicle [(getPos _x select 0),(getPos _x select 1),3];
_dir = [leader _group,_target] call bis_fnc_DirTo;
_smoke setVelocity [sin (_dir)*(8+random 6),cos (_dir)*(8+random 6),8+(random 5)];
}} forEach units _Group;
';

//slider for how many known contacts vs maximum refo groups that should be attacking
_refoarray = [[3,2],[8,3],[12,4],[20,6]];

//CSAR_ContactArray
_Defend = false;
_CountWP = count (waypoints _Group);
IF (_countWP <= 0) then {_Defend = true};
_Origpatrol = waypoints _group;
_AttackDistance = 1000;
_BreakOffDistance = 250;
_EngageRadius = CSAR_ContactAreaSize / 2;
_leader = leader _group;
_nearest = [];
_group setvariable ["CSAR_ENGAGED",false];
_Engageloop = false;
_Engagepos = [0,0,0];
_Engageunit = pow;
_Engagelist = [];
_WPIndex = 0;
CSAR_EngagedGroups = [];
_i = 0;
While {true} do {
sleep 5;
IF (({alive _x} count (units _group)) <= 0) Exitwith {};

IF (!_Engageloop) then {
_i = 0;
	//FIRST - opfor group finds nearest contact (that is within attackdistance, and not in the air)
	_NearContacts = ([CSAR_ContactArray,[],{_leader distance (_x select 0)},"ASCEND",{(((_x select 0) distance _leader) <= _AttackDistance) && ((getpos (_x select 0)) select 2) < 10 && (count CSAR_ContactArray >= 1)}] call BIS_fnc_sortBy);

	IF ((Count _NearContacts) >= 1) then {
		_Nearest = _NearContacts select 0;
		_Engagepos = (_Nearest select 0) call BIS_fnc_position;
		_Engageunit = _Nearest select 0;
		//SECOND - how many SPOTTED units
		_ContactSize = _Nearest select 1;
	
		//THIRD - count how many OTHER groups are currently 'attacking' the general area (have a engaging WP within x meters (engageradius))
		_EngagedGroups = [CSAR_EngagedGroups,[],{[(_x select 1),_Nearest select 0] call BIS_fnc_distance2D},"ASCEND",{([(_x select 1),_Nearest select 0] call BIS_fnc_distance2D) < (_EngageRadius * 2.5)}] call BIS_fnc_sortBy;
		//systemchat ("Currently engaging: " + str (count _EngagedGroups));
		
		//FOURTH - determine if current amount of reinforcing groups is enough to deal with the target threat value - if not then assist
		_refo = 1;
		{IF (_ContactSize >= (_x select 0)) then {_refo = (_x select 1)}} foreach _refoarray;
	
		IF (Count _EngagedGroups < _refo) then {
			//FIFTH - set waypoint to engage, add waypoint to csar_engagegroups as [group,waypointposition]

			_pos = [(getpos (_nearest select 0) select 0)+_EngageRadius-random(_EngageRadius*2),(getpos (_nearest select 0) select 1)+_EngageRadius - random(_EngageRadius*2),0];
			_EngageWP = [_group,_pos] call CSAR_fnc_InjectPatrolWP;
			//_Engagewp setwaypointtype "SAD";
			_engagewp setWaypointCompletionRadius 15;
			_group setvariable ["CSAR_ENGAGED",true];
			CSAR_EngagedGroups = CSAR_EngagedGroups + [[_group,_pos]];
			_Engageloop = true;
			_EngageList = _Nearest select 2;
			//systemchat ("Creating Engage WP - " + str _EngageWP + " attacking" + str _pos);
			sleep 0.01;
			_WPIndex = currentwaypoint _group;
		};
	};
};
	//SIXTH WHILE WP EXISTS WAIT IN ENGAGELOOP
IF (_Engageloop) then {
	//if dead, exit script
	IF (({alive _x} count (units _group)) <= 0) Exitwith {};
	
	//if anyone in group is fleeing, the whole group will disengage/move back to original patrol after smokebomb and given a 2 min timeout
	IF (({fleeing _x} count (units _group)) > 0) then {deletewaypoint [_group,_WPIndex];_group setcurrentwaypoint [_group,(_group getvariable "CSAR_OldWP")];_Engageloop = false;[_group,_EngageUnit] call CSAR_Smokebomb;sleep 120};
	
	//if the unit they are targetting/engaging is dead, next target is the next closest unit that was in that original group to attack
	IF (!Alive _Engageunit) then {
	_Engagelist = ([_Engagelist,[],{_x distance (leader _group)},"ASCEND",{Alive _x}] call BIS_fnc_sortBy);
	IF (count _Engagelist > 0) then {_Engageunit = _Engagelist select 0} else {deletewaypoint [_group,_WPIndex];_group setcurrentwaypoint [_group,(_group getvariable "CSAR_OldWP")];_Engageloop = false;};
	};
	
	//if group to engage moves too far away - disengage
	IF ((leader _Group) distance _Engageunit > (_BreakOffDistance + _AttackDistance) && _engageloop) then {deletewaypoint [_group,_WPIndex];_group setcurrentwaypoint [_group,(_group getvariable "CSAR_OldWP")];_Engageloop = false;_group setvariable ["CSAR_ENGAGED",false]};

	//if they've reached WP - disengage (will probably just re-engageWP anyway)
	IF (!(_group getvariable "CSAR_ENGAGED") && _engageloop) then {deletewaypoint [_group,_WPIndex];_group setcurrentwaypoint [_group,(_group getvariable "CSAR_OldWP")];_Engageloop = false;};

	//if unit they are attacking is over 250m from his original position - disengage
	IF (([waypointposition [_group,_WPIndex],_EngageUnit] call bis_fnc_distance2D) >= _BreakOffDistance && _engageloop) then {deletewaypoint [_group,_WPIndex];_group setcurrentwaypoint [_group,(_group getvariable "CSAR_OldWP")];_Engageloop = false};
	
	//if over x minutes pass, disengage to catch anything i missed
	IF (_i > (60 * 6)) then {deletewaypoint [_group,_WPIndex];_group setcurrentwaypoint [_group,(_group getvariable "CSAR_OldWP")];_i = 0;_Engageloop = false} else {_i = _i + 10};

	IF (_EngageLoop) then {sleep 20} else {sleep 5};
};
};
