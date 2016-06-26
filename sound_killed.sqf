_unit = _this select 0;
//_causedby = _this select 1;
//_damage = _this select 2;
IF (!Local _unit) Exitwith {};
IF (time >= (LastVoiceTime + SoundDelayTime) && (random 1 >= 0.5)) then 
	{
	_group = group _unit;
	sleep 1+(random 3);
	IF (({alive _x} count (units _group)) <= 0) ExitWith {};
	_unit = selectrandom (units _group);
	LastVoiceTime = time;
	_sound = SelectRandom Losssounds;
	[_unit,_sound] remoteExec ["Say3D",0];
	};