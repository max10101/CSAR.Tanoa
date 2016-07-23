_useGroupReduction = true;
_usePatrol = false;

_unit = _this;
if (typename _this == "ARRAY") then {_unit = _this select 0;_useGroupReduction = _this select 1;_usePatrol = _this select 2;};

if (!(_unit getVariable ["CSAR_unitInitialized",false])) then {
	if (!(_unit isKindOf "man")) then {
		(vehicle _unit) addEventHandler ["Fired",{[_this] call RecoilFunction}];
		{_x call opfor_fnc_initUnit2} forEach crew (vehicle _unit);
	} else {
		_unit setVariable["CSAR_unitInitialized",true];
		_unit addEventHandler ["Fired",{[_this] call RecoilFunction}];
		_unit setSkill ["aimingAccuracy",(random 5)/10];
		_unit addEventHandler ["Killed",{_unit execvm "deleteUnit.sqf"}];
		_unit execVM "tracermags.sqf";
		if (_unit == leader group _unit) then {
	        //[group _x] execVM "waypointMarkers.sqf";
	        if (_useGroupReduction) then {[group _unit,2,1000] execVM "GroupReduction.sqf"};
	        if (_usePatrol) then {(group _unit) execVM "Patrol.sqf"};
	    	(group _unit) allowFleeing 0.2;
	    };
	};
};