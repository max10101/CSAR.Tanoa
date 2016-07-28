_pos = _this select 0;
_angle = [_pos,getPos EastBase] call compile preprocessFile "FindAngle.sqf";
_heli = createVehicle ["I_Heli_light_03_unarmed_F", getPos EastBase, [], 0, "FLY"];
_Grp = creategroup Independent;
_heli setDir _angle;
_Pilot = _grp createUnit ["I_C_HeliPilot_F", getPos WestBase, [], 0, "FORM"];
_grp addvehicle _heli;
_Pilot moveindriver _heli;
group _heli setBehaviour "CARELESS";

_group1 = [getPos EastBase, Independent, (configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaCombatGroup")] call BIS_fnc_spawnGroup;
//waitUntil {count units _group1 >= 8};
sleep 5;
_wpSAD = _group1 addWaypoint [_pos,200];
_wpSAD setwaypointtype "SAD";
{_x assignAsCargo _heli; _x moveInCargo _heli} forEach units _group1;
waitUntil {leader _group1 in _heli};
sleep 1;
{[_x,false,true] call compile preprocessFile "opfor_fnc_initUnit.sqf"} forEach units _group1;

_heli addEventHandler ["dammaged", {_this execVM "HelicopterEmergency.sqf"}];


_ejectPos = _pos;
_followThroughPos = [(_pos select 0) + sin(_angle)*500, (_pos select 1) + cos(_angle)*500, 0];
_followThroughPos2 = [(_pos select 0) + sin(_angle)*50, (_pos select 1) + cos(_angle)*50, 0];
_initialPos = [(_ejectPos select 0) + sin(_angle)*-300, (_ejectPos select 1) + cos(_angle)*-300, 0];

_wpInitial = group _heli addWaypoint [_initialPos, 0];
_wpInitial setWaypointStatements ["true", "group this setSpeedMode ""LIMITED"""];
_wpEject = group _heli addWaypoint [_ejectPos, 0];
_wpEject setWaypointStatements ["true", "[vehicle this,false] execVM ""Eject.sqf"""];
_wpEject2 = group _heli addWaypoint [_followThroughPos2, 0];
_wpEject2 setWaypointStatements ["true", "group this setSpeedMode ""FULL"""];
_wpEjectFinish = group _heli addWaypoint [_ejectPos, 0];
_wpEjectFinish setWaypointStatements ["count crew vehicle this <= 1", ""];
_wpFolowThrough = group _heli addWaypoint [_followThroughPos, 0];
_wpRTB = group _heli addWaypoint [getPos EastBase, 0];
_wpRTB setWaypointStatements ["true", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach units group this"];
_heli flyInHeight 100;