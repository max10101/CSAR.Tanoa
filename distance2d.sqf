private ["_x1","_y1","_x2","_y2","_dist"];
_x1 = (_this select 0) select 0;
_y1 = (_this select 0) select 1;
_x2 = (_this select 1) select 0;
_y2 = (_this select 1) select 1;
_dist = 0;

_dist = abs(sqrt(((_x2-_x1)^2)+((_y2-_y1)^2)));
_dist;