
call compile preprocessFile "Support\init.sqf";
//call compileFinal preprocessFileLineNumbers "FAR_revive\FAR_revive_init.sqf";
/*

*/

RecoilFunction = compile preprocessFile "recoil.sqf";
blufor_fnc_initUnit = compile preprocessFile "blufor_fnc_initUnit.sqf";
opfor_fnc_initUnit = compile preprocessFile "opfor_fnc_initUnit.sqf";
opfor_fnc_initUnit2 = compile preprocessFile "opfor_fnc_initUnit2.sqf";
CSAR_fnc_SpawnCamps = compile preprocessFile "Spawncamps.sqf"; 
CSAR_fnc_Arsenal = compile preprocessFile "arsenalfnc.sqf"; 
CSAR_fnc_CampGun = compile preprocessFile "camp.sqf"; 
switchMoveMP = compileFinal "_this select 0 switchMove (_this select 1);";
CSAR_NapalmExec = compileFinal "[_this,CSAR_NapalmTime,CSAR_NapalmSize] execvm ""Napalmnew.sqf""";
PlayMoveMP = compileFinal "_this select 0 PlayMove (_this select 1);";

CSAR_fnc_Arsenal = compile preprocessFile "arsenalfnc.sqf"; 

//add a waypoint that the unit will immediately follow - and then go back to original set of waypoints when completed continuing where they left off - DO NOT SETWPSTATEMENTS WITH NEW WP
//call with [_group,_newWPpos] call CSAR_fnc_InjectWP - returns WP
CSAR_fnc_InjectWP = compile '
private ["_current","_newWP","_newpos","_group"];
_group = _this select 0;
_newpos = _this select 1;
_current = currentWaypoint _group;
[_group,_current] setWaypointStatements ["true",""];
_newWP = _group addWaypoint [_newPos, 0];
call compile format ["_newWP setWaypointStatements [""true"", ""group this setcurrentwaypoint [group this,%1];""]",_current];
_group setcurrentwaypoint _newWP;
[_group,_current] setWaypointStatements ["true", "this execvm ""ConvoyNewWaypoint.sqf"""];
_newWP
';

CSAR_fnc_initSpawn = compile '
    _unit = _this;
    if (local _unit) then {
        mattzig_earPlugsInUse = false;
        1 fadeSound 1;
		_unit setunittrait ["Engineer",1];
		_unit setVariable ["#rev_enabled", true, true];
        _unit addEventHandler ["HandleRating", "_rating = (_this select 1);if (_rating < 0) then {_rating = 0;}; _rating"];
        _unit enablefatigue false;
        _putEarOn = ["<t color=""#ffff33"">Put on ear plugs</t>",{1 fadeSound 0.3; mattzig_earPlugsInUse = true;},[],-90,false,true,"","!mattzig_earPlugsInUse && vehicle player == vehicle _target"];
        _takeEarOff = ["<t color=""#ffff33"">Take off ear plugs</t>",{1 fadeSound 1; mattzig_earPlugsInUse = false;},[],-90,false,true,"","mattzig_earPlugsInUse && vehicle player == vehicle _target"];
        _unit addAction _putEarOn;
        _unit addAction _takeEarOff;
		player sidechat "INITSPAWN";
        if (!(isPlayer (leader group _unit))) then {
            if (local (leader group _unit)) then {
                (group _unit) selectLeader _unit;
            } else {
                [group _unit, _unit] remoteExec ["selectLeader", leader group _unit];
            };
         };
        [_unit] execVM "Support\addActions.sqf";
    };';

CSAR_NapalmSize = 50;
CSAR_NapalmTime = 50;
CSAR_Debug = true;
CampsInitialised = false;
ConvoysInitialised = false;
CSAR_ConvoyRoads = [];
CSAR_CampLocations = [CampPos,CampPos_1,CampPos_2,CampPos_3,CampPos_4,CampPos_5,CampPos_6,CampPos_7,CampPos_8,CampPos_9,CampPos_10,CampPos_11,CampPos_12,CampPos_13,CampPos_14,CampPos_15,CampPos_16,CampPos_17,CampPos_18,CampPos_19,CampPos_20,CampPos_21,CampPos_22,CampPos_23,CampPos_24,CampPos_25,CampPos_26,CampPos_27,CampPos_28,CampPos_29];


Boomsounds = ["A_Boom_1","A_Boom_2","A_Boom_3","A_Boom_4","A_Boom_5","A_Boom_6","A_Boom_7","A_Boom_8","A_Boom_9"];
Throwsounds = ["A_Throw_1","A_Throw_2","A_Throw_3","A_Throw_4"];
Painsounds = ["A_Pain_1","A_Pain_2","A_Pain_3","A_Pain_4","A_Pain_5","A_Pain_6","A_Pain_7","A_Pain_8","A_Pain_9","A_Pain_10","A_Pain_11","A_Pain_12","A_Pain_13","A_Pain_14","A_Pain_15","A_Pain_16","A_Pain_17","A_Pain_18"];
Cheersounds = ["A_Cheer_1","A_Cheer_2","A_Cheer_3","A_Cheer_4","A_Cheer_5","A_Cheer_6","A_Cheer_7","A_Cheer_8","A_Cheer_9","A_Cheer_10","A_Cheer_11","A_Cheer_12","A_Cheer_13","A_Cheer_14"];
Killsounds = ["A_Kill_1","A_Kill_2","A_Kill_3","A_Kill_4","A_Kill_5","A_Kill_6","A_Kill_7","A_Kill_8","A_Kill_9","A_Kill_10","A_Kill_11","A_Kill_12","A_Kill_13"];
Losssounds = ["A_Loss_1","A_Loss_2","A_Loss_3","A_Loss_4","A_Loss_5","A_Loss_6","A_Loss_7","A_Loss_8","A_Loss_9","A_Loss_10","A_Loss_11","A_Loss_12","A_Loss_13","A_Loss_14","A_Loss_15"];
LastVoiceTime = 0;
SoundDelayTime = 8;
BIS_Effects_Burn=compile preprocessFileLineNumbers "burn.sqf";
[crashedheli, 4, time, false, true] spawn BIS_Effects_Burn;

[] execVM "CSAR_Respawn.sqf";
//[] execVM "real_weather.sqf";

POWAction = POW addaction ["<t color='#FF0000'>Rescue POW</t>","FreePow.sqf",nil,0,true,true,"","PowRescued == 0"];


if (isNil "IntelMap") then {IntelMap = EastInitOfficer};
if (isNil "AATaskComplete") then {AATaskComplete = true};
if (isNil "EnemyCamps") then {EnemyCamps = []};
if (isNil "BigEnemyCamps") then {BigEnemyCamps = []};
if (isNil "radioMSG") then {radioMSG = false};
if (isNil "PlayerDeath") then {PlayerDeath = 0};
if (isNil "POWRescued") then {POWRescued = 0;};
if (isNil "DeSpawnedInf") then {DeSpawnedInf = 0};
if (isNil "CSAR_Reinforce_InProgress") then {CSAR_Reinforce_InProgress = false};
if (isNil "CSAR_Reinforce_Time") then {CSAR_Reinforce_Time = -10000};
if (isNil "CSAR_Extract_Time") then {CSAR_Extract_Time = -10000};
if (isNil "CSAR_Extract_InProgress") then {CSAR_Extract_InProgress = false};
if (isNil "CSAR_Extract_Request") then {CSAR_Extract_Request = false};
if (isNil "CSAR_Extract_User") then {CSAR_Extract_User = nil};
if (isNil "CSAR_SetGroupLeader") then {CSAR_SetGroupLeader = nil};

failedMission = false;



if (isServer) then {
    //---Server only variables---
    [West,["POW"],["Rescue POW","Rescue POW",""],objNull,"Created",3,true] call BIS_fnc_taskCreate;
    [West,["Intel"],["Find Intel on POW","Find Intel",""],objNull,"Created",2,true] call BIS_fnc_taskCreate;
    [West,["AA"],["Destroy the 3 AA Sites","Destroy AA Sites",""],objNull,"Created",2,true] call BIS_fnc_taskCreate;

    EastArtilleryTimer = 0;
    EastParadropTimer = 0;
    DEBUG_GROUPREDUCE = false;
    DEBUG_WAYPOINTMARKERS = false;
    DeSpawnedInf = 0;
    WestHeliGuardGroups = [];

    POW setCaptive true; POW allowFleeing 0; removeAllWeapons POW; POW setBehaviour "Careless";
    [] execVM "CSAR_Init.sqf";
	[] execvm "EnemyCampInit.sqf";
	[] execVM "ContactFinder.sqf";
	[] execvm "convoy.sqf";
};

//This is all global
Radio9 = false;
RadioOperator = player;
RadioChat = "";
Skipradio = false;
if (!radioMSG) then {radio setpos [getpos table select 0,getpos table select 1,(getpos table select 2)+1.01];[] exec "radiomsg.sqs"; radioMSG = true;radio addaction ["<t color='#FF0000'>Change Radio Station</t>","changeradiostation.sqf",nil,0,true,true,"","true",2]};

setTerrainGrid 25;
_groundViewDist = 2500;
_flyingViewDist = 3200;
setViewDistance _groundViewDist;

sleep 2;

if (local player) then {player call CSAR_fnc_initSpawn;};

publicVariable "radioMSG";
gotIntel = false;
"powMarker" setMarkerPos [0,0];

if (isServer) then {["POW","Assigned"] call BIS_fnc_taskSetState};

if (local player) then {[player] execVM "Markers.sqf"};

orcaFuelMinute = 15 + random 10;

nearPOW = 0;



while {true} do {
    //Main loop for viewdistance, markers, etc and other things
    sleep 0.5;

    //Viewdist
   if ((getPos (vehicle player) select 2) > 20 && local player) then {setViewDistance _flyingViewDist};
   if ((getPos (vehicle player) select 2) < 20 && local player) then {setViewDistance _groundViewDist};

    //Adding actions for CAS
    if (CASChangeText && local player) then {
        if (alive player) then {
            CASChangeText = false;
            _str = format["<t color='#FF9000'>Open CAS Field System (%1)</t>",CASMissions - CASUsed];
            if (CASMissions - CASUsed > 0) then {player setUserActionText [PlayerCASActionID, _str]} else {player removeAction PlayerCASActionID};
        }
    };

    if (gotIntel && (getMarkerPos "powMarker" select 0) == 0) then {
        mod1 = 1;
        mod2 = 1;
        if (random 1 > 0.5) then {mod1 = -1};
        if (random 1 > 0.5) then {mod2 = -1};
        "powMarker" setMarkerPos [(getPos POWCamp select 0)  + (random 200 * mod1), (getPos POWCamp select 1)  + (random 200 * mod2)];
    };

    if (failedMission) then {
        failedMission = false;
        [] execVM "fail.sqf";
    };

    if (local player) then {
	
        if ((position player select 2) < 5 && player distance POW < 200 && nearPOW == 0) then {
            nearPOW = 1; publicVariable "nearPOW";
        };
		
        if ((player distance IntelMap < 3) && !gotIntel) then {
            ["Intel","SUCCEEDED"] call BIS_fnc_taskSetState;
            RadioOperator = player;
            publicVariable "RadioOperator";
            RadioChat = "Intel found! That gives us the approximate location of the POW.";
            publicVariable "RadioChat";
            gotIntel = true; publicVariable "gotIntel"
        };
    };




    if (RadioChat != "" && local player) then {RadioOperator sideChat RadioChat; RadioChat = ""};

    if (Radio9 && local player) then {Radio9 = false; player sideRadio "radio9"};

    if (isServer) then {
        //Check AA objective

        if (nearPOW == 1) then {
            if (random 1 > 0.85) then {[[(getPos POW select 0) + 50, getPos POW select 1, 0]] execVM "ParadropReinforcements.sqf";};
            nearPOW = 2; publicVariable "nearPOW";
        };

        //Check to rescue POW
        if (POWRescued == 1 && (!(isNil "POWRescuer"))) then {
            [West,["RTB"],["Return to Base","Return to Base",""],objNull,"Assigned",3,true] call BIS_fnc_taskCreate;
            if (alive POW) then {
                POWRescued = 2; publicVariable "POWRescued";
                ["POW","SUCCEEDED"] call BIS_fnc_taskSetState;
                //[POWRescuer] execVM "Rescue.sqf";
            } else {
                RadioOperator = POWRescuer; publicVariable "RadioOperator";
                RadioChat = "Goddamnit, the POW is dead. We need to return to base."; publicVariable "RadioChat";
                POWRescued = 3; publicVariable "POWRescued";
                ["POW","FAILED"] call BIS_fnc_taskSetState;
            };
        };
        if (POWRescued == 2 && (!alive POW)) then {
            POWRescued = 3; publicVariable "POWRescued";
            ["POW","FAILED"] call BIS_fnc_taskSetState;
        };
    };
};