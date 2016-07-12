//Counts out all enemies
_infantry = 0;
_infantryInVeh = 0;
_vehicles = 0;
_air = 0;
_groups = 0;

_infantry = ("Man" countType list EastUnits);
_vehicles = ("Car" countType list EastUnits) + ("Tank" countType list EastUnits);
_air = ("Helicopter" countType list EastUnits) + ("Plane" countType list EastUnits);


{if (_x isKindOf "LandVehicle" || _x isKindOf "Helicopter") then {
    _infantryInVeh = _infantryInVeh + (count crew _x);
}} forEach list EastUnits;

{if (_x == leader group _x) then {_groups = _groups + 1}} forEach list EastUnits;

hint format ["Infantry: %1\nVehicle crew: %2\nDe-Spawned Infantry: %3\nLand Vehicles: %4\nAircraft: %5\nGroups: %6",_infantry,_infantryInVeh,DeSpawnedInf,_vehicles,_air,_groups];