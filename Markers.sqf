
     //** DYNAMIC _localMarkerList **

     _player = _this select 0;
     if (player != _player) exitWith{};

     _localMarkerList = [];
     _westPlayerGroupUnits = [];

    while {true} do {
    	sleep 1;
    	_markerID = 1;
    	_westPlayerGroupUnits = [];
	    {
	         if (isPlayer (leader group _x) && !(_x in _westPlayerGroupUnits)) then {
	             _westPlayerGroupUnits = _westPlayerGroupUnits + [_x];
	         };
 		} forEach list EveryUnit;

 		if (count _westPlayerGroupUnits > count _localMarkerList) then {
 			_amount = ((count _westPlayerGroupUnits) - (count _localMarkerList));
 			for [{_y=0},{_y<_amount},{_y=_y+1}] do {
 				call compile format ["_marker = createMarkerLocal[""localMarker%1"",[0,0,0]];_localMarkerList = _localMarkerList + [_marker]",(_markerID + random 10000)];
 				_markerID = _markerID + 1;
 			};
 		};

 		if (count _localMarkerList > 0) then {
	   	    _count = 0;
		   {
	        	_marker = _x;
	        	if (_count < count _westPlayerGroupUnits) then {
	        		_unit = _westPlayerGroupUnits select _count;
		            _marker setMarkerPosLocal [(getPos _unit select 0), (getPos _unit select 1),0];
		            if (isPlayer _unit) then {
		            	_marker setMarkerTextLocal name _unit;
		            	_marker setMarkerTypeLocal "flag_Canada";
		            	_marker setMarkerColorLocal "Default"
		            }
		      		else {
		      			_marker setMarkerTextLocal "";
		            	_marker setMarkerTypeLocal "hd_dot";
		            	 if (group _unit == group player) then {_marker setMarkerColorLocal "colorBlue"}
		            	 else {_marker setMarkerColorLocal "colorGrey"};
		            };

		            // *REVIVE IMPLEMENTATION*
		            if (isPlayer _unit) then {
		                if (vehicle _unit isKindOf "man") then {
		                    _isUnconscious = lifestate _unit;
		                    if (_isUnconscious == "INCAPACITATED") then {
		                    	_marker setMarkerTypeLocal "KIA";
		                	};
		                };
		            };
		            if (!alive _unit) then {
		            	_marker setMarkerPosLocal [0,0,0];
		            };
	        	} else {
	        		_marker setMarkerPosLocal[0,0,0];
	        	};
	    		_count = _count + 1;
		    } Foreach _localMarkerList;

		    if (_count < count _westPlayerGroupUnits) then {
		    	while {_count < count _westPlayerGroupUnits} do {
		    		_marker = _localMarkerList select _count;
		    		_marker setMarkerPosLocal[0,0,0];
		    		_count = _count + 1;
		    	};
		    };
		};
    };

    //**END DYNAMIC _localMarkerList**