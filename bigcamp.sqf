_camp = _this;
sleep 5+(random 6);
_ArmedCars = ["O_LSV_02_unarmed_F","I_G_Offroad_01_armed_F"];
_Trucks = ["I_Truck_02_covered_F","I_Truck_02_transport_F"];
_Cars = ["I_G_Offroad_01_F","I_G_Van_01_transport_F","I_C_Offroad_02_unarmed_F"];
_vehtype = selectrandom (_armedcars + _trucks + _cars);
_pos = getpos _camp;
_dir = 0;_dist = 0;
_rand = random 360;
_gunpos = nil;
_gunpos2 = nil;
_vehpos = nil;
_vehpos = [(_pos select 0)+50-random 100,(_pos select 1)+50-random 100,0] findemptyposition [10,50,_vehtype];
_gunpos = [(_pos select 0)+50-random 100,(_pos select 1)+50-random 100,0] findemptyposition [10,30,"I_HMG_01_high_F"];
_gunpos2 = [(_pos select 0)+50-random 100,(_pos select 1)+50-random 100,0] findemptyposition [10,30,"I_HMG_01_high_F"];
sleep 2;
if (count _gunpos <= 0) then {_dir = random 360;_dist = 20 + random 13;_gunpos = [(_pos select 0)+sin(_dir)*_dist,(_pos select 1)+cos(_dir)*_dist,0]};
if (count _gunpos2 <= 0) then {_dir = random 360;_dist = 20 + random 13;_gunpos2 = [(_pos select 0)+sin(_dir)*_dist,(_pos select 1)+cos(_dir)*_dist,0]};
if (count _vehpos <= 0) then {_dir = random 360;_dist = 30 + random 20;_vehpos = [(_pos select 0)+sin(_dir)*_dist,(_pos select 1)+cos(_dir)*_dist,0]};
_veh = _vehtype createvehicle _vehpos;
_veh setdir (random 360);
_veh setfuel (random 0.3);

_gun = [_gunpos,((_gunpos select 0)-(getPos _camp select 0)) atan2 ((_gunpos select 1)-(getPos _camp select 1)),"Gunbag"] call CSAR_fnc_CampGun;
_gun2 = [_gunpos2,((_gunpos2 select 0)-(getPos _camp select 0)) atan2 ((_gunpos2 select 1)-(getPos _camp select 1)),"Gunbag"] call CSAR_fnc_CampGun;
_gun addEventHandler ["Fired",{[_this] call RecoilFunction}];
_gun2 addEventHandler ["Fired",{[_this] call RecoilFunction}];

_group = [_pos, Independent, CSAR_ParaGroup] call BIS_fnc_spawnGroup;
[_group, _pos, 100,3,true] call CSAR_CBA_fnc_taskDefend;

_group addvehicle _gun;
_group addvehicle _gun2;
/*
(units _group) select (count (units _Group)-1) assignasgunner _gun;
[(units _group) select (count (units _Group)-1)] ordergetin TRUE;

(units _group) select (count (units _Group)-2) assignasgunner _gun2;
[(units _group) select (count (units _Group)-2)] ordergetin TRUE;
*/

_group2 = [[(_pos select 0)+((sin 360)*100),(_pos select 1)+((cos 360)*100),0], Independent, CSAR_ParaGroup] call BIS_fnc_spawnGroup;
[_group2, _pos, 300,8,"MOVE","SAFE","YELLOW","NORMAL","STAG COLUMN","",[15,30,60]] call CSAR_cba_fnc_taskPatrol;

{[_x,false,false] call opfor_fnc_initUnit} forEach units _group;
{[_x,true,true,true] call opfor_fnc_initUnit} forEach units _group2;
