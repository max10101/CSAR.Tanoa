_heli = _this select 0;
_emergency =  _this select 1;
_group = [];

if (local _heli) then {
    {if (_x in _heli && _x != driver _heli && (group _x) != (group driver _heli)) then {_group = _group + [_x]}} forEach crew _heli;
    _x = 0;
    _dir = getDir _heli + 90;
    _offset = 2;
    waitUntil {speed _heli < 35 || !alive _heli || _emergency || !IsEngineOn _heli};

    /*while {_x < count _group} do {
        if (((velocity _heli select 2) > -10) || _emergency) then {
            if (!isEngineOn _heli && !_emergency) then {_x = count _group} else
            {
			
				(_group select _x) disableCollisionWith _heli;
                removeBackpack (_group select _x);
                (_group select _x) addBackpack "B_Parachute";
                unassignVehicle (_group select _x);
                moveout (_group select _x);
                _offset = _offset * -1;
                (_group select _x) setPos [(getPos (_group select _x) select 0) + sin(_dir)*_offset, (getPos (_group select _x) select 1) + cos(_dir)*_offset,(getPos (_group select _x) select 2) - 1];
                (_group select _x) setVelocity [(velocity _heli select 0)+(sin _dir*_offset),(velocity _heli select 1)+(cos _dir*_offset),(velocity _heli select 2)-2];
                //[_group select _x] execVM "deployChute.sqf";
                _x = _x + 1;
            }
        };*/
		0 = [_heli,70] execVM "eject2.sqf";
    sleep 0.6;

}
