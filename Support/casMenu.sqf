CAS_reqTargetPos = "
  _pos = _this;
  _marker = call CAS_getTargetMarker;

  if (CASInProgress) exitWith {mapClick = true;};

  if (getMarkerColor _marker == """") then {
    _name = format ['CAS_TARGET_%1',name player];
    _marker = createMarker[_name, _pos];
    _marker setMarkerType 'mil_destroy';
    _marker setMarkerSize[0.5, 0.5];
    _marker setMarkerColor 'ColorRed';
    _markerText = format ['CAS (%1)',name player];
    _marker setMarkerText _markerText;
  };

  _marker setMarkerPos _pos;

  _display = uiNamespace getVariable 'casMenu';
  _button = _display displayCtrl 100119;
  _button ctrlSetTextColor [0,0,0,0];
  _button = _display displayCtrl 100112;

  _nearTargetList = [];
  CASNearestVeh = objNull;

  if ((player distance _pos) <= CASMaxDisReq) then
  {
    _button ctrlEnable true;
    titleText['','PLAIN DOWN'];

    _nearTargetVehList = (_pos) nearEntities [['Car', 'Motorcycle', 'Tank'], 10];

    _dist = 999;
    {
      if ((_x distance _pos < _dist) && (player knowsAbout _x >= 1.5)) then
      {
        CASNearestVeh = _x;
        _dist = _x distance _pos;
      };
    } forEach _nearTargetVehList;
  }
  else
  {
    hintSilent format ['Max distance to target is limited to: %1m', CASMaxDisReq];
    playSound 'cantDo';
    _button ctrlEnable false;
    deleteMarker _marker;
  };

  CASTargetPos = _pos;
  mapclick = true;
";

CAS_getTargetMarker = {
    private ["_marker"];
    call compile format ['_marker = "CAS_TARGET_%1"',name player];
    _marker;
};


_owner  = _this select 0;
_caller = _this select 1;
_id     = _this select 2;
_argArr = _this select 3;

CASMaxDisReq  = _argArr select 0;
_num = _argArr select 1;
_basePos = _argArr select 2;

CASNearestVeh = objNull;

_borderMarker = createMarkerLocal["maxDist", getPos _caller];
_borderMarker setMarkerShapeLocal "ELLIPSE";
_borderMarker setMarkerSizeLocal[CASMaxDisReq, CASMaxDisReq];
_borderMarker setMarkerColorLocal "colorRed";
_borderMarker setMarkerBrushLocal "Border";

CASType = "JDAM";

_dlg = createDialog "casMenu";
disableSerialization;
_display = uiNamespace getVariable "casMenu";

_display displayAddEventHandler ["KeyDown", "_this call compile preprocessFile ""Support\casSnap.sqf"""];

_button = _display displayCtrl 100112;
_button ctrlEnable false;

_toggle = _display displayCtrl 100118;

if (CASDoSnap) then
{
  _toggle ctrlSetText "<Enabled>";
  _toggle ctrlSetTextColor [0.3, 1, 0.6, 0.5];
}
else
{
  _toggle ctrlSetText "<Disabled>";
  _toggle ctrlSetTextColor [1, 0, 0, 0.5];
};

if (!CASInProgress) then
{
  _button = _display displayCtrl 100113;
  _button ctrlEnable false;
}
else
{
  _button = _display displayCtrl 100113;
  _button ctrlEnable true;
};

CASRequest = false;

_cursorTarget = cursorTarget;
if (!isNull _cursorTarget) then {((getPos _cursorTarget) call compile CAS_reqTargetPos);} else {
  ((screenToWorld [0.5,0.5]) call compile CAS_reqTargetPos);
};

_nearestVehName = "Locked";

while {dialog && alive _caller && alive _owner} do
{
  mapclick = false;
  onMapSingleClick "
    (_pos call compile CAS_reqTargetPos);
    onMapSingleClick '';
  ";

  while {true} do
  {
    _marker = (call CAS_getTargetMarker);
    _markerName = format [" CAS(%1)",name player];
    if (CASDoSnap) then
    {
      _toggle ctrlSetText "<Enabled>";
      _toggle ctrlSetTextColor [0.3, 1, 0.6, 0.5];
    }
    else
    {
      _toggle ctrlSetText "<Disabled>";
      _toggle ctrlSetTextColor [1, 0, 0, 0.5];
    };
    if (!CASInProgress) then
    {
      _button = _display displayCtrl 100113;
      _button ctrlEnable false;
    }
    else
    {
      _button = _display displayCtrl 100113;
      _button ctrlEnable true;
    };

    if (mapclick || !dialog) exitWith {};

    if ((CASDoSnap) && !isNull CASNearestVeh) then
    {
      _marker setMarkerPos (getPos CASNearestVeh);
      _markerName = format ["CAS(%1) - %2",name player,_nearestVehName];
    };

    if (markerText _marker != _markerName) then {_marker setMarkerText _markerName};

    sleep 0.5;
  };

  if (!dialog) exitWith {onMapSingleClick "mapclick = false; false"};
  sleep 0.123;
};

sleep 0.123;

deleteMarker "maxDist";

if (CASRequest) then
{
  [_owner, casType,(call CAS_getTargetMarker), _basePos, CASNearestVeh, CASDoSnap] execVM "Support\CAS.sqf";
}
else
{
  if (!CASInProgress) then {deleteMarker (call CAS_getTargetMarker);};
};