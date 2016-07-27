params [["_unit",[]], ["_useGroupReduction",true,[true,false]], ["_usePatrol",false,[true,false]]];

//_useGroupReduction = true;
//_usePatrol = false;
_SkillArray = [["aimingAccuracy",0.4],["aimingShake",0.1],["aimingSpeed",0.2],["spotDistance",0.8],["spotTime",0.1],["courage",0.3],["reloadSpeed",0.6],["commanding",0.8],["general",1]];
_unit = _this;
if (typename _this == "ARRAY") then {_unit = _this select 0};

if (!(_unit getVariable ["CSAR_unitInitialized",false])) then {
	if (!(_unit isKindOf "man")) then {
	//this doesn't seem to get called..ever
		(vehicle _unit) addEventHandler ["Fired",{[_this] call RecoilFunction}];
		systemchat "Opfor initunit - called not on a man";
		{_x call opfor_fnc_initUnit2} forEach crew (vehicle _unit);
	} else {
		_unit setskill 0.7;
		{_unit setskill [_x select 0,_x select 1]} foreach _SkillArray; 
		_unit setVariable["CSAR_unitInitialized",true];
		_unit addEventHandler ["Fired",{[_this] call RecoilFunction}];
		_unit addEventHandler ["Killed",{_unit execvm "deleteUnit.sqf"}];
		_unit execVM "tracermags.sqf";
		_unit execvm "AddIntelAction.sqf";
		if (_unit == leader group _unit) then {
	        IF (true) then {[group _x] execVM "waypointMarkers.sqf"};
	        if (_useGroupReduction) then {[group _unit,2,1000] execVM "GroupReduction.sqf"};
	        if (_usePatrol) then {(group _unit) execVM "Patrol.sqf"};
	    	(group _unit) allowFleeing 0.3;
	    };
	};
};