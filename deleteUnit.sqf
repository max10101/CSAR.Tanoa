IF (!Local (_this select 0)) ExitWith {};
_exists = true;
_timer = time + (60*20);
if ((_this select 0) isKindOf "Man") then {
    while {_exists} do {
        sleep 10;
        if (time > _timer) then {
            deleteVehicle (_this select 0);
            _exists = false;
        }
    }
}