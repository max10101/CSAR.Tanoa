_useGroupReduction = true;
_unit = _this;
if (typename _this == "ARRAY") then {_unit = _this select 0;_useGroupReduction = _this select 1};

if ((_unit getVariable ["CSAR_unitInitialized",false])) then {
		_unit setVariable["CSAR_unitInitialized",true];
		_unit addEventHandler ["Fired",{[_this] call RecoilFunction}];
		_unit setSkill ["aimingAccuracy",(random 5)/10];
		_unit addEventHandler ["Killed",{_unit execvm "deleteUnit.sqf"}];
		_unit execVM "tracermags.sqf";
		if (_unit == leader group _unit) then {
	        //[group _x] execVM "waypointMarkers.sqf";
	        //if (_useGroupReduction) then {[group _unit,1,1000] execVM "GroupReduction.sqf"};
	        //[group _unit] execVM "Patrol.sqf";
	    	(group _unit) allowFleeing 0.2;
	    };
	};