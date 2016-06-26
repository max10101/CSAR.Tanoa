private ["_x1","_y1","_x2","_y2","_angle","_distance"];

_x1 = (_this select 0) select 0;
_y1 = (_this select 0) select 1;
_x2 = (_this select 1) select 0;
_y2 = (_this select 1) select 1;
_angle = 0;
_distance = compile preprocessFile "distance2d.sqf";

if (_x1 < _x2) then {
    _angle = (-acos((_y1 - _y2)/([_this select 0, _this select 1] call _distance)));
}
else
{
    _angle = (acos((_y1 - _y2)/([_this select 0, _this select 1] call _distance)));
};

_angle;