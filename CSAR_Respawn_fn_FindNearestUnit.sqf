_findNearestSoldier = compile '
    _corpse = _this select 0;
    _units = _this select 1;
    _respawnUnit = _corpse;
    _dist = 0;
    for [{_i=0},{_i<count _units},{_i=_i+1}] do {
        _newDist = [position _corpse, position (_units select _i)] call compile preprocessFile "distance2D.sqf";
        if (!isPlayer (_units select _i) && alive (_units select _i) && (_dist == 0 || _newDist < _dist)) then {
            _dist = _newDist;
            _respawnUnit = (_units select _i);
        };
    };
    _respawnUnit;
';

_getSpawnableUnits = compile '
    _group = _this select 0;
    _spawnableUnits = [];
    for [{_i=0},{_i<count units _group},{_i=_i+1}] do {
            if (!(isPlayer (units _group select _i)) && alive (units _group select _i)) then {
                _spawnableUnits = _spawnableUnits + [(units _group select _i)];
            }
        };
    _spawnableUnits;
';

private ["_player","_corpse","_westUnits"];
_player = _this select 0;
_corpse = _this select 1;
_westUnits = _this select 2;
_respawnUnit = nil;

_playerGroup = group _player;

if (count ([_playerGroup] call _getSpawnableUnits) > 0) then {
    _respawnUnit = [_corpse, units _playerGroup] call _findNearestSoldier;
} else {
    //Find a new group to spawn into
    _westPlayerGroups = [];
    {
        if (isPlayer _x && ((count ([group _x] call _getSpawnableUnits)) > 0) && !((group _x) in _westPlayerGroups)) then {
            _westPlayerGroups = _westPlayerGroups + [group _x];
        };
    } forEach _westUnits;
    if (count _westPlayerGroups > 0) then {
        _westPlayerGroupUnits = [];
        for [{_z=0},{_z<count _westPlayerGroups},{_z=_z+1}] do {
            {_westPlayerGroupUnits = _westPlayerGroupUnits + [_x]} forEach units (_westPlayerGroups select _z);
            _respawnUnit = [_corpse,_westPlayerGroupUnits] call _findNearestSoldier;
        };
    } else {
        //No spawnable player groups. Find nearest soldier period.
        _westSpawnableUnits = [];
        for [{_y=0},{_y<count _westUnits},{_y=_y+1}] do {
            if (!(isPlayer (_westUnits select _y)) && ((_westUnits select _y) != POW) && vehicle (_westUnits select _y) isKindOf "man") then {
                _westSpawnableUnits = _westSpawnableUnits + [(_westUnits select _y)];
            };
            _respawnUnit = [_corpse,_westSpawnableUnits] call _findNearestSoldier;
        };
    };
};
_respawnUnit;