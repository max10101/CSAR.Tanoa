CSAR_Debug = false;
call compile preprocessFile "Support\init.sqf";
RecoilFunction = compile preprocessFile "recoil.sqf";
blufor_fnc_initUnit = compile preprocessFile "blufor_fnc_initUnit.sqf";
opfor_fnc_initUnit = compile preprocessFile "opfor_fnc_initUnit.sqf";
opfor_fnc_initUnit2 = compile preprocessFile "opfor_fnc_initUnit2.sqf";

CSAR_CBA_fnc_taskDefend = compile preprocessFile "cba_fnc_taskDefend.sqf"; //cba function was broken
CSAR_CBA_fnc_taskPatrol = compile preprocessFile "cba_fnc_taskPatrol.sqf"; //not liking the addwaypoint feature so had to fix it myself
CSAR_CBA_fnc_addWaypoint = compile preprocessFile "cba_fnc_addwaypoint.sqf";

CSAR_fnc_SpawnCamps = compile preprocessFile "Spawncamps.sqf"; 
CSAR_fnc_Arsenal = compile preprocessFile "arsenalfnc.sqf"; 
CSAR_fnc_CampGun = compile preprocessFile "camp.sqf"; 
CSAR_NapalmExec = compileFinal "[_this,CSAR_NapalmTime,CSAR_NapalmSize] execvm ""Napalmnew.sqf""";

CSAR_fnc_Arsenal = compile preprocessFile "arsenalfnc.sqf"; 
CSAR_BanditGroup = ["I_C_Soldier_Bandit_2_F","I_C_Soldier_Bandit_4_F","I_C_Soldier_Bandit_1_F","I_C_Soldier_Bandit_7_F","I_C_Soldier_Bandit_5_F","I_C_Soldier_Bandit_8_F","I_C_Soldier_Bandit_3_F","I_C_Soldier_Bandit_6_F","I_C_Soldier_Bandit_2_F"];
CSAR_ParaGroup = ["I_C_Soldier_Para_2_F","I_C_Soldier_Para_4_F","I_C_Soldier_Para_1_F","I_C_Soldier_Para_7_F","I_C_Soldier_Para_5_F","I_C_Soldier_Para_8_F","I_C_Soldier_Para_3_F","I_C_Soldier_Para_6_F","I_C_Soldier_Para_2_F"];

CSAR_BanditGroupSmall = ["I_C_Soldier_Bandit_4_F","I_C_Soldier_Bandit_3_F","I_C_Soldier_Bandit_5_F","I_C_Soldier_Bandit_1_F"];
CSAR_ParaGroupSmall = ["I_C_Soldier_Para_4_F","I_C_Soldier_Para_3_F","I_C_Soldier_Para_5_F","I_C_Soldier_Para_1_F"];


BIS_Effects_Burn=compile preprocessFileLineNumbers "burn.sqf";
PlayMoveMP = compileFinal "_this select 0 PlayMove (_this select 1);";
switchMoveMP = compileFinal "_this select 0 switchMove (_this select 1);";

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

        if (!(isPlayer (leader group _unit))) then {
            if (local (leader group _unit)) then {
                (group _unit) selectLeader _unit;
            } else {
                [group _unit, _unit] remoteExec ["selectLeader", leader group _unit];
            };
         };
		 
        [_unit] execVM "Support\addActions.sqf";
    };';

	
// Random not so important variables

Endgame = false;
CSAR_ContactAreaSize = 150;
CSAR_ContactArray = [];
CSAR_NapalmSize = 40;
CSAR_NapalmTime = 50;

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

wcweather = [0, [0,0,0], 0, [random 3, random 3, true], date];
EastArtilleryTimer = 0;
EastParadropTimer = 0;
DEBUG_GROUPREDUCE = false;
DEBUG_WAYPOINTMARKERS = false;
DeSpawnedInf = 0;
WestHeliGuardGroups = [];
CSAR_HCPresent = false;
CSAR_HCHint = "Headless Client";
orcaFuelMinute = 15 + random 10;
nearPOW = 0;
Radio9 = false;
RadioOperator = player;
RadioChat = "";
Skipradio = false;
failedMission = false;
_groundViewDist = 1800;
_flyingViewDist = 3000;

//Variables that should probably be set this way for JIP compatibility
if (isNil "IntelMap") then {IntelMap = EastInitOfficer};
if (isNil "AATaskComplete") then {AATaskComplete = false};
if (isNil "EnemyCamps") then {EnemyCamps = []};
if (isNil "BigEnemyCamps") then {BigEnemyCamps = []};
if (isNil "radioMSG") then {radioMSG = false};
if (isNil "FindPOW") then {FindPOW = false};
if (isNil "FindIntel") then {FindIntel = false};
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

//Scripts/actions to exec on all machines
setViewDistance _groundViewDist;
setTerrainGrid 25;
[] execVM "CSAR_Respawn.sqf";
[] execVM "real_weather.sqf";
POWAction = POW addaction ["<t color='#FF0000'>Rescue POW</t>","FreePow.sqf",nil,0,true,true,"","PowRescued == 0"];
if (!radioMSG) then {radio setpos [getpos table select 0,getpos table select 1,(getpos table select 2)+1.01];[] exec "radiomsg.sqs"; radioMSG = true;radio addaction ["<t color='#FF0000'>Change Radio Station</t>","changeradiostation.sqf",nil,0,true,true,"","true",2]};
[crashedheli, 6, time, false, true] spawn BIS_Effects_Burn;

//exec for all units as it runs depending on whose the owner
[] execVM "CSAR_Init.sqf";

    //---Server only variables---
if (isServer) then {
    [West,["POW"],["Rescue POW","Rescue POW",""],objNull,"Created",3,true] call BIS_fnc_taskCreate;
	[West,["FindIntel"],["Find Intelligence on enemy forces","Find Intel",""],objNull,"Created",2,true] call BIS_fnc_taskCreate;
    [West,["FindPOW"],["Find Location of the POW","Find POW",""],objNull,"Created",2,true] call BIS_fnc_taskCreate;
    [West,["AA"],["Destroy the AA Site","Destroy AA Site",""],objNull,"Created",2,true] call BIS_fnc_taskCreate;
    POW setCaptive true; POW allowFleeing 0; removeAllWeapons POW; POW setBehaviour "Careless";
	"POWMarker" setMarkerPos [0,0];
	"IntelMarker" setMarkerPos [0,0];
	};

/////////////////////////////////
// HEADLESS CLIENT IMPLEMENTATION
/////////////////////////////////

IF (IsNil "CSAR_HC1") then {CSAR_HC1 = ResInitOfficer;CSAR_HCHint = "Server";publicvariable "CSAR_HCHint";};
IF (IsServer && (Local CSAR_HC1)) then {CSAR_HCHint = "Server";publicvariable "CSAR_HCHint";};
IF (Local CSAR_HC1) then {
	//scripts offloaded onto headless client (or server if he isn't there)
	[] execvm "EnemyCampInit.sqf";
	[] execVM "ContactFinder.sqf";
	[] execvm "convoy.sqf";
};



//FIRST WAIT

sleep 2;
bis_revive_bleedOutDuration = 60*15;
if (local player && HasInterface) then {player call CSAR_fnc_initSpawn;};

publicVariable "radioMSG";


if (local player && HasInterface) then {[player] execVM "Markers.sqf"};

//fogcheck loop separate code spawn
_fogcheck = [] spawn {
	While {true} do {
		IF ((fogparams select 0) > (((wcweather select 1) select 0)+0.05)) then {60 setfog (wcweather select 1);sleep 60};
		sleep 20;
	};
};
    //Main loop for viewdistance, markers, etc and other things
while {true} do {
    sleep 0.5;
    if (failedMission) ExitWith {
        failedMission = false;
        [] execVM "fail.sqf";
    };


	
	/////////////////////////////////////////////////////////////////////////////////////
	//PLAYER ONLY CHECKS
    if (local player && HasInterface) then {
	
	    if (CASChangeText) then {
			if (alive player) then {
				CASChangeText = false;
				_str = format["<t color='#FF9000'>Open CAS Field System (%1)</t>",CASMissions - CASUsed];
				if (CASMissions - CASUsed > 0) then {player setUserActionText [PlayerCASActionID, _str]} else {player removeAction PlayerCASActionID};
			}
		};
	
		if ((getPos (vehicle player) select 2) > 20) then {setViewDistance _flyingViewDist};
		if ((getPos (vehicle player) select 2) < 20) then {setViewDistance _groundViewDist};
	
        if ((position player select 2) < 5 && player distance POW < 200 && nearPOW == 0) then {
            nearPOW = 1; publicVariable "nearPOW";
        };
		
        if ((player distance IntelMap < 3) && !FindPOW) then {
            RadioOperator = player;
            publicVariable "RadioOperator";
            RadioChat = "Intel found! That gives us the approximate location of the POW.";
            publicVariable "RadioChat";
            FindPOW = true; publicVariable "FindPOW"
        };
		
		if (RadioChat != "") then {RadioOperator sideChat RadioChat; RadioChat = ""};
		if (Radio9) then {Radio9 = false; player sideRadio "radio9"};
    };
	
	/////////////////////////////////////////////////////////////////////////////////////
	//SERVER ONLY CHECKS
	if (isServer) then {
		//Check AA objective
		if (!alive AAGun1 && !alive AAGun2 && !alive AAGun3 && !AATaskComplete) then {
			AATaskComplete = true; publicVariable "AATaskComplete";
			["AA","SUCCEEDED"] call BIS_fnc_taskSetState;
		};
		
		if (FindPOW && (getMarkerPos "POWMarker" select 0) == 0) then {
			["FindPOW","SUCCEEDED"] call BIS_fnc_taskSetState;
			mod1 = 1;
			mod2 = 1;
			if (random 1 > 0.5) then {mod1 = -1};
			if (random 1 > 0.5) then {mod2 = -1};
			"POWMarker" setMarkerPos [(getPos POWCamp select 0)  + (random 200 * mod1), (getPos POWCamp select 1)  + (random 200 * mod2)];
		};
	
		if (FindIntel && (getMarkerPos "IntelMarker" select 0) == 0) then {
			["FindIntel","SUCCEEDED"] call BIS_fnc_taskSetState;
			mod1 = 1;
			mod2 = 1;
			if (random 1 > 0.5) then {mod1 = -1};
			if (random 1 > 0.5) then {mod2 = -1};
			"IntelMarker" setMarkerPos [(getPos IntelMap select 0)  + (random 50 * mod1), (getPos IntelMap select 1)  + (random 50 * mod2)];
		};

        if (nearPOW == 1) then {
            if (random 1 > 0) then {[[(getPos POW select 0) + 50, getPos POW select 1, 0]] execVM "ParadropReinforcements.sqf";};
            nearPOW = 2; publicVariable "nearPOW";
        };

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
