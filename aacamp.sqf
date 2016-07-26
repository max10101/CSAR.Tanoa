_camp = _this;
sleep 5;
_ArmedCars = ["O_LSV_02_unarmed_F","I_G_Offroad_01_armed_F"];
_AA = ["I_Static_AA_F"];
_Trucks = ["I_Truck_02_covered_F","I_Truck_02_transport_F"];
_Cars = ["I_G_Offroad_01_F","I_G_Van_01_transport_F","I_C_Offroad_02_unarmed_F"];
_vehtype = selectrandom (_armedcars + _trucks + _cars);
_pos = getpos _camp;
_spawngun = false;
IF (random 1 > 0.5) then {_spawngun = true};
_vehpos = [(_pos select 0)+25-random 50,(_pos select 1)+25-random 50,0] findemptyposition [1,50,_vehtype];
_gunpos = [(_pos select 0)+50-random 100,(_pos select 1)+50-random 100,0];// findemptyposition [1,25,"I_HMG_01_high_F"];
_aagun1pos = [(_pos select 0)+((sin 120)*20),(_pos select 1)+((cos 120)*20),0];
_aagun2pos = [(_pos select 0)+((sin 240)*20),(_pos select 1)+((cos 240)*20),0];
_aagun3pos = [(_pos select 0)+((sin 360)*20),(_pos select 1)+((cos 360)*20),0];

sleep 1.5;
_veh = _vehtype createvehicle _vehpos;
_veh setdir (random 360);
_veh setfuel (random 0.3);

_ammo1 = "Box_Syndicate_WpsLaunch_F" createvehicle [(_pos select 0)+((sin 260)*18),(_pos select 1)+((cos 260)*18),0];

_gun = [_gunpos,((_gunpos select 0)-(getPos _camp select 0)) atan2 ((_gunpos select 1)-(getPos _camp select 1)),"Gunbag"] call CSAR_fnc_CampGun;

_aagun1 = [_aagun1pos,((_aagun1pos select 0)-(getPos _camp select 0)) atan2 ((_aagun1pos select 1)-(getPos _camp select 1)),"AAGun"] call CSAR_fnc_CampGun;
_aagun2 = [_aagun2pos,((_aagun2pos select 0)-(getPos _camp select 0)) atan2 ((_aagun2pos select 1)-(getPos _camp select 1)),"AAGun"] call CSAR_fnc_CampGun;
_aagun3 = [_aagun3pos,((_aagun3pos select 0)-(getPos _camp select 0)) atan2 ((_aagun3pos select 1)-(getPos _camp select 1)),"AAGun"] call CSAR_fnc_CampGun;

_group = [_pos, Independent, CSAR_ParaGroup] call BIS_fnc_spawnGroup;
[_group, _pos, 100,3,true] call CSAR_CBA_fnc_taskDefend;
/*
_group addvehicle _gun;
_wp = _group addWaypoint [_pos, 0];
_wp setwaypointtype "LOITER";
_wp setWaypointLoiterRadius 100;
_wp setWaypointLoiterType "CIRCLE_L";
_wp setWaypointStatements ["true", ""];
_group setbehaviour "SAFE";
*/

_group2 = [[(_pos select 0)+((sin 360)*100),(_pos select 1)+((cos 360)*100),0], Independent, CSAR_ParaGroup] call BIS_fnc_spawnGroup;
[_group2, _pos, 300,8,"MOVE","SAFE","YELLOW","NORMAL","STAG COLUMN","",[15,30,60]] call CSAR_cba_fnc_taskPatrol;
_group3 = [[(_pos select 0)+((sin 180)*100),(_pos select 1)+((cos 180)*100),0], Independent, CSAR_ParaGroup] call BIS_fnc_spawnGroup;
[_group3, _pos, 300,8,"MOVE","SAFE","YELLOW","NORMAL","STAG COLUMN","",[15,30,60]] call CSAR_cba_fnc_taskPatrol;


//(units _group) select (count (units _Group)-1) assignasgunner _gun;
//[(units _group) select (count (units _Group)-1)] ordergetin TRUE;

(units _group) select (count (units _Group)-2) moveingunner _aagun1;
[(units _group) select (count (units _Group)-2)] ordergetin TRUE;

(units _group) select (count (units _Group)-3) moveingunner _aagun2;
[(units _group) select (count (units _Group)-3)] ordergetin TRUE;

(units _group) select (count (units _Group)-4) moveingunner _aagun3;
[(units _group) select (count (units _Group)-4)] ordergetin TRUE;

sleep 2;

_aagun1 setpos (getpos _aagun1);_aagun1 setvelocity [0,0,0];_aagun1 setmass 200;
_aagun2 setpos (getpos _aagun2);_aagun2 setvelocity [0,0,0];_aagun2 setmass 200;
_aagun3 setpos (getpos _aagun3);_aagun3 setvelocity [0,0,0];_aagun3 setmass 200;
AAgun1 = _aagun1;publicvariable "AAgun1";
AAgun2 = _aagun2;publicvariable "AAgun2";
AAgun3 = _aagun3;publicvariable "AAgun3";

{[_x,false,false] call opfor_fnc_initUnit} forEach units _group;
{[_x,true,true] call opfor_fnc_initUnit} forEach units _group2;
{[_x,true,true] call opfor_fnc_initUnit} forEach units _group3;