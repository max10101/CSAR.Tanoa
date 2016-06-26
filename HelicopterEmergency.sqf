//If heli is attacked while en route, checks to see if its engine is off. If it is, all crew abandon ship!
_heli = (_this select 0);
if (!(isEngineOn _heli) && ((getpos _heli select 2) > 10)) then {
	_playerHeli = false;
	{if (isPlayer _x) exitWith {_playerHeli = true;}} forEach (crew _heli);
    if (!_playerHeli) then {[_heli,true] execVM "Eject.sqf";};
    _heli removeAllEventHandlers "dammaged";
    if (side (driver _heli) == west) then {
	    RadioOperator = driver _heli;
	    RadioChat = "MAYDAY MAYDAY MAYDAY WE ARE GOING DOWN, ENGINE IS OUT, REPEAT, GOING DOWN!";
	    publicVariable "RadioOperator";
	    publicVariable "RadioChat";
	};
};