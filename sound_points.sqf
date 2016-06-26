_unit = _this select 0;
_points = _this select 1;
IF (!Local _unit) Exitwith {};
IF (_Points >= 1100) then 
	{
	LastVoiceTime = time;
	sleep(1+random 3);
	_sound = SelectRandom Boomsounds;
	[_unit,_sound] remoteExec ["Say3D",0];
	} else {
	IF (time >= (LastVoiceTime + SoundDelayTime)&& (_Points >= 200) && (_Points < 1100) && (random 1 >= 0.70)) then 
		{
		LastVoiceTime = time;
		sleep(1+random 3);
		_sound = SelectRandom Killsounds;
		[_unit,_sound] remoteExec ["Say3D",0];
		};
	};