_group = _this select 0;
_markers = [];
_findAngle = compile preprocessFile "FindAngle.sqf";
//if (!DEBUG_WAYPOINTMARKERS) exitWith {};
while {true} do {
sleep 1;
    {deleteMarker _x; _markers = _markers - [_x]} forEach _markers;
    if (count waypoints _group > 1) then {

        _marker = createMarkerLocal[format ["Waypoint %1",random 9999], getPos leader _group];
        _marker setMarkerType 'o_inf';
        _marker setMarkerSize[1, 1];
        _marker setMarkerColor 'ColorRed';
        _markers = _markers + [_marker];
        {
            _marker = createMarkerLocal[format ["Waypoint %1",random 9999], waypointPosition _x];
            _marker setMarkerType 'hd_end';
            _marker setMarkerSize[1, 1];
            _marker setMarkerColor 'ColorBlack';
            _marker setMarkerText format ["%1 - %2",waypointType _x,waypointName _x];
            _markers = _markers + [_marker];
        } forEach (waypoints _group - [waypoints _group select 0]);

        for [{_i=count waypoints _group -1},{_i>0},{_i=_i-1}] do {
            _wp1 = waypoints _group select _i;
            _wp2 = waypoints _group select (_i-1);
            _dist = waypointPosition _wp1 distance waypointPosition _wp2;
            _angle = [waypointPosition _wp2,waypointPosition _wp1] call _findAngle;
            if (_i == 1) then {
                _dist = (getPos leader _group) distance waypointPosition _wp1;
                _angle = [getPos leader _group, waypointPosition _wp1] call _findAngle;
            };
            _pos = [(waypointPosition _wp1 select 0) + (sin(_angle)*_dist/2),(waypointPosition _wp1 select 1) + (cos(_angle)*_dist/2)];
            _marker = createMarkerLocal[format ["Waypoint %1",random 9999], _pos];
            _marker setMarkerShape 'rectangle';
            _marker setMarkerSize[1.5, _dist*0.5];
            _marker setMarkerColor 'ColorBlack';
            _marker setMarkerBrush "Solid";
            _marker setMarkerDir _angle;
            _markers = _markers + [_marker];
        };
    }
}