if(local _this) then {
	_unit = _this;
	_mags = [["30Rnd_65x39_caseless_green","30Rnd_65x39_caseless_green_mag_tracer"],["30Rnd_545x39_Mag_F","30Rnd_545x39_Mag_Tracer_F"],["30Rnd_762x39_Mag_F","30Rnd_762x39_Mag_Tracer_F"],["200Rnd_556x45_Box_F","200Rnd_556x45_Box_Tracer_F"]];
	_unit unlinkitem "NVGoggles_OPFOR";_unit unlinkitem "NVGoggles";
	_unit addPrimaryWeaponItem "acc_flashlight";_unit enableGunLights "forceOn";
	{IF ((_x select 0) in magazines _unit) then {_unit removemagazines (_x select 0);_unit addmagazines [(_x select 1),7];_unit removeprimaryweaponitem (_x select 0);_unit addprimaryweaponitem (_x select 1)}} foreach _mags;
};