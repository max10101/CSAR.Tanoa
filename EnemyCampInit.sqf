//checks true if unit is within distance of any of the group units - [unit, group of units, distance] call _distcheck
sleep 5;
_Distcheck = compile '
private ["_IsWithinDist"];
_IsWithinDist = false;
{IF (((_this select 0) distance (_x)) < (_this select 2)) then {_IsWithinDist = true}} foreach (_this select 1);
_IsWithinDist
';

_maxcamps = 12;
_bigcamps = 4;
_camps = ["CampA","CampB","CampC","CampD","CampE","CampF"];
_POWCamps = ["CampD","CampE","CampE","CampF"];
_MilCamps = ["CampD","CampE","CampE","CampF"];
_spawns = CSAR_CampLocations;
_first = objnull;


//SELECT AND PREP X 'LARGE' CAMPS NOT WITHIN CLOSE PROXIMITY TO OTHER LARGE CAMPS (possibility to halt everything here if dist is too big so move on after 25 conflict)
_conflictmax = 25;
_conflict = 0;
_i = 0;
while {_i < _bigcamps} do {
	IF (_first == objnull) then {_first = _spawns select 21;BigEnemyCamps = BigEnemyCamps + [_first];};
	_Pos = selectrandom _spawns;
	while {([_pos,BigEnemyCamps,2000] call _distcheck) && (_conflict < _conflictmax)} do {_pos = selectrandom _spawns;sleep 0.01;_conflict = _conflict + 1};
	_first = _pos;
	[getpos _pos, west, (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "Camps" >> (SelectRandom _MilCamps))] call CSAR_fnc_SpawnCamps;
	BigEnemyCamps = BigEnemyCamps + [_pos];
	IF (CSAR_DEBUG) then {_marker = createMarkerlocal[format ["POWCAMP (%1)",random 9999], getPos _pos];_marker setMarkerSizeLocal [200,200];_marker setMarkerColorLocal "ColorOrange";_marker setMarkerShapeLocal "ELLIPSE"};
	_spawns = _spawns - [_pos];
	_i = _i + 1;
	sleep 1;
};
AACamp = (selectrandom BigEnemyCamps);
BigEnemyCamps = BigEnemyCamps - [AACamp];
AACamp execvm "aacamp.sqf";
"AAMarker" setmarkerpos (getpos AACamp);

sleep 1;

//SELECT POW CAMP
//remove undesirable POW spawn locations along outer edges
_POWSpawns = _spawns - [CampPos_17,CampPos_23,CampPos_20,CampPos_11,CampPos_24,CampPos_28,CampPos_18,CampPos_22,CampPos_29];
_POWCamp = selectrandom _POWSpawns;

_spawns = _spawns - [_POWCamp];
[getpos _POWCamp, west, (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "Camps" >> (SelectRandom _POWCamps))] call CSAR_fnc_SpawnCamps;
POWCamp = _POWCamp; Publicvariable "POWCamp";
_angle = random 360;
_dist = 1000 + (random 1000);
CrashedHeli setpos [(getpos POWCamp select 0) + sin(_angle)*_dist,(getpos POWCamp select 1) + cos(_angle)*_dist,0];
Sleep 1;


// PREP AND PLACE POW WITHIN CAMP
_buildings = nearestObjects [_POWCamp, ["Land_d_Windmill01_F","Land_d_House_Small_02_V1_F","Land_d_Stone_HouseSmall_V1_F","Land_Unfinished_Building_02_F"], 25];
_BuildingPositions = (Selectrandom _buildings) buildingpos -1;
IF (count _buildingpositions == 0) then {_buildingpositions = [[(getpos _POWCamp select 0)+10,(getpos _POWCamp select 1)+10,0]]};
sleep 1;
IF (CSAR_DEBUG) then {_marker = createMarkerlocal[format ["POWCAMP (%1)",random 9999], getPos _POWCamp];_marker setMarkerSizeLocal [100,100];_marker setMarkerColorLocal "ColorBlue";_marker setMarkerShapeLocal "ELLIPSE"};

POW setpos (SelectRandom _buildingpositions);
POW setdir (random 360);
removevest POW;removeheadgear POW;
POW addvest "V_PlateCarrierSpec_tna_F";pow addheadgear "H_HelmetB_Enh_tna_F";
[[POW,"Acts_AidlPsitMstpSsurWnonDnon_Loop"], "switchMoveMP"] call BIS_fnc_MP;


// FIND X NEAREST CAMPS CLOSEST TO PILOT CAMP AND POPULATE INTO ENEMY CAMPS
_closestcamps = [_spawns,[],{_POWCamp distance _x},"ASCEND"] call BIS_fnc_sortBy;
_i = 0;
while {_i < _maxcamps} do {
	[getpos (_closestcamps select _i), west, (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "Camps" >> (SelectRandom _Camps))] call CSAR_fnc_SpawnCamps;
	EnemyCamps = EnemyCamps + [(_closestcamps select _i)];
	IF (CSAR_DEBUG) then {_marker = createMarkerlocal[format ["POWCAMP (%1)",random 9999], getPos (_closestcamps select _i)];_marker setMarkerSizeLocal [100,100];_marker setMarkerColorLocal "ColorGreen";_marker setMarkerShapeLocal "ELLIPSE"};

	_spawns = _spawns - [(_closestcamps select _i)];
	_i = _i + 1;
	sleep 1;
};

//WHATS LEFT OF CAMP SPAWN LOCATIONS IS CHOSEN FOR INTEL POS
_Intelcamp = Selectrandom _spawns;
	IF (CSAR_DEBUG) then {_marker = createMarkerlocal[format ["INTELCAMP (%1)",random 9999], getPos _Intelcamp];_marker setMarkerSizeLocal [100,100];_marker setMarkerColorLocal "ColorRed";_marker setMarkerShapeLocal "ELLIPSE"};
[getpos _IntelCamp, west, (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "Camps" >> (SelectRandom _POWCamps))] call CSAR_fnc_SpawnCamps;
sleep 1;
_buildings = nearestObjects [_Intelcamp, ["Land_d_House_Small_02_V1_F","Land_d_Stone_HouseSmall_V1_F","Land_Unfinished_Building_02_F"], 25];
_BuildingPositions = (Selectrandom _buildings) buildingpos -1;
IF (count _buildingpositions == 0) then {_buildingpositions = [[(getpos _IntelCamp select 0)+10,(getpos _IntelCamp select 1)+10,0],[(getpos _IntelCamp select 0)-10,(getpos _IntelCamp select 1)+10,0],[(getpos _IntelCamp select 0)-15,(getpos _IntelCamp select 1)-15,0]]};
IntelMap = "Mapboard_Seismic_F" createvehicle [0,0,100];Intelmap setpos (SelectRandom _buildingpositions);
IntelMap setdir (random 360);
IntelMap enableSimulationGlobal false;
//player setpos (SelectRandom _buildingpositio.ns);
//_grp = Creategroup Independent;
//IntelOfficer = _grp createUnit ["I_C_Soldier_Camo_F", (SelectRandom _buildingpositions), [], 0, "FORM"];
//_wpSAD = _grp addWaypoint [(SelectRandom _buildingpositions),0];
//_wpSAD setwaypointtype "HOLD";
publicvariable "IntelMap";
CampsInitialised = true;
_intelcamp execvm "intelcamp.sqf";


sleep 5;
{_x execvm "smallcamp.sqf"} foreach EnemyCamps;
sleep 5;
{_x execvm "bigcamp.sqf"} foreach BigEnemyCamps;
sleep 5;
{_x execvm "camppatrol.sqf"} foreach EnemyCamps;
POWCamp execvm "powcamp.sqf";
IF (CSAR_DEBUG) then {systemchat "Camps initialised"};