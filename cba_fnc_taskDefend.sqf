/* ----------------------------------------------------------------------------
Function: CBA_fnc_taskDefend

Description:
    A function for a group to defend a parsed location.

    Groups will mount nearby static machine guns and bunker in nearby buildings.
    They may also patrol the radius unless otherwise specified.

Parameters:
    - Group (Group or Object)

Optional:
    - Position (XYZ, Object, Location or Group)
    - Defend Radius (Scalar)
    - Building Size Threshold (Integer, default 2)
    - Can patrol (boolean)

Example:
    (begin example)
    [this] call CBA_fnc_taskDefend
    (end)

Returns:
    Nil

Author:
    Rommel, SilentSpike

---------------------------------------------------------------------------- */

params ["_group", ["_position",[]], ["_radius",50,[0]], ["_threshold",2,[0]], ["_patrol",true,[true]]];

_group = _group call CBA_fnc_getGroup;
if !(local _group) exitWith {}; // Don't create waypoints on each machine

_position = [_position,_group] select (_position isEqualTo []);
_position = _position call CBA_fnc_getPos;

[_group] call CBA_fnc_clearWaypoints;

private _statics = _position nearObjects ["StaticWeapon", _radius];
private _buildings = _position nearObjects ["Building", _radius];

// Filter out occupied statics
_statics = _statics select {(_x emptyPositions "Gunner") > 0};

// Filter out buildings below the size threshold (and store positions for later use)
_buildings = _buildings select {
    private _positions = _x buildingPos -1;

    if (isNil {_x getVariable "CBA_taskDefend_positions"}) then {
        _x setVariable ["CBA_taskDefend_positions", _positions];
    };

    count (_positions) > _threshold
};

// If patrolling is enabled then the leader must be free to lead it
private _units = units _group;
if (_patrol && {count _units > 1}) then {
    _units deleteAt (_units find (leader _group));
};

{
    // 61% chance to occupy nearest free static weapon
    if ((random 1 < 0.61) && { !(_statics isEqualto []) }) then {
        _x assignAsGunner (_statics deleteAt 0);
        [_x] orderGetIn true;
    } else {
        // 55% chance to occupy a random nearby building position
        if ((random 1 < 0.55) && { !(_buildings isEqualto []) }) then {
            private _building = _buildings call BIS_fnc_selectRandom;
            private _array = _building getVariable ["CBA_taskDefend_positions",[]];

            if !(_array isEqualTo []) then {
                private _pos = _array deleteAt (floor(random(count _array)));

                // If building positions are all taken remove from possible buildings
                if (_array isEqualTo []) then {
                    _buildings deleteAt (_buildings find _building);
                    _building setVariable ["CBA_taskDefend_positions",nil];
                } else {
                    _building setVariable ["CBA_taskDefend_positions",_array];
                };

                // Wait until AI is in position then force them to stay
                [_x, _pos] spawn {
                    params ["_unit","_pos"];
                    if (surfaceIsWater _pos) exitwith {};

                    _unit doMove _pos;
                    sleep 5;
                    waituntil {unitReady _unit};
                    _unit disableAI "PATH";
                    _unit setUnitPos "UP";
                };
            };
        };
    };
} forEach _units;

// Remaining units will patrol if enabled
if (_patrol) then {
    [_group, _position, _radius, 5, "MOVE", "safe", "red", "limited"] call CBA_fnc_taskPatrol;
};
