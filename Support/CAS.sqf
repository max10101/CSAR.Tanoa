private ["_velocityZ"];

if (CASInProgress) exitWith {player groupchat "CAS already enroute, cancel current CAS or wait for bomb drop before next request!"};

if (!AATaskComplete && !DEBUG_aatask) exitWith {player groupchat "AA site is still up! CAS can't be called."};

CASInProgress = true;
publicVariable "CASInProgress";

_object = _this select 0;
_casType = _this select 1;
_CASTargetMarker = _this select 2;
_basePos = _this select 3;
_lockedOnVeh = _this select 4;
_doSnap = _this select 5;
_loc = getMarkerPos _CASTargetMarker;


_lockedOn = false;

_lockobj = createAgent ["Logic", [(_loc select 0), (_loc select 1), 0], [] , 0 , "CAN_COLLIDE"];
_lockobj setPos _loc;
if (!isNull _lockedOnVeh && _doSnap) then {_lockedOn = true} else {_lockedOnVeh = _lockobj;_lockedOn = true};

_lock = getPosASL _lockobj select 2;

_loc = visiblePosition _lockobj;

_ranPos = _basePos;

_grp = createGroup west;
_buzzType = "B_Plane_CAS_01_F";
_buzzSpeed = 200;
_buzzFlyHeight = 300;
if (_casType == "CAS") then {
  _buzzType = "B_Heli_Attack_01_F";
  _buzzSpeed = 100;
  _buzzFlyHeight = 110;
};
_buzz = createVehicle [_buzzType, [_ranPos select 0, _ranPos select 1, 260], [], 0, "FLY"];
_buzz addEventHandler ["dammaged", {_this execVM "HelicopterEmergency.sqf"}];
createVehicleCrew _buzz;
[_buzz] execVM "Support\track.sqf";
_dir = [_loc, _ranPos] call compile preprocessFile "FindAngle.sqf";
_buzz setDir _dir;
_buzz setVelocity [sin(_dir)*_buzzSpeed,cos(_dir)*_buzzSpeed,0];
_buzz flyInheight _buzzFlyHeight;
[driver _buzz] join _grp;

RadioOperator = leader _grp; publicVariable "RadioOperator";
RadioChat = "Cordinates recieved, CAS inbound"; publicVariable "RadioChat";

leader _grp setBehaviour "CARELESS";
leader _grp setSpeedMode "FULL";
leader _grp setCombatMode "BLUE";
leader _grp  disableAI "AUTOTARGET";
leader _grp disableAI "TARGET";

if (_casType == "CAS") then {
	_wp =_grp addWaypoint [_loc, 200];
  _wp setWaypointType"SAD";
} else {
	(driver _buzz) doMove _loc;
};


doCounterMeasure =
{
  _plane = _this select 0;
  for "_i" from 1 to 4 do
  {
    _bool = _plane fireAtTarget [_plane,"CMFlareLauncher"];
    sleep 0.3;
  };
  sleep 3;
  _plane = _this select 0;
  for "_i" from 1 to 4 do
  {
    _bool = _plane fireAtTarget [_plane,"CMFlareLauncher"];
    sleep 0.3;
  };
};
_movePos = [0,0,0];
while {true} do
{
  if (_lockedOn) then {
    //Means a vehicle is locked - abort if the vehicle is destroyed
    "CAS_TARGET" setMarkerPos (getPos _lockedOnVeh);
    if (_movePos distance _lockedOnVeh > 30) then {_movePos = getPos _lockedOnVeh; _buzz doMove _movePos};
    if (!alive _lockedOnVeh) then {CASAbort = true};
    if (_buzz distance _lockedOnVeh <= 660) exitWith {};
  };
  _minDist = 660;
  if (_casType == "CAS") then {_minDist = 1000};
  if (_buzz distance _lockobj <= _minDist) exitwith {};
  if (!alive _buzz || !isEngineOn _buzz || ((getpos _buzz select 2) < 5)) exitwith {};
  if (CASAbort) exitWith {};
  sleep 0.01;
};

if (!alive _buzz || !isEngineOn _buzz || ((getpos _buzz select 2) < 5)) exitwith
{
  CASRequest = false;
  deleteMarker _CASTargetMarker;
  CASInProgress = false;
  publicVariable "CASInProgress";
};





if (CASAbort) exitWith
{
  _buzz move _ranPos;
  RadioOperator = leader _grp; publicVariable "RadioOperator";
  RadioChat = "CAS Mission Aborted"; publicVariable "RadioChat";
  publicVariable "CASAbort";
  CASInProgress = false;
  publicVariable "CASInProgress";
  waitUntil{_buzz distance _object >= 2000 || !alive _buzz};
  {
    deleteVehicle vehicle _x;
    deleteVehicle _x;
  } forEach units _grp;
};

CASUsed = CASUsed + 1;
publicVariable "CASUsed";

CASChangeText = true;
publicVariable "CASChangeText";


[_buzz] spawn doCounterMeasure;

if ((alive _buzz) && (_casType == "JDAM")) then
{
  _drop = createAgent ["Logic", [getPos _buzz select 0, getPos _buzz select 1, 0], [] , 0 , "CAN_COLLIDE"];
  _height = 225 + _lock;
  _ASL = getPosASL _drop select 2;
  _height = _height - _ASL;
  _height = (getpos _buzz select 2) - 5;
  _bomb = "Bo_GBU12_LGB" createvehicle [getPos _drop select 0, getPos _drop select 1, _height];
  _bomb setDir ((_loc select 0)-(getPos _bomb select 0)) atan2 ((_loc select 1)-(getPos _bomb select 1));
  if (_lockedOn) then {[_lockedOnVeh,150,_bomb] execVM "support\guidedBomb.sqf"} else {
      _dist = _bomb distance _loc;
      if (_dist > 536) then
      {
        _diff = _dist - 536;
        _diff = _diff * 0.150;
        _velocityZ = 85 - _diff;
      };
      if (_dist < 536) then
      {
        _diff = 536 - _dist;
        _diff = _diff * 0.150;
        _velocityZ = 85 + _diff;
      };
      _bDrop = sqrt(((getPosASL _bomb select 2)-_lock)/4.9);
      _bVelX = ((_loc select 0)-(getPos _bomb select 0))/_bDrop;
      _bVelY = ((_loc select 1)-(getPos _bomb select 1))/_bDrop;
      _bomb setVelocity [_bVelX,_bVelY,(velocity _bomb select 2) - _velocityZ];
  };
  deleteVehicle _drop;
};

if ((alive _buzz) && (_casType == "NAPALM")) then
{
  _drop = createAgent ["Logic", [getPos _buzz select 0, getPos _buzz select 1, 0], [] , 0 , "CAN_COLLIDE"];
  _height = 225 + _lock;
  _ASL = getPosASL _drop select 2;
  _height = _height - _ASL;
  _height = (getpos _buzz select 2) - 5;
  _bomb = "Bo_GBU12_LGB" createvehicle [getPos _drop select 0, getPos _drop select 1, _height];
  _bomb setDir ((_loc select 0)-(getPos _bomb select 0)) atan2 ((_loc select 1)-(getPos _bomb select 1));
  if (_lockedOn) then {[_lockedOnVeh,150,_bomb] execVM "support\guidedBomb.sqf"} else {
      _dist = _bomb distance _loc;
      if (_dist > 536) then
      {
        _diff = _dist - 536;
        _diff = _diff * 0.150;
        _velocityZ = 85 - _diff;
      };
      if (_dist < 536) then
      {
        _diff = 536 - _dist;
        _diff = _diff * 0.150;
        _velocityZ = 85 + _diff;
      };
      _bDrop = sqrt(((getPosASL _bomb select 2)-_lock)/4.9);
      _bVelX = ((_loc select 0)-(getPos _bomb select 0))/_bDrop;
      _bVelY = ((_loc select 1)-(getPos _bomb select 1))/_bDrop;
      _bomb setVelocity [_bVelX,_bVelY,(velocity _bomb select 2) - _velocityZ];
  };
  [_bomb,_loc] spawn	{
	while {!IsNull (_this select 0)} do {	
	sleep 0.01;
	};
CSAR_NapalmPos = (_this select 1);
[CSAR_NapalmPos, "CSAR_NapalmExec"] call BIS_fnc_MP
  };
    _obj1 = _this select 0;
  deleteVehicle _drop;
};

if ((alive _buzz) && (_casType == "CBU")) then
{
  _drop = createAgent ["Logic", [getPos _buzz select 0, getPos _buzz select 1, 0], [] , 0 , "CAN_COLLIDE"];
  _height = 225 + _lock;
  _ASL = getPosASL _drop select 2;
  _height = _height - _ASL;
  _height = _height + 40;
  _cbu = "Bo_GBU12_LGB" createvehicle [getPos _drop select 0, getPos _drop select 1, _height];
  _cbu setDir ((_loc select 0)-(getPos _cbu select 0)) atan2 ((_loc select 1)-(getPos _cbu select 1));
  _dist = _cbu distance _loc;
    if (_lockedOn) then {[_lockedOnVeh,150,_cbu] execVM "support\guidedBomb.sqf"} else {
  if (_dist > 536) then
  {
    _diff = _dist - 536;
    _diff = _diff * 0.150;
    _velocityZ = 85 - _diff;
  };
  if (_dist < 536) then
  {
    _diff = 536 - _dist;
    _diff = _diff * 0.150;
    _velocityZ = 85 + _diff;
  };
  _bDrop = sqrt(((getPosASL _cbu select 2)-_lock)/4.9);
  _bVelX = ((_loc select 0)-(getPos _cbu select 0))/_bDrop;
  _bVelY = ((_loc select 1)-(getPos _cbu select 1))/_bDrop;
  _cbu setVelocity [_bVelX,_bVelY,(velocity _cbu select 2) - _velocityZ];
  };
  waitUntil{getPos _cbu select 2 <= 40};
  _pos = getPos _cbu;
  _effect = "SmallSecondary" createvehicle _pos;
  deleteVehicle _cbu;
  for "_i" from 1 to 35 do
  {
    _explo = "G_40mm_HEDP" createvehicle _pos;
    _explo setVelocity [-45 + (random 90),-45 + (random 90),-50];
    sleep 0.025;
  };
	
  deleteVehicle _drop;
};

if ((alive _buzz) && (_casType == "CAS")) then
{
RadioOperator = leader _grp; publicVariable "RadioOperator";
RadioChat = "CAS Commencing"; publicVariable "RadioChat";

    leader _grp setBehaviour "COMBAT";
    leader _grp setCombatMode "RED";
	  leader _grp setSpeedMode "LIMITED";
    leader _grp  enableAI "AUTOTARGET";
    leader _grp enableAI "TARGET";
    _time = time;
	  waitUntil {time >= _time + 60*3 || (!alive _buzz || !isEngineOn _buzz || ((getpos _buzz select 2) < 5)) || CASAbort};
    leader _grp setBehaviour "CARELESS";
    leader _grp setSpeedMode "FULL";
    leader _grp setCombatMode "BLUE";
    leader _grp  disableAI "AUTOTARGET";
    leader _grp disableAI "TARGET";
	  _index = currentWaypoint _grp;
	  deleteWaypoint [_grp, _index];
	  (driver _buzz) doMove _basePos;

};

if (alive _buzz && isEngineOn _buzz && ((getpos _buzz select 2) > 5)) then {
  RadioOperator = leader _grp; publicVariable "RadioOperator";
  RadioChat = "CAS Mission Complete, Returning To Base"; publicVariable "RadioChat";
};

CASInProgress = false;
publicVariable "CASInProgress";



CASRequest = false;

deleteMarker _CASTargetMarker;

_grp = group _buzz;

waitUntil{_buzz distance _object >= 2000 || !alive _buzz || ((getpos _buzz select 2) < 5)};
deleteVehicle _lockobj;
{
  deleteVehicle vehicle _x;
  deleteVehicle _x;
} forEach units _grp;