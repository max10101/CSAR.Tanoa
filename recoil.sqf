_unit = _this select 0 select 0;
_bullet = _this select 0 select 6;
_dispersion = 1.5;
if (!((vehicle _unit) isKindOf "Man")) then {_dispersion = 3;};
//dispersion level in direction degrees (best from 1-3)
if (!isNull _bullet && ((side _unit == east) OR (side _unit == independent)) && local _unit) then {
	_dir2 = direction _bullet;
	_vel = velocity _bullet;
	_speed = vectormagnitude _vel;
	_lowvel = [(_vel select 0)/_speed,(_vel select 1)/_speed,(_vel select 2)/_speed];
	_dirup = _vel call CBA_fnc_vectElev;
	_rand = _dir2+(_dispersion-(random _dispersion*2));
	_randup = _dirup+(_dispersion-(random _dispersion*2));
	_adjvel = [(_lowvel select 0) + (sin _rand),(_lowvel select 1) + (cos _rand),(_lowvel select 2) + (tan _randup)];
	_adjvel2 = [((_adjvel select 0)*_speed)/2,((_adjvel select 1)*_speed)/2,((_adjvel select 2)*_speed)/2];
	_bullet setVelocity _adjvel2;
};