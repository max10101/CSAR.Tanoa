_camp = _this;
sleep 10;
_ArmedCars = ["O_LSV_02_unarmed_F","I_G_Offroad_01_armed_F"];
_Trucks = ["I_Truck_02_covered_F","I_Truck_02_transport_F"];
_Cars = ["I_G_Offroad_01_F","I_G_Van_01_transport_F","I_C_Offroad_02_unarmed_F"];
_vehtype = selectrandom (_armedcars + _trucks + _cars);
_pos = getpos _camp;
_vehpos = [(_pos select 0)+50-random 100,(_pos select 1)+50-random 100,0] findemptyposition [1,50,_vehtype];
_gunpos = [(_pos select 0)+50-random 100,(_pos select 1)+50-random 100,0];// findemptyposition [1,20,"I_HMG_01_high_F"];
_gunpos2 = [(_pos select 0)+50-random 100,(_pos select 1)+50-random 100,0];// findemptyposition [1,20,"I_HMG_01_high_F"];
sleep 2;
_veh = _vehtype createvehicle _vehpos;
_veh setdir (random 360);
_veh setfuel (random 0.3);

_gun = [_gunpos,((_gunpos select 0)-(getPos _camp select 0)) atan2 ((_gunpos select 1)-(getPos _camp select 1)),"Gunbag"] call CSAR_fnc_CampGun;
_gun2 = [_gunpos2,((_gunpos2 select 0)-(getPos _camp select 0)) atan2 ((_gunpos2 select 1)-(getPos _camp select 1)),"Gunbag"] call CSAR_fnc_CampGun;
_gun addEventHandler ["Fired",{[_this] call RecoilFunction}];
_gun2 addEventHandler ["Fired",{[_this] call RecoilFunction}];

_group = [_pos, Independent, CSAR_ParaGroup] call BIS_fnc_spawnGroup;
[_group, _pos, 100,3,true] call CSAR_CBA_fnc_taskDefend;


_group2 = [[(_pos select 0)+((sin 360)*100),(_pos select 1)+((cos 360)*100),0], Independent, CSAR_ParaGroup] call BIS_fnc_spawnGroup;
[_group2, _pos, 300,8,"MOVE","SAFE","YELLOW","NORMAL","STAG COLUMN","",[15,30,60]] call CSAR_cba_fnc_taskPatrol;

_group3 = [[(_pos select 0)+((sin 180)*100),(_pos select 1)+((cos 180)*100),0], Independent, CSAR_ParaGroup] call BIS_fnc_spawnGroup;
[_group3, _pos, 300,8,"MOVE","SAFE","YELLOW","NORMAL","STAG COLUMN","",[15,30,60]] call CSAR_cba_fnc_taskPatrol;


_pos2 = [(_pos select 0)+((sin 90)*500),(_pos select 1)+((cos 90)*500),0];
_group4 = [_pos2, Independent, CSAR_BanditGroupSmall] call BIS_fnc_spawnGroup;
[_group4, _pos2, 300,8,"MOVE","SAFE","YELLOW","NORMAL","STAG COLUMN","",[15,30,60]] call CSAR_cba_fnc_taskPatrol;

_pos2 = [(_pos select 0)+((sin 180)*500),(_pos select 1)+((cos 180)*500),0];
_group5 = [_pos2, Independent, CSAR_BanditGroupSmall] call BIS_fnc_spawnGroup;
[_group5, _pos2, 300,8,"MOVE","SAFE","YELLOW","NORMAL","STAG COLUMN","",[15,30,60]] call CSAR_cba_fnc_taskPatrol;

_pos2 = [(_pos select 0)+((sin 360)*500),(_pos select 1)+((cos 360)*500),0];
_group6 = [_pos2, Independent, CSAR_BanditGroupSmall] call BIS_fnc_spawnGroup;
[_group6, _pos2, 300,8,"MOVE","SAFE","YELLOW","NORMAL","STAG COLUMN","",[15,30,60]] call CSAR_cba_fnc_taskPatrol;

_pos2 = [(_pos select 0)+((sin 270)*500),(_pos select 1)+((cos 270)*500),0];
_group7 = [_pos2, Independent, CSAR_BanditGroupSmall] call BIS_fnc_spawnGroup;
[_group7, _pos2, 300,8,"MOVE","SAFE","YELLOW","NORMAL","STAG COLUMN","",[15,30,60]] call CSAR_cba_fnc_taskPatrol;


{[_x,false,false] call opfor_fnc_initUnit} forEach units _group;
{[_x,true,true] call opfor_fnc_initUnit} forEach units _group2;
{[_x,true,true] call opfor_fnc_initUnit} forEach units _group3;

{[_x,true,true] call opfor_fnc_initUnit} forEach units _group4;
{[_x,true,true] call opfor_fnc_initUnit} forEach units _group5;
{[_x,true,true] call opfor_fnc_initUnit} forEach units _group6;
{[_x,true,true] call opfor_fnc_initUnit} forEach units _group7;