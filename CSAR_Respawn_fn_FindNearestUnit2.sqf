private ["_player","_corpse","_westUnits","_close","_close2"];
_player = _this select 0;
_corpse = _this select 1;
_westUnits = _this select 2;
_respawnUnit = nil;
_close = [];
_close2 = [];
_playerGroup = group _player;
_close = [units (group _player),[],{(_corpse) distance _x},"ASCEND",{(!IsPlayer _x) && (Alive _x) && (!unitIsUAV (vehicle _x))}] call BIS_fnc_sortBy;
_close2 = [_westunits,[],{(_corpse) distance _x},"ASCEND",{(!IsPlayer _x) && (Alive _x) && (!unitIsUAV (vehicle _x))}] call BIS_fnc_sortBy;
_respawnUnit = (_close + _close2) select 0;
IF ((count (_close + _close2)) > 0) then {_respawnUnit} else {ObjNull}