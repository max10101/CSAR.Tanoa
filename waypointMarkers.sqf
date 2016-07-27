sleep (random 5);
_group = _this select 0;
_markers = [];
_findAngle = compile preprocessFile "FindAngle.sqf";
while {({alive _x} count units _group) > 0} do {
sleep 10;
    {deleteMarker _x; _markers = _markers - [_x]} forEach _markers;
IF (CSAR_DEBUG) then {
    if (count waypoints _group > 1) then {

        _marker = createMarkerLocal[format ["Waypoint %1",random 9999], getPos leader _group];
        _marker setMarkerTypeLocal 'o_inf';
        _marker setMarkerSizeLocal[1, 1];
        _marker setMarkerColorLocal 'ColorRed';
		_marker setMarkerTextLocal format ["%1",count (units _group)];
        _markers = _markers + [_marker];
        {
            _marker = createMarkerLocal[format ["Waypoint %1",random 9999], waypointPosition _x];
            _marker setMarkerTypeLocal 'hd_end';
            _marker setMarkerSizeLocal[1, 1];
            _marker setMarkerColorLocal 'ColorBlack';
            _marker setMarkerTextLocal format ["%1 - %2",waypointType _x,waypointName _x];
            _markers = _markers + [_marker];
        } forEach (waypoints _group - [waypoints _group select 0]);

        for [{_i=count waypoints _group -1},{_i>0},{_i=_i-1}] do {
            _wp1 = waypoints _group select _i;
            _wp2 = waypoints _group select (_i-1);
            _dist = waypointPosition _wp1 distance waypointPosition _wp2;
            _angle = ([waypointPosition _wp2,waypointPosition _wp1] call bis_fnc_DirTo) + 180;
			_angle = ((_angle % 360) + 360) % 360;
            if (_i == 1) then {
                _dist = (getPos leader _group) distance waypointPosition _wp1;
                _angle = ([getPos leader _group, waypointPosition _wp1] call bis_fnc_DirTo) + 180;
				_angle = ((_angle % 360) + 360) % 360;

            };
            _pos = [(waypointPosition _wp1 select 0) + (sin(_angle)*_dist/2),(waypointPosition _wp1 select 1) + (cos(_angle)*_dist/2)];
            _marker = createMarkerLocal[format ["Waypoint %1",random 9999], _pos];
            _marker setMarkerShapeLocal 'rectangle';
            _marker setMarkerSizeLocal[1.5, _dist*0.5];
            _marker setMarkerColorLocal 'ColorBlack';
            _marker setMarkerBrushLocal "Solid";
            _marker setMarkerDirLocal _angle;
            _markers = _markers + [_marker];
        };
		
        _wp2 = waypointposition [_group,Currentwaypoint _group];
        _dist = (getpos (leader _group)) distance (_wp2);
        _angle = ([_wp2,(getpos (leader _group))] call BIS_fnc_dirTo) + 180;
		_angle = ((_angle % 360) + 360) % 360;		
        _pos = [((getpos (leader _group)) select 0) + (sin(_angle)*_dist/2),((getpos (leader _group)) select 1) + (cos(_angle)*_dist/2)];
        _marker = createMarkerLocal[format ["Waypoint %1",random 9999], _pos];
        _marker setMarkerShapeLocal "rectangle";
        _marker setMarkerSizeLocal[1.5, _dist*0.5];
        _marker setMarkerColorLocal "ColorBlue";
        _marker setMarkerBrushLocal "Solid";
        _marker setMarkerDirLocal _angle;
		
		//during debug show current WP only by making it a global one
		IF (CSAR_DEBUG) then {_marker setMarkerDir _angle};
        _markers = _markers + [_marker];
    }
	};

};
{deleteMarker _x; _markers = _markers - [_x]} forEach _markers;