_opfor = Independent;
_MaxKnowsAbout = 3.95;
_Triggersize = 150;
CSAR_Debug = true;
CSAR_ContactArray = [];
_triggerarray = [];
Sleep 1;
_markerarray = [];
while {true} do {
//current spotted west units
_Westunits = list Westunits;
_SpottedArray = [];
_LeaderArray = [];


//checks true if unit is within distance of any of the group units - [unit, group of units, distance] call _distcheck
_Distcheck = compile '
private ["_IsWithinDist"];
_IsWithinDist = false;
{IF (((_this select 0) distance (_x select 0)) < (_this select 2)) then {_IsWithinDist = true}} foreach (_this select 1);
_IsWithinDist
';

//return 2d average position of all objects - [unit1,unit2] call _averagepos
_AveragePos = compile '
private ["_totalx","_totaly"];
_totalx = 0;_totaly = 0;
{_totalx = _totalx + ((getpos _x) select 0);_totaly = _totaly + ((getpos _x) select 1)} foreach _this;
_totalx = _totalx / (count _this);
_totaly = _totaly / (count _this);
[_totalx,_totaly,0]
';

//STEP 1 find spotted units
_SpottedArray = [];
while {count _spottedarray <= 0} do {
{IF (((_opfor knowsabout _x) > _MaxKnowsAbout) OR CSAR_Debug) then {_SpottedArray = _SpottedArray + [_x]}} foreach _westunits;
sleep 0.1;
};
{deletevehicle (_x select 0)} foreach _triggerarray;_triggerarray = [];
IF ((count _markerarray) > 0) then {{deletemarker _x} foreach _markerarray;_markerrarray = []};
//{IF (true) then {_SpottedArray = _SpottedArray + [_x]}} foreach _westunits;

//obsolete for now
{IF (IsFormationleader _x) then {_LeaderArray = _LeaderArray + [_x]}} foreach _SpottedArray;
_leaderarray = _spottedarray;


//STEP 2 create the contact zone areas based off spotted units
_first = _leaderArray select 0;

_obj = "Logic" createvehiclelocal [(getpos _first) select 0,(getpos _first) select 1, 0];
_leaderArray = _leaderarray - [_first];
IF (CSAR_DEBUG) then {_marker = createMarkerlocal[format ["Detected (%1)",random 9999], getPos _first];_marker setMarkerSizeLocal [_Triggersize, _Triggersize];_marker setMarkerColorLocal "ColorRed";_marker setMarkerShapeLocal "ELLIPSE";_markerarray = _markerarray + [_marker]};
_triggerarray = _triggerarray + [[_obj,0]];

{IF (! ([_x,_TriggerArray,_Triggersize] call _Distcheck)) then {
	_obj = "Logic" createvehiclelocal [(getpos _x) select 0,(getpos _x) select 1, 0];
	IF (CSAR_DEBUG) then {_marker = createMarkerlocal[format ["Detected (%1)",random 9999], getPos _x];_marker setMarkerSizeLocal [_Triggersize, _Triggersize];_marker setMarkerColorLocal "ColorRed";_marker setMarkerShapeLocal "ELLIPSE";_markerarray = _markerarray + [_marker]};
	_triggerarray = _triggerarray + [[_obj,0]];
	}
} foreach _LeaderArray;


{
_tmp = _x select 0;
_num = {(_x distance _tmp) < _triggersize} count _spottedarray;
_x set [1,_num];
} foreach _triggerarray;
//player sidechat str (_triggerarray);


/* WIP but not necessary
//STEP 3 readjust areas to average position across troops they cover instead of centering on random unit (optional but necessary for step 4)
{
	_closeUnits = [_spottedarray,[_x select 0],{_input0 distance _obj},"ASCEND",{(_input0 distance _x) < _Triggersize}] call BIS_fnc_sortBy;
	_pos = _closeunits call _Averagepos;
	player sidechat str _pos;
	(_x select 0) setpos _pos;
	(_x select 1) setmarkerpos _pos;
} foreach _TriggerArray;
//STEP 4 if triggers collide - readjust and make trigger bigger for central contact zone
*/
CSAR_ContactArray = _triggerarray;
sleep 1;
};


//(will any more be necessary? test)