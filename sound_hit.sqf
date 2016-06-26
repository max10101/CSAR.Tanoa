_unit = _this select 0;
_causedby = _this select 1;
_damage = _this select 2;
IF (!Local _unit) Exitwith {};
IF (time >= (LastVoiceTime + SoundDelayTime) && (random 1 >= 0.4) && (alive _unit)) then 
	{
	LastVoiceTime = time;
	_sound = SelectRandom Painsounds;
	[_unit,_sound] remoteExec ["Say3D",0];
	};