if (!(_this getVariable ["CSAR_unitInitialized",false])) then {
	if (!(_this isKindOf "man")) then {
		{_x call blufor_fnc_initUnit} forEach crew (vehicle _this);
	} else {
		_this setVariable["CSAR_unitInitialized",true];
		_this enableFatigue false;
		_this disableAI "AUTOCOMBAT";
		//_this addEventHandler ["Fired",{[_this] call RecoilFunction}];
		_this addEventHandler ["Local",{(_this select 0) disableAI "AUTOCOMBAT"}];
		_this addeventhandler ["HandleRating", {_this execvm "sound_points.sqf"}];
		_this addEventHandler ["Hit", {_this execvm "sound_hit.sqf"}];
		_this addeventhandler ["Fired", {_this execvm "sound_fired.sqf"}];
		_this addEventHandler ["Killed", {_this execvm "sound_killed.sqf"}];
		_this addEventHandler ["Respawn", {_this execvm "AIRespawn.sqf"}];
	};
}