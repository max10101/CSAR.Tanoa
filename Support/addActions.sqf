_object = _this select 0;
_basePos = getMarkerPos "spawn_airbase";

sleep 1;
if (!local _object) exitWith {};
waitUntil {(vehicle _object) isKindOf "MAN"};


/********************
		Arty
*********************/
_str = format["<t color='#FF9000'>Open Artillery Field System</t>"];
_ARTMaxDist = 750;
PlayerARTActionID = _object addAction [_str, "Support\artMenu.sqf", [_ARTMaxDist], -1, false, true, "","player == _target && (vehicle _target) isKindOf ""MAN"""];



/********************
		CAS
*********************/
_casNum = CASMissions - CASUsed;
_CASMaxDist = 750;
if (_casNum > 0) then {
	_str = format["<t color='#FF9000'>Open CAS Field System (%1)</t>",_casNum];
	PlayerCASActionID = _object addAction [_str, "Support\casMenu.sqf", [_CASMaxDist, _casNum, _basePos], -1, false, true, "","player == _target && (vehicle _target) isKindOf ""MAN"""];
};



/********************
		Support
*********************/
_str = format["<t color='#FF9000'>Open Support Field System</t>",_num];
_SPTMaxDist = 1000;
PlayerSPTActionID = _object addAction [_str, "Support\sptMenu.sqf", [_SPTMaxDist, _basePos], -1, false, true, "","player == _target && (vehicle _target) isKindOf ""MAN"""];