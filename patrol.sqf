//make a list of all opfor groups
//while {true} do {

sleep 5;
_OpforGroups = [];
_OpforUnits = List Eastunits;
{
	IF ((_x == leader (group _x)) && ((group _x) getvariable ["Patrol", 0]) > 0) then {
	_OpforGroups = _OpforGroups + [group _x]
	};
} foreach _OpforUnits;

player sidechat str (count _opforgroups);
{[_x] execvm "waypointmarkers.sqf"} foreach _opforgroups;

_Spotted = CSAR_ContactArray;


//};