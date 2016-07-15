sleep 5;
_group = _this;

_L1contact = 3;
_L1refo = 1;
_L2contact = 8;
_L2refo = 2;
_L3contact = 14;
_L3refo = 4;
_L4contact = 20;
_L4refo = 6;
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
CSAR_EngagedGroups = [[player,getpos player],[q1,getpos q1]];
While {true} do {
CSAR_EngagedGroups = [[player,getpos player],[q1,getpos q1]];
sleep 1;
//FIRST - opfor group finds nearest contact (that is within attackdistance, and not in the air)
_NearContacts = ([CSAR_ContactArray,[],{_leader distance (_x select 0)},"ASCEND",{(((_x select 0) distance _leader) <= _AttackDistance) && ((getpos (_x select 0)) select 2) < 10 && (count CSAR_ContactArray >= 1)}] call BIS_fnc_sortBy);
IF (Count _NearContacts >= 1) then {
	_Nearest = _NearContacts select 0;

	//SECOND - AI determines how big that group is (how many SPOTTED units)
	_ContactSize = _Nearest select 1;
	
	//THIRD - count how many OTHER groups are currently 'attacking' the general area (have a engaging WP within x meters (engageradius))
	_EngagedGroups = [CSAR_EngagedGroups,[],{[(_x select 1),_Nearest select 0] call BIS_fnc_distance2D},"ASCEND",{([(_x select 1),_Nearest select 0] call BIS_fnc_distance2D) < _EngageRadius}] call BIS_fnc_sortBy;
	player sidechat str _EngagedGroups;
	
	//FOURTH - determine if current amount of reinforcing groups is enough to deal with the target threat value - if not proceed
	
	IF (Count _EngagedGroups >= 1) then {
		
		
		
		
		
	};
};


};