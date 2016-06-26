
_gunbag = compile '
private ["_pos","_dir","_gun","_sandbag1","_sandbag2"];
_pos = _this select 0;
_dir = _this select 1;
_gun = createvehicle ["I_HMG_01_high_F",[(_pos select 0),(_pos select 1),0],[],0,"CAN_COLLIDE"];
_gun setdir _dir;
_sandbag1 = "Land_BagFence_01_round_green_F" createvehicle [(_pos select 0) + -1.2529297,(_pos select 1) + 0.44380331,0];
_sandbag2 = "Land_BagFence_01_round_green_F" createvehicle [(_pos select 0) + 1.1181641,(_pos select 1) + 0.41731071,0];
[_gun, _sandbag1,[-1.2529297,0.44380331+0.5,0],135] call bis_fnc_relPosObject;
[_gun, _sandbag2,[1.1181641,0.41731071+0.5,0],225] call bis_fnc_relPosObject;
_gun enablesimulation true;
_gun
';
private ["_gun"];
_gun = objnull;
IF ((_this select 2) == "Gunbag") then {_gun = _this call _gunbag};
_gun;