_unit = _this select 0;
_weapon = _this select 1;
_ammo = _this select 4;
IF (!Local _unit) Exitwith {};
IF (time >= (LastVoiceTime + SoundDelayTime) && (_weapon isKindOf ["Launcher", configFile >> "CfgWeapons"] OR _ammo in ["GrenadeHand","mini_Grenade"]) && (random 1 >= 0.4)) then 
	{
	LastVoiceTime = time;
	_sound = SelectRandom ThrowSounds;
	[_unit,_sound] remoteExec ["Say3D",0];
	};