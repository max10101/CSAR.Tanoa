ART_reqTargetPos = "
    _pos = _this;
    if (artInProgress) exitWith {};
    _marker = call ART_getTargetMarker;
    _area = call ART_getAreaMarker;

    if (getMarkerColor _marker == """") then {
        _name = format ['ART_TARGET_%1',name player];
        _marker = createMarker[_name, _pos];
        _marker setMarkerType 'mil_destroy';
        _marker setMarkerSize[0.5, 0.5];
        _marker setMarkerColor 'ColorRed';
        _marker setMarkerText '';

        _name = format ['ART_AREA_%1',name player];
        _area = createMarker[_name, _pos];
        _area setMarkerShape 'ELLIPSE';
        _area setMarkerBrush 'FDiagonal';
        _area setMarkerSize[artArea, artArea];
        _area setMarkerColor 'ColorRed';
    };

    _marker setMarkerPos _pos;
    _area setMarkerPos _pos;

    _display = uiNamespace getVariable 'artMenu';
    _button = _display displayCtrl 100119;
    _button ctrlSetTextColor [0,0,0,0];
    _button = _display displayCtrl 100112;


    if ((player distance _pos) <= maxDisReq) then
    {
        _button ctrlEnable true;
        titleText['','PLAIN DOWN'];
    }
    else
    {
        hintSilent format ['Max distance to target is limited to: %1m', maxDisReq];
        playSound 'cantDo';
        _button ctrlEnable false;
        deleteMarker _marker;
        deleteMarker _area;
    };

    mapclick = true;
";

ART_getTargetMarker = {
    private ["_marker"];
    call compile format ['_marker = "ART_TARGET_%1"',name player];
    _marker;
};

ART_getAreaMarker = {
    private ["_marker"];
    call compile format ['_marker = "ART_AREA_%1"',name player];
        _marker;
};

_owner  = _this select 0;
_caller = _this select 1;
_id     = _this select 2;
_argArr = _this select 3;

if (!local _caller) exitWith {};

maxDisReq   = _argArr select 0;

artRequest = false;

_borderMarker = createMarkerLocal["maxDist", getPos _caller];
_borderMarker setMarkerShapeLocal "ELLIPSE";
_borderMarker setMarkerSizeLocal[maxDisReq, maxDisReq];
_borderMarker setMarkerColorLocal "colorRed";
_borderMarker setMarkerBrushLocal "Border";

artType = "40mm";
artArea = 50;
artRounds = 1;

_dlg = createDialog "artMenu";
disableSerialization;
_display = uiNamespace getVariable "artMenu";

_button = _display displayCtrl 100112;
_button ctrlEnable false;

if (!artInProgress) then {
    _cursorTarget = cursorTarget;
    if (!isNull _cursorTarget) then {(getPos _cursorTarget) call compile ART_reqTargetPos;} else {
      (screenToWorld [0.5,0.5]) call compile ART_reqTargetPos;
    };
};

while {dialog && alive _caller && alive _owner} do
{
    mapclick = false;
    onMapSingleClick "
        _pos call compile ART_reqTargetPos;
        onMapSingleClick '';
        true;
    ";

    _remainingTitle = _display displayCtrl 200003;

    while {true} do
    {
        _targetMarker = (call ART_getTargetMarker);
        switch (artType) do
        {
            case ("40mm") : {_remainingTitle ctrlSetText format ["%1",art40mmRemaining]};
            case ("82mm") : {_remainingTitle ctrlSetText format ["%1",art82mmRemaining]};
            case ("SMOKE") : {_remainingTitle ctrlSetText format ["%1",artSmokeRemaining]};
            case ("FLARES") : {_remainingTitle ctrlSetText format ["%1",artFlaresRemaining]};
        };
        if (artInProgress || mapclick || !dialog) exitWith {};
        switch (artType) do
        {
            case ("40mm") : {
                _targetMarkerName = format [" 40mm (%1)",name player];
                if (markerText _targetMarker != _targetMarkerName) then {_targetMarker setMarkerText _targetMarkerName;}
            };
            case ("82mm") : {
                _targetMarkerName = format [" 82mm (%1)",name player];
                if (markerText _targetMarker != _targetMarkerName) then {_targetMarker setMarkerText _targetMarkerName;}
            };
            case ("SMOKE") : {
                _targetMarkerName = format [" Smoke (%1)",name player];
                if(markerText _targetMarker != _targetMarkerName) then {_targetMarker setMarkerText _targetMarkerName;}
            };
            case ("FLARES") : {
                _targetMarkerName = format [" Flares (%1)",name player];
                if(markerText _targetMarker != _targetMarkerName) then {_targetMarker setMarkerText _targetMarkerName;}
            };
        };

        if (ctrlText _remainingTitle == "0") then {
            _button ctrlEnable false;
        } else {if (mapclick) then {_button ctrlEnable true}};
        sleep 0.2;
    };

      if (!dialog) exitWith {onMapSingleClick "mapclick = false; false"};
      sleep 0.123;
};

sleep 0.123;

deleteMarker "maxDist";

if (artRequest) then
{
  [_owner, artType, artRounds, artArea,call ART_getTargetMarker,call ART_getAreaMarker] execVM "Support\ART.sqf";
}
else
{
    if (!artInProgress) then {
        deleteMarker (call ART_getTargetMarker);
        deleteMarker (call ART_getAreaMarker);
    }
};