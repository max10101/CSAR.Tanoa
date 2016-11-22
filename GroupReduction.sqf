//Reduces group size to sepcified value until enemy unit is within specified dist. Best used for infantry only groups
if (Local CSAR_HC1) then {
    _group1 = _this select 0;
    _min = _this select 1;
    _dist = _this select 2;
    _vehicle = nil;
    if (!((vehicle leader _group1) isKindOf "Man")) then {_vehicle = (vehicle leader _group1)};

    _group1CountSize = count units _group1;
    _holdArray = [];
    _fulLSize = true;

    while {count units _group1 > 0} do {
        sleep 10 + (random 5);
        _c = 0;
        _enemySpotted = 0;
        _group1Units = [];
        {if (alive _x) then {_group1Units = _group1Units + [_x]}} forEach units _group1;
        while {_c < count _group1Units} do {
            {if (((vehicle (_group1Units select _c)) distance2d _x < _dist) && (speed _x < 120) && ((getpos _x select 2) < 50)) then {_enemySpotted = _enemySpotted + 1}} forEach list WestUnits;
            _c = _c + 1;
        };

        //This checks to see if any soldiers get added (from reinforcements). If so, we make it re-delete units if possible.
        if (count units _group1 > _group1CountSize && !_fullSize) then {_fullSize = true};

        if ((_enemySpotted > 0) && !_fullSize) then {
            //Means an enemy is spotted and we have not spawned the units back into action
            if (!((vehicle leader _group1) isKindOf "Man")) then {_vehicle = (vehicle leader _group1)};
            //player sideChat format["Re spawning infantry into: %1 - Array: %2",typeOf _vehicle,_holdArray];
            {
                unit = _group1 createUnit [_x, [(getPos leader _group1 select 0), getPos leader _group1 select 1, 0], [], 20, "FORM"];
                DeSpawnedInf = DeSpawnedInf - 1;
                waitUntil {alive unit};
                unit call opfor_fnc_initUnit;
                if (!isNil "_vehicle") then {
                    if (alive _vehicle && leader _group1 in _vehicle) then {
                        unit assignAsCargo _vehicle;
                        unit moveInCargo _vehicle;
                    }
                }
            } forEach _holdArray;

            _holdArray = [];
            _fullSize = true;
        };

        if (_enemySpotted == 0 && _fullSize) then {
            //Means no enemy spotted and we're still at full size, so time to reduce. This will happen on the first call.
            _deletedUnits = 0;
            _deletedUnitsArray = [];
            {
                if ((count units _group1 - _deletedUnits) >= _min) then {
                    _deleteUnit = true;
                    if (_x == leader _group1) then {_deleteUnit = false};
                    if (!((vehicle _x) isKindOf "MAN")) then {
                        //Making sure they're not in a vehicle
                        _deleteUnit = false;
                        if (_x in [gunner (vehicle _x), driver (vehicle _x), commander (vehicle _x)]) then {_deleteUnit = false};
                    };
                    if (_deleteUnit) then {
                        //If it's ok to delete, we do!
                        _deletedUnitsArray = _deletedUnitsArray + [_x];
                    };
                    _deletedUnits = _deletedUnits + 1;
                }
            } foreach units _group1;
            {
                _holdArray = _holdArray + [typeOf _x];
		        IF (group _x == group player) then {player sidechat format ["THIS %1",_holdarray]};
				[_x] JOIN grpnull;
		        unassignvehicle _x;
                _x action ["EJECT",vehicle _x];
                _x setPos [0,0,10];
                waitUntil {(vehicle _x) isKindOf "Man"};
                deleteVehicle _x;
                DeSpawnedInf = DeSpawnedInf + 1;
		sleep 5;
            } forEach _deletedUnitsArray;

            _group1CountSize = count units _group1;
            _fullSize = false;
        }
    }
}
