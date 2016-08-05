_pos = _this select 0;
_expire = time + (_this select 1);
_size = _this select 2;
_smokearray = [];
_firearray = [];
_MaxSmoke = 3;
_Maxfire = 10;
_color = [1, 1, 1];
_velocity = wind;
/*[coreIntensity, coreDistance, damageTime]: Array
coreIntensity: Number - damage in the center of fire
coreDistance: Number - how far can unit get damage
damageTime: Number - how often is unit getting damage*/ 
_fireintensityC = [25,12,1];
_fireintensity = [8,7,1];
_fireintensity2 = [0,0,0];

if (time > _expire) exitWith {};

_obj = createAgent ["Logic", [_pos select 0, _pos select 1, 0], [] , 0 , "CAN_COLLIDE"];
CSAR_NapalmTMP = _obj;
  [CSAR_NapalmTMP] spawn
  {
    _obj1 = _this select 0;
    while {true} do
    {
      if (((player distance _obj1) <= 80)) then
      {
        _color = ppEffectCreate ["ColorCorrections", 1234];
        _color ppEffectEnable true;
        _color ppEffectAdjust [0.25, 1, 0, [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0]];
        _color ppEffectCommit 1;
        sleep 0.5;
		_color ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 1], [0.299, 0.587, 0.114, 0]];
        _color ppEffectCommit 0.5;
		sleep 0.5;
        ppEffectDestroy _color;
      };
      if (IsNull _obj1) exitWith {};
      sleep 0.5;
    };
  };
  
_i = 0;
While {_i < _maxSmoke} do {
_smoke = "#particlesource" createVehicleLocal [(_pos select 0)-_size+(random (_size*2)),(_pos select 1)-_size+(random (_size*2)),0];
_smoke setParticleClass "BigDestructionSmoke";

//[lifeTime, position, moveVelocity, rotationVelocity, size, color, randomDirectionPeriod, randomDirectionIntensity, {angle}, bounceOnSurface]
_smoke setparticlerandom [12, [5, 5, 10], [0, 0, 2], 0, 2, [0, 0, 0, 0], 0, 0];
_smokearray = _smokearray + [_smoke];
_i = _i + 1;
};

_ps1 = "#particlesource" createVehicleLocal _pos;
_ps1 setParticleParams [["a3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 1, 12, 0], "", "Billboard", 1, 4 + random 3, [0, 0, 5], _velocity, 1, 1.1, 1, 0, [.3 + (random 1)], [_color + [0], _color + [0.31], _color + [0]], [1000], 1, 0, "", "", 1];
_ps1 setParticleRandom [3, [5 + (random 1), 4 + (random 1), 7], [random 4, random 4, 2], 14, 3, [0, 0, 0, .1], 1, 0];
_ps1 setParticleCircle [1, [0.5, 0.5, 0]];
_ps1 setDropInterval 0.022;
_ps1 setParticleFire _fireintensityC;
_firearray = _firearray + [_ps1];
_i = 0;
While {_i < _maxFire} do {
_pos1 = [(_pos select 0)-_size+(random (_size*2)),(_pos select 1)-_size+(random (_size*2)),(random 10)];
_ps1 = "#particlesource" createVehicleLocal _pos1;
_ps1 setParticleParams [["a3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 1, 12, 0], "", "Billboard", 1, 4 + random 3, [0, 0, 5], _velocity, 1, 1.1, 1, 0, [.3 + (random 1)], [_color + [0], _color + [0.31], _color + [0]], [1000], 1, 0, "", "", 1];
_ps1 setParticleRandom [3, [5 + (random 1), 4 + (random 1), 7], [random 4, random 4, 2], 14, 3, [0, 0, 0, .1], 1, 0];
_ps1 setParticleCircle [1, [0.5, 0.5, 0]];
_ps1 setDropInterval 0.022;
_ps1 setParticleFire _fireintensity;

_ps2 = "#particlesource" createVehicleLocal _pos1;
_ps2 setParticleParams [["a3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 3, 12, 0], "", "Billboard", 1, 3 + random 1, [5, 5, 4], _velocity, 1, 1.1, 1, 0, [.5 + (random .5)], [_color + [0], _color + [0.35], _color + [0]], [1000], 1, 0, "", "", 1];
_ps2 setParticleRandom [3, [1 + (random 1), 4 + (random 1), 9], [random 5, random 2, 1], 14, 3, [0, 0, 0, .1], 1, 0];
_ps2 setParticleCircle [1, [0.5, 0.5, 0]];
_ps2 setDropInterval 0.006;

_firearray = _firearray + [_ps1,_ps2];
_i = _i + 1;
};

_slight6i = 21.4;
_slight6 = "#lightpoint" createVehicleLocal [ _pos select 0, _pos select 1, 10];
_slight6 setlightBrightness _slight6i;
_slight6 setlightAmbient[.3, .1, 0];
_slight6 setlightColor[.3, .1, 0];

_slight1i = 9.4;
_slight1 = "#lightpoint" createVehicleLocal [_pos select 0, _pos select 1, 10];
_slight1 setlightBrightness _slight1i;
_slight1 setlightAmbient[1, 1, 1];
_slight1 setlightColor[1, 1, .9];

waitUntil{time > _expire};
{deletevehicle _x} foreach _firearray;
deletevehicle CSAR_NapalmTMP;
{_x setParticleFire _fireintensity2} foreach _smokearray;

while {_slight6i > 0} do {
	_slight6i = _slight6i - 0.1;
	IF (_slight1i > 0 && !IsNull _slight1) then {_slight1i = _slight1i - 0.1;_slight1 setlightbrightness _slight1i;} else {deletevehicle _slight1};
	_slight6 setlightbrightness _slight6i;
	sleep 0.1
};
sleep 20;
deletevehicle _slight6;
{deletevehicle _x} foreach _smokearray;
