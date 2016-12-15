params [["_unit",[]], ["_useGroupReduction",false,[true,false]], ["_usePatrol",false,[true,false]], ["_useDumbAI",false,[true,false]]];

//_useGroupReduction = true;
//_usePatrol = false;
//_SkillArray = [["aimingAccuracy",0.4],["aimingShake",0.1],["aimingSpeed",0.2],["spotDistance",0.8],["spotTime",0.1],["courage",0.3],["reloadSpeed",0.6],["commanding",0.8],["general",1]];
_SkillArray = [["aimingAccuracy",0.3],["aimingShake",0.1],["aimingSpeed",0.7],["spotDistance",0.8],["spotTime",0.3],["courage",0.3],["reloadSpeed",0.2],["commanding",0.8],["general",.8]];
_unit = _this;
if (typename _this == "ARRAY") then {_unit = _this select 0};

if (!(_unit getVariable ["CSAR_unitInitialized",false]) && Local _unit) then {
	if (!(_unit isKindOf "man")) then {
		csar_zeus addCuratorEditableObjects [[_unit],true];
		(vehicle _unit) addEventHandler ["Fired",{[_this] call RecoilFunction}];
		{_x call opfor_fnc_initUnit2} forEach crew (vehicle _unit);
	} else {
		_unit setskill 0.7;
		csar_zeus addCuratorEditableObjects [[_unit],true];
		{_unit setskill [_x select 0,_x select 1]} foreach _SkillArray; 
		_unit setVariable["CSAR_unitInitialized",true];
		_unit addEventHandler ["Fired",{[_this] call RecoilFunction}];
		_unit addEventHandler ["Killed",{_unit execvm "deleteUnit.sqf"}];
		_unit execVM "tracermags.sqf";
		_unit execvm "AddIntelAction.sqf";
		IF (_useDumbAI) then {_unit disableAI "FSM"};
		if (_unit == leader group _unit) then {
	        IF (true) then {[group _x] execVM "waypointMarkers.sqf"};
	        if (_useGroupReduction) then {[group _unit,1,600] execVM "GroupReduction.sqf"};
	        if (_usePatrol) then {(group _unit) execVM "Patrol.sqf"};
	    	(group _unit) allowFleeing 0.3;
	    };
	};
};
