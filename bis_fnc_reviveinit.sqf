#include "defines.inc"
/*
	Author: Jiri Wainar

	Description:
	Initialize the Revive system on all machines.

	Returns:
	True if successful, false if not.
*/

#define DEBUG_LOG	bis_fnc_logFormat

//load 'mode' but prioritize the server param
private _paramMode = missionNamespace getVariable["bis_reviveParam_mode",-100];
private _mode = if (_paramMode == -100) then {getMissionConfigValue ["ReviveMode",REVIVE_MODE_DISABLED]} else {_paramMode};

//compatability fix for Revive2 settings (based on respawn templates)
if (_mode == REVIVE_MODE_DISABLED) then
{
	private _templates = [];

	{
		_templates append (getArray (missionConfigFile >> ("respawnTemplates" + _x)));
	}
	forEach ([""] + REVIVE_SIDES_TXT);

	if ({_x == "Revive"} count _templates > 0) then {_mode = REVIVE_MODE_AUTODETECT};
};

//exit if not in the multiplayer game
if (!IS_MP || {_mode == REVIVE_MODE_DISABLED}) exitWith {};

//[call] add public variable event handler (localy) to the given player
bis_fnc_reviveInitAddPlayer =
{
	if (!REVIVE_ENABLED(player)) exitWith {};

	private["_units","_unitVar","_xUnitVar"];

	if (isNil "bis_revive_handledUnits") then
	{
		bis_revive_handledUnits = [];
	};

	if (count _this == 0) then
	{
		_units = [] call bis_fnc_listPlayers;
	}
	else
	{
		_unitVar = param [0,"",[""]];
		_units = [missionNamespace getVariable [_unitVar,objNull]];

		if ((player getVariable [VAR_TRANSFER_STATE, STATE_RESPAWNED]) == STATE_INCAPACITATED) then		//we don't know the STATE yet, need to use VAR_TRANSFER_STATE
		{
			//["[x] Incapacitated unit '%1' will NOT collide with JIPed unit '%2'.",player,_unitVar] call DEBUG_LOG;

			player disableCollisionWith GET_UNIT(_unitVar);
		};
	};

	_units = _units - [player,objNull];

	{
		_xUnitVar = _x call bis_fnc_objectVar;

		if !(_xUnitVar in bis_revive_handledUnits) then
		{
			bis_revive_handledUnits pushBackUnique _xUnitVar;

			["[ ] Unit '%1' registered.",_xUnitVar] call DEBUG_LOG;

			//add event handler for monitoring player's state by other players
			VAR_TRANSFER_STATE addPublicVariableEventHandler [_x,
			{
				_this call bis_fnc_reviveOnState;
			}];

			//add event handler for monitoring player's 'forcing respawn' flag by other players
			VAR_TRANSFER_FORCING_RESPAWN addPublicVariableEventHandler [_x,
			{
				_this call bis_fnc_reviveOnForcingRespawn;
			}];

			//add event handler for monitoring player's 'being revived' flag by other players
			VAR_TRANSFER_BEING_REVIVED addPublicVariableEventHandler [_x,
			{
				_this call bis_fnc_reviveOnBeingRevived;
			}];
		};
	}
	forEach _units;
};

//[call] remove player from array of handled units
bis_fnc_reviveInitRemovePlayer =
{
	private _t = diag_tickTime + 5;
	private _disconnected = param [0,"",[""]];

	waitUntil{!isNil "bis_revive_handledUnits" || {diag_tickTime > _t}};

	["[ ] Un-registered disconnected unit: %1",_disconnected] call DEBUG_LOG;

	if !(isNil "bis_revive_handledUnits") then
	{
		bis_revive_handledUnits = bis_revive_handledUnits - [_disconnected];
	};

	if !(isNil "bis_revive_incapacitatedUnits") then
	{
		bis_revive_incapacitatedUnits = bis_revive_incapacitatedUnits - [_disconnected];
	};

	missionNamespace setVariable [_disconnected, nil];
};

if (isServer) then
{
	//["[ ] CLEARING DEBUGVIEW: %1","DBGVIEWCLEAR"] call DEBUG_LOG;

	bis_revive_ratioLethal = createAgent ["Logic", [10,10,0], [], 0, "CAN_COLLIDE"];
	bis_revive_ratioSoft = createAgent ["Logic", [10,10,0], [], 0, "CAN_COLLIDE"];
	bis_revive_dmgPerSelection = createAgent ["Logic", [10,10,0], [], 0, "CAN_COLLIDE"];

	publicVariable "bis_revive_ratioLethal";
	publicVariable "bis_revive_ratioSoft";
	publicVariable "bis_revive_dmgPerSelection";

	//handle disconnect
	addMissionEventHandler ["HandleDisconnect",
	{
		_playerVar = [_this select 0] call bis_fnc_objectVar;
		[_playerVar] remoteExec ["bis_fnc_reviveInitRemovePlayer"];
	}];
};

//exit if dedicated server, headless client or spectator detected
if (!hasInterface || {side player == sideLogic}) exitWith {};

//make sure player exists
if (isNull player) then {waitUntil{!isNull player}};

//exit if spectator is detected
if (side player == sideLogic) exitWith {};

//autodetect individual settings; Revive2 compatability feature
if (_mode == REVIVE_MODE_AUTODETECT) then
{
	//check global respawn templates
	private _templates = getArray (missionConfigFile >> "respawnTemplates");
	if ({_x == "Revive"} count _templates > 0) exitWith {_mode = REVIVE_MODE_ENABLED_ALL_PLAYERS};

	//not in global respawn templates, it needs to be in the side specific respawn templates
	_mode = REVIVE_MODE_ENABLED_INDIVIDUAL_PLAYERS;

	//check side specific respawn templates
	private _sideIndex = REVIVE_SIDES find (side player);
	if (_sideIndex == -1) exitWith {};
	private _sideTxt = REVIVE_SIDES_TXT select _sideIndex;
	_templates = getArray (missionConfigFile >> ("respawnTemplates" + _sideTxt));
	if ({_x == "Revive"} count _templates > 0) exitWith {ENABLE_REVIVE(player,true)};
};

//enable revive for player if its enabled globaly
if (_mode == REVIVE_MODE_ENABLED_ALL_PLAYERS) then
{
	ENABLE_REVIVE(player,true);
};

if (!REVIVE_ENABLED(player)) exitWith {["[ ] Revive is NOT enabled for player: %1",player] call DEBUG_LOG;};

["[ ] Revive is enabled for player: %1",player] call DEBUG_LOG;

//get unique player variable
private _playerVar = GET_UNIT_VAR(player);

//global variables used in the system locally (not broadcasted)
bis_revive_handledUnits = [];					//variable names of units covered by the revive system; units with disabled revive excluded
bis_revive_incapacitatedUnits = [];				//variable names of units that are waiting for revive
bis_revive3d_unitsToProcess = [];				//variable names of units that need to be pre-processed for draw 3d
bis_revive3d_unitsPreprocessed = [];				//variable names of units that were preprocessed for draw 3d
bis_revive3d_fadeMult = ICON_ALPHA / (ICON_VISIBLE_RANGE_MAX - ICON_VISIBLE_RANGE);

//init UI timers for drawn icon and hold action icons
bis_revive_timer = 0;
bis_revive_timerCounter2 = 0;
bis_revive_timerCounter3 = 0;

//prepare idle textures for drawn icon and hold action icons
TEXTURES_2D_DYING = []; {TEXTURES_2D_DYING pushBack TEMPLATE_2D(_x);} forEach SEQUENCE12_DYING;
TEXTURES_2D_BEING_REVIVED = []; {TEXTURES_2D_BEING_REVIVED pushBack TEMPLATE_2D(_x);} forEach SEQUENCE12_BEING_REVIVED;
TEXTURES_2D_UNCONSCIOUS = []; {TEXTURES_2D_UNCONSCIOUS pushBack TEMPLATE_2D(_x);} forEach SEQUENCE12_UNCONSCIOUS;

TEXTURES_3D_DYING = []; {TEXTURES_3D_DYING pushBack TEMPLATE_3D(_x);} forEach SEQUENCE12_DYING;
TEXTURES_3D_BEING_REVIVED = []; {TEXTURES_3D_BEING_REVIVED pushBack TEMPLATE_3D(_x);} forEach SEQUENCE12_BEING_REVIVED;
TEXTURES_3D_UNCONSCIOUS = []; {TEXTURES_3D_UNCONSCIOUS pushBack TEMPLATE_3D(_x);} forEach SEQUENCE12_UNCONSCIOUS;
TEXTURES_3D_DEAD = []; {TEXTURES_3D_DEAD pushBack TEMPLATE_3D(_x);} forEach SEQUENCE12_DEAD;
TEXTURES_3D_FORCING_RESPAWN = []; {TEXTURES_3D_FORCING_RESPAWN pushBack TEMPLATE_3D(_x);} forEach SEQUENCE12_FORCING_RESPAWN;

TEXTURES_3D_GROUP_DYING = []; {TEXTURES_3D_GROUP_DYING pushBack TEMPLATE_3D_GROUP(_x);} forEach SEQUENCE12_DYING;
TEXTURES_3D_GROUP_BEING_REVIVED = []; {TEXTURES_3D_GROUP_BEING_REVIVED pushBack TEMPLATE_3D_GROUP(_x);} forEach SEQUENCE12_BEING_REVIVED;
TEXTURES_3D_GROUP_UNCONSCIOUS = []; {TEXTURES_3D_GROUP_UNCONSCIOUS pushBack TEMPLATE_3D_GROUP(_x);} forEach SEQUENCE12_UNCONSCIOUS;
TEXTURES_3D_GROUP_DEAD = []; {TEXTURES_3D_GROUP_DEAD pushBack TEMPLATE_3D_GROUP(_x);} forEach SEQUENCE12_DEAD;
TEXTURES_3D_GROUP_FORCING_RESPAWN = []; {TEXTURES_3D_GROUP_FORCING_RESPAWN pushBack TEMPLATE_3D_GROUP(_x);} forEach SEQUENCE12_FORCING_RESPAWN;

//create PP effects
bis_revive_ppColor = ppEffectCreate ["ColorCorrections", 1632];
bis_revive_ppVig = ppEffectCreate ["ColorCorrections", 1633];
bis_revive_ppBlur = ppEffectCreate ["DynamicBlur", 525];

//init missin specific revive settings
bis_revive_mode = _mode;
bis_revive_requiredTrait = if ((missionNamespace getVariable["bis_reviveParam_requiredTrait",-100]) == -100) then {getMissionConfigValue ["ReviveRequiredTrait",0]} else {missionNamespace getVariable["bis_reviveParam_requiredTrait",-100]};
bis_revive_requiredItems = if ((missionNamespace getVariable["bis_reviveParam_requiredItems",-100]) == -100) then {getMissionConfigValue ["ReviveRequiredItems",0]} else {missionNamespace getVariable["bis_reviveParam_requiredItems",-100]};

//shall the FAK be consumed upon successful revive?
bis_revive_requiredItemsFakConsumed = if ((missionNamespace getVariable["bis_reviveParam_requiredItemsFakConsumed",-100]) == -100) then
{
	private _configValue = getMissionConfigValue ["ReviveRequiredItemsFakConsumed",1];

	if (_configValue isEqualType true) then {_configValue} else {_configValue == 1};
}
else
{
	bis_reviveParam_requiredItemsFakConsumed == 1
};

bis_revive_medicSpeedMultiplier = if ((missionNamespace getVariable["bis_reviveParam_medicSpeedMultiplier",-100]) == -100) then {getMissionConfigValue ["ReviveMedicSpeedMultiplier",2]} else {missionNamespace getVariable["bis_reviveParam_medicSpeedMultiplier",-100]};
bis_revive_unconsciousStateMode = if ((missionNamespace getVariable["bis_reviveParam_unconsciousStateMode",-100]) == -100) then {getMissionConfigValue ["ReviveUnconsciousStateMode",0]} else {missionNamespace getVariable["bis_reviveParam_unconsciousStateMode",-100]};
bis_revive_duration = if ((missionNamespace getVariable["bis_reviveParam_duration",-100]) == -100) then {getMissionConfigValue ["ReviveDelay",DEFAULT_REVIVE_TIME]} else {missionNamespace getVariable["bis_reviveParam_duration",-100]};
bis_revive_bleedOutDuration = if ((missionNamespace getVariable["bis_reviveParam_bleedOutDuration",-100]) == -100) then {getMissionConfigValue ["ReviveBleedOutDelay",DEFAULT_BLEEDOUT_TIME]} else {missionNamespace getVariable["bis_reviveParam_bleedOutDuration",-100]};
bis_revive_forceRespawnDuration = if ((missionNamespace getVariable["bis_reviveParam_forceRespawnDuration",-100]) == -100) then {getMissionConfigValue ["ReviveForceRespawnDelay",DEFAULT_FORCE_RESPAWN_TIME]} else {missionNamespace getVariable["bis_reviveParam_forceRespawnDuration",-100]};

if (bis_revive_forceRespawnDuration <= 0) then {bis_revive_forceRespawnDuration = DEFAULT_FORCE_RESPAWN_TIME};
if (bis_revive_bleedOutDuration <= 0) then {bis_revive_bleedOutDuration = DEFAULT_BLEEDOUT_TIME};
if (bis_revive_duration <= 0) then {bis_revive_duration = DEFAULT_REVIVE_TIME};
bis_revive_durationMedic = bis_revive_duration / bis_revive_medicSpeedMultiplier;

//setup damage model data structure
if ({isNil _x} count [{RATIO_LETHAL},{RATIO_SOFT},{SELECTION_DAMAGE}] > 0) then
{
	waitUntil{{isNil _x} count [{RATIO_LETHAL},{RATIO_SOFT},{SELECTION_DAMAGE}] == 0};
};

private _unconsciousStateMode = UNCONSCIOUS_MODES select bis_revive_unconsciousStateMode;
private _cfg = configfile >> "CfgRevive" >> "UnconsciousStateModes" >> _unconsciousStateMode;

bis_revive_dmgSelectionNames = getAllHitPointsDamage player select 1;
bis_revive_thresholdSoft = getNumber(_cfg >> "thresholdSoft");
bis_revive_thresholdLethal = getNumber(_cfg >> "thresholdLethal");

{
	getArray(_cfg >> _x >> "severity") call
	{
		params [["_ratioSoft",1,[123]],["_ratioLethal",1,[123]]];
		SET_RATIO_LETHAL(_x, _ratioLethal);
		SET_RATIO_SOFT(_x, _ratioSoft);
	};

	SET_SELECTION_DAMAGE(_x, 0);
}
forEach bis_revive_dmgSelectionNames;

//init & reset damage data
[] call bis_fnc_reviveDamageReset;

//register everyone localy to player
[] call bis_fnc_reviveInitAddPlayer;

//register player to everyone ingame
[_playerVar] remoteExec ["bis_fnc_reviveInitAddPlayer"];

//setup other players localy for JIPing player; didJIP condition removed to make the code more robust
{
	private _xUnit = GET_UNIT(_x);

	[VAR_TRANSFER_STATE, _xUnit getVariable [VAR_TRANSFER_STATE, STATE_RESPAWNED], _xUnit] call bis_fnc_reviveOnStateJIP;
	[VAR_TRANSFER_FORCING_RESPAWN, _xUnit getVariable [VAR_TRANSFER_FORCING_RESPAWN, false], _xUnit] call bis_fnc_reviveOnForcingRespawn;
	[VAR_TRANSFER_BEING_REVIVED, _xUnit getVariable [VAR_TRANSFER_BEING_REVIVED, false], _xUnit] call bis_fnc_reviveOnBeingRevived;
}
forEach bis_revive_handledUnits;

//setup and store 'HandleDamage' event handler
private _ehHandleDamage = if (bis_revive_unconsciousStateMode == 0) then
{
	GET_UNIT(_playerVar) addEventHandler ["HandleDamage",bis_fnc_reviveOnPlayerHandleDamageBasic];
}
else
{
	GET_UNIT(_playerVar) addEventHandler ["HandleDamage",bis_fnc_reviveOnPlayerHandleDamage];
};
GET_UNIT(_playerVar) setVariable ["bis_revive_ehDamage", _ehHandleDamage];

//setup and store 'HandleHeal' event handler
private _ehHandleHeal = GET_UNIT(_playerVar) addEventHandler ["HandleHeal",bis_fnc_reviveOnPlayerHandleHeal];
GET_UNIT(_playerVar) setVariable ["bis_revive_ehHeal", _ehHandleHeal];

//setup and store 'Killed' event handler
private _ehKilled = GET_UNIT(_playerVar) addEventHandler ["Killed",bis_fnc_reviveOnPlayerKilled];
GET_UNIT(_playerVar) setVariable ["bis_revive_ehKilled", _ehKilled];

//setup and store 'Respawn' event handler
private _ehRespawn = GET_UNIT(_playerVar) addEventHandler ["Respawn",bis_fnc_reviveOnPlayerRespawn];
GET_UNIT(_playerVar) setVariable ["bis_revive_ehRespawn", _ehRespawn];


/*--------------------------------------------------------------------------------------------------

	ICONS & TRANSITION ANIMATIONS (for 3d icons and hold actions)

--------------------------------------------------------------------------------------------------*/

[] spawn
{
	scriptName "bis_fnc_reviveInit: timer counter";

	while {true} do
	{
		sleep 0.065;

		bis_revive_timer = (bis_revive_timer + 1) % 12;

		if (bis_revive_timer == 0) then
		{
			bis_revive_timerCounter2 = (bis_revive_timerCounter2 + 1) % 2;
			bis_revive_timerCounter3 = (bis_revive_timerCounter3 + 1) % 3;
		};
	};
};


/*--------------------------------------------------------------------------------------------------

	DRAW 3D ICONS

--------------------------------------------------------------------------------------------------*/
if (difficultyOption "groupIndicators" == 0) exitWith {};

//prepare and sort the data
[] spawn
{
	scriptName "bis_fnc_reviveInit: 3d icons data preprocess";

	private ["_unitsEvaluated","_unit","_groupUnit","_sideUnit","_reviveAllowed"];

	private _distanceNoIconZone = (ICON_VISIBLE_RANGE_MAX ^ 2) * 2;

	while {true} do
	{
		_unitsEvaluated = [];

		if (count bis_revive3d_unitsToProcess == 0) then
		{
			//nothing should be drawn if there are no units to process
			bis_revive3d_unitsPreprocessed = [];

			waitUntil
			{
				sleep 0.1;
				count bis_revive3d_unitsToProcess > 0
			};
		};

		private _groupPlayer = group player;
		private _sidePlayer = side _groupPlayer;

		//predetect if player can perform revive action, so we don't need to check it in the draw frame
		_reviveAllowed = REVIVE_ALLOWED(player);

		{
			sleep 0.01;

			_unit = GET_UNIT(_x);
			_groupUnit = group _unit;
			_sideUnit = side _groupUnit;

			if (_sidePlayer getFriend _sideUnit >= 0.6 && {_sideUnit getFriend _sidePlayer >= 0.6}) then
			{
				if (_unit distanceSqr player > _distanceNoIconZone) exitWith {};

				if (IS_FORCING_RESPAWN(_unit) || {!_reviveAllowed || {!alive _unit || {IS_BEING_REVIVED(_unit)}}}) then
				{
					_unit setVariable [VAR_ICON_COLOR,ICON_COLOR_DISABLED];
					_unit setVariable [VAR_ICON_IS_ACTIVE,false];
				}
				else
				{
					_unit setVariable [VAR_ICON_COLOR,ICON_COLOR_ACTIVE];
					_unit setVariable [VAR_ICON_IS_ACTIVE,true];

				};

				//not needed now
				//_unit setVariable [VAR_ICON_IN_GROUP,_groupPlayer == _groupUnit];

				//preselect the 3d textures icon set
				_unit call bis_fnc_reviveGet3dIcons;

				_unitsEvaluated pushBackUnique _unit;
			};
		}
		forEach bis_revive3d_unitsToProcess;

		bis_revive3d_unitsPreprocessed =+ _unitsEvaluated;
	};
};


//draw 3D icons: drawIcon3D [texture, color, pos, width, height, angle, text, shadow, textSize, font, textAlign, drawSideArrows]
addMissionEventHandler ["Draw3D",
{
	//do not show icons if player is dead or unconscious
	if (IS_ACTIVE(player)) then
	{
		private ["_dist","_color","_alpha","_pos"];

		{
			if (!alive _x || {lifeState _x == 'INCAPACITATED'}) then
			{
				//exit if outside of the draw range
				_dist = player distance _x;
				if (_dist > ICON_VISIBLE_RANGE_MAX) exitWith {};

				//do not show icon if player has user action available
				if ([_x] call bis_fnc_reviveIsValid) exitWith {};

				//get icon color and fade it with the distance
				_color = _x getVariable [VAR_ICON_COLOR,ICON_COLOR_UNCONSCIOUS];
				if (_dist > ICON_VISIBLE_RANGE) then {_color set [3, 0 max (ICON_ALPHA - ((_dist - ICON_VISIBLE_RANGE) * bis_revive3d_fadeMult))];};

				//get the draw position
				_pos = unitAimPositionVisual _x;

				//draw the sh1t
				drawIcon3D
				[
					(_x getVariable ["bis_fnc_reviveGet3dIcons_textures",TEXTURES_3D_UNCONSCIOUS]) select bis_revive_timer,
					_color,
					_pos,
					ICON_SIZE,
					ICON_SIZE,
					0,
					"",
					2,
					0,
					"PuristaMedium",
					"center",
					_x getVariable [VAR_ICON_IS_ACTIVE,true]
				];
			};
		}
		forEach bis_revive3d_unitsPreprocessed;
	};
}];