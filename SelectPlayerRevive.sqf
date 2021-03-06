// extract from bis_fnc_reviveinit since using selectplayer would break BIS revive functions
// USAGE :  execute locally (no params) after a player switches into a new unit using selectplayer
// DOES NOT NEED TO BE EXECUTED IF PLAYER JUST RESPAWNS AT BASE - vars and EH's seem to carry over if that's the case
// todo : remove old bis eventhandlers if they exist (would they even? meh), not sure if JIP section is required
diag_log "SELECTPLAYER BEGIN";
WaitUntil {Alive Player};
sleep 0.5;
IF (count (waypoints (group player)) > 0) then {deletewaypoint [(group player),0]}; 
IF ((count allPlayers) <= 1) exitwith {Systemchat "No other players - Revive disabled"};
diag_log "SELECTPLAYER add defines";
#include "defines.hpp"
diag_log "SELECTPLAYER setvariable";
player setvariable ["#rev_enabled",true,true];
private _playerVar = GET_UNIT_VAR(player);
//init & reset damage data
diag_log "SELECTPLAYER call damagereset";
[] call bis_fnc_reviveDamageReset;

//register everyone localy to player
diag_log "SELECTPLAYER call initaddplayer";
[] call bis_fnc_reviveInitAddPlayer;

//register player to everyone ingame
diag_log "SELECTPLAYER remoteexec";
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

diag_log "SELECTPLAYER finished";
/*
{
	private _xUnit = GET_UNIT(_x);

	[VAR_TRANSFER_STATE, _xUnit getVariable [VAR_TRANSFER_STATE, STATE_RESPAWNED], _xUnit] call bis_fnc_reviveOnStateJIP;
	[VAR_TRANSFER_FORCING_RESPAWN, _xUnit getVariable [VAR_TRANSFER_FORCING_RESPAWN, false], _xUnit] call bis_fnc_reviveOnForcingRespawn;
	[VAR_TRANSFER_BEING_REVIVED, _xUnit getVariable [VAR_TRANSFER_BEING_REVIVED, false], _xUnit] call bis_fnc_reviveOnBeingRevived;
}
forEach bis_revive_handledUnits;


//setup and store 'HandleDamage' event handler
private _ehHandleDamage = GET_UNIT(_playerVar) addEventHandler ["HandleDamage",bis_fnc_reviveOnPlayerHandleDamage];
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
*/