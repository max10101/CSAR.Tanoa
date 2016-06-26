_vehicle = _this select 0;
IF ((!local _vehicle) OR (Isplayer (driver _vehicle)) OR (player in (crew _vehicle))) ExitWith {};
_part = _this select 1;
_damage = _this select 2;
_timetofix = 60;
_ct = true;
IF (!Canmove _vehicle) then {_ct = false};
player sidechat format ["HIT %1",_damage];
IF ((["wheel",_part,false] call BIS_fnc_inString) && (_damage >= 0.97) && (count crew _vehicle >= 1) && _ct) then {

_FixWP = [(group driver _vehicle),(getpos _vehicle)] call CSAR_fnc_InjectWP;
_FixWP setwaypointtimeout [_timetofix,_timetofix,_timetofix];
_crew = crew _vehicle;
_crew ordergetin false;
sleep (_timetofix - 1);
IF (! Canmove _Vehicle ) Exitwith {player sidechat "LEAVING VEH BEHIND"};
_vehicle setdamage (damage _vehicle);
player sidechat "FIXED";
_crew ordergetin true;

};