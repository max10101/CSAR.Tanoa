SPT_reqTargetPos = "
  _pos = _this;
  _marker = call SPT_getTargetMarker;
  if (SPTInProgress) exitWith {mapClick = true;};
  if (getMarkerColor _marker == """") then {
    _name = format ['SPT_TARGET_%1',name player];
    _marker = createMarker[_name, _pos];
    _marker setMarkerType 'mil_destroy';
    _marker setMarkerSize[0.5, 0.5];
    _marker setMarkerColor 'ColorBlue';
    _markerText = format ['Reinforcements (Land) (%1)',name player];
    _marker setMarkerText _markerText;
  };

  _marker setMarkerPos _pos;

  _display = uiNamespace getVariable 'SPTMenu';
  _button = _display displayCtrl 100119;
  _button ctrlSetTextColor [0,0,0,0];
  _button = _display displayCtrl 100112;

  if ((player distance _pos) <= SPTMaxDisReq) then
  {
    _button ctrlEnable true;
    titleText['','PLAIN DOWN'];
  }
  else
  {
    hintSilent format ['Max distance to target is limited to: %1m', SPTMaxDisReq];
    playSound 'cantDo';
    _button ctrlEnable false;
    deleteMarker _marker;
  };

  mapclick = true;
";

SPT_getTargetMarker = {
    private ["_marker"];
    call compile format ['_marker = "SPT_TARGET_%1"',name player];
    _marker;
};

_owner  = _this select 0;
_caller = _this select 1;
_id     = _this select 2;
_argArr = _this select 3;

SPTMaxDisReq   = _argArr select 0;
_basePos = _argArr select 1;

_borderMarker = createMarkerLocal["maxDist", getPos _caller];
_borderMarker setMarkerShapeLocal "ELLIPSE";
_borderMarker setMarkerSizeLocal[SPTMaxDisReq, SPTMaxDisReq];
_borderMarker setMarkerColorLocal "colorRed";
_borderMarker setMarkerBrushLocal "Border";

SPTType = "ReinforcementsLand";

_dlg = createDialog "SPTMenu";
disableSerialization;
_display = uiNamespace getVariable "SPTMenu";

_button = _display displayCtrl 100112;
_button ctrlEnable false;

_toggle = _display displayCtrl 100118;

if (!SPTInProgress) then
{
  _button = _display displayCtrl 100113;
  _button ctrlEnable false;
}
else
{
  _button = _display displayCtrl 100113;
  _button ctrlEnable true;
};

SPTRequest = false;


_cursorTarget = cursorTarget;
if (!isNull _cursorTarget) then {(getPos _cursorTarget) call compile SPT_reqTargetPos;} else {
  (screenToWorld [0.5,0.5]) call compile SPT_reqTargetPos;
};

while {dialog && alive _caller && alive _owner} do
{
  mapclick = false;
  onMapSingleClick "
    _pos call compile SPT_reqTargetPos;
    onMapSingleClick '';
  ";

  while {true} do
  {
    _requestButton = _display displayCtrl 100112;
    _timeLeftText = _display displayCtrl 100117;
    if (SPTType in ["ReinforcementsLand","ReinforcementsPara"]) then {
        _timeLeft = (SPTReinforceTime + (60*10)) - time;
        if (_timeLeft <= 0) then {
          if (!SPTInProgress) then {_requestButton ctrlEnable true; _timeLeftText ctrlSetText "Reinforcements Available";} else {
            _timeLeftText ctrlSetText "N/A - Support Mission in Progress";
          }
        } else {
            _text = format ["Reinforcements will be available in: %1:%2",floor(_timeLeft/60),round(_timeLeft%60)];
            _timeLeftText ctrlSetText _text;
            _requestButton ctrlEnable false;
        }
    } else {
        _timeLeft = (SPTExtractTime + (60*10)) - time;
        if (_timeLeft <= 0) then {
            if (!SPTInProgress) then {_requestButton ctrlEnable true;_timeLeftText ctrlSetText "Extraction Available";} else {
              _timeLeftText ctrlSetText "N/A - Support Mission in Progress";
            }
        }  else {
            _text = format ["Extraction will be available in: %1:%2",floor(_timeLeft/60),round(_timeLeft%60)];
            _timeLeftText ctrlSetText _text;
            _requestButton ctrlEnable false;
        }
    };
    if (SPTInProgress || mapclick || !dialog) exitWith {};
    _marker = (call SPT_getTargetMarker);
    if (SPTType == "ReinforcementsLand" && (markerText _marker != "Reinforcements (Land)")) then {
        _markerText = format ['Reinforcements (Land) (%1)',name player];
        _marker setMarkerText _markerText;
    };
    if (SPTType == "ReinforcementsPara" && (markerText _marker != "Reinforcements (Para)")) then {
        _markerText = format ['Reinforcements (Para) (%1)',name player];
        _marker setMarkerText _markerText;
    };
    if (SPTType == "Extract" && (markerText _marker != "Extraction")) then {
        _markerText = format ['Extraction (%1)',name player];
        _marker setMarkerText _markerText;
    };

    if (!SPTInProgress) then
    {
      _button = _display displayCtrl 100113;
      _button ctrlEnable false;
    }
    else
    {
      _button = _display displayCtrl 100113;
      _button ctrlEnable true;
    };

    sleep 0.3;
  };

  if (!dialog) exitWith {onMapSingleClick "mapclick = false; false"};
  sleep 0.123;
};

sleep 0.123;

deleteMarker "maxDist";

if (SPTRequest) then
{
  [_owner, SPTType,(call SPT_getTargetMarker), _basePos] execVM "Support\SPT.sqf";
}
else
{
  if (!SPTInProgress) then {
      deleteMarker (call SPT_getTargetMarker);
    };
};