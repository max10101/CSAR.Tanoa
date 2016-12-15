_opfor = Independent;
CSAR_MaxKnowsAbout = 3.25;
_triggerarray = [];
Sleep 2;
_markerarray = [];

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

while {true} do {
	//current spotted west units
	_Westunits = list WestContacts;
	_SpottedArray = [];
	
	//STEP 1 find spotted units
	{IF (((_opfor knowsabout _x) > CSAR_MaxKnowsAbout)) then {_SpottedArray = _SpottedArray + [_x]}} foreach _westunits;
	IF (count _spottedarray > 0) then {
		sleep 0.1;
		_triggerarray = [];
		IF ((count _markerarray) > 0) then {{deletemarker _x} foreach _markerarray;_markerrarray = []};

		//STEP 2 create the contact zone areas based off spotted units
		_first = _spottedarray select 0;
		_obj = _first;
		_spottedarray = _spottedarray - [_first];
		_triggerarray = _triggerarray + [[_obj,0]];
		{
			IF (! ([_x,_TriggerArray,CSAR_ContactAreaSize] call _Distcheck)) then {
				_obj = _x;
				_triggerarray = _triggerarray + [[_obj,0]];
			}
		} foreach _spottedarray;
		{
			_tmp = _x select 0;
			_num = {(_x distance _tmp) < CSAR_ContactAreaSize} count _spottedarray;
			_closeUnits = [_spottedarray,[_x select 0],{_input0 distance _obj},"ASCEND",{(_input0 distance _x) < CSAR_ContactAreaSize}] call BIS_fnc_sortBy;
			_x set [1,_num];
			_x set [2,_closeUnits];
			
			//no long local only (see last setmarker)
			IF (CSAR_DEBUG) then {_marker = createMarkerlocal[format ["Detected (%1)",random 9999], getPos _tmp];_marker setMarkerSizeLocal [CSAR_ContactAreaSize, CSAR_ContactAreaSize];_marker setMarkerColorLocal "ColorRed";_marker setMarkerShape "ELLIPSE";_markerarray = _markerarray + [_marker]};
			IF (CSAR_DEBUG) then {_marker = createMarkerlocal[format ["Detected (%1)",random 9999], getPos _tmp];_marker setMarkerSizeLocal [1, 1];_marker setMarkerColorLocal "ColorRed";_marker setMarkerShapeLocal "ICON";_marker setmarkertypelocal "hd_dot";_marker setmarkertext (str _num);_markerarray = _markerarray + [_marker]};
		} foreach _triggerarray;
	};
	CSAR_ContactArray = _triggerarray;
	sleep 2;
	
};