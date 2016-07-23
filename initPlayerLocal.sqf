 _unit = _this select 0;
 _isJIP = _this select 1;
 if (_isJIP) then {
	sleep 1;
	waitUntil {alive _unit};
	{if (name _x == name _unit) then {
			selectPlayer _x;
			waitUntil {player == _x && isPlayer _x && local _x};
			deleteVehicle _unit;
		}
	} foreach list WestUnits;
};

// [_x] remoteExec ["selectPlayer", _unit];