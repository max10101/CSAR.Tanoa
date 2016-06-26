if (artInProgress) exitWith {
    artRadioOperator sideChat "Fire mission already under way, wait until it is finished!";
};

artInProgress = true;
publicVariable "artInProgress";

_object = _this select 0;
_artType = _this select 1;
_artRounds = _this select 2;
_artArea = _this select 3;
_ARTTargetMarker = _this select 4;
_ARTAreaMarker = _this select 5;

_loc = getMarkerPos _ARTTargetMarker;

_sleepTime = 1;
_amountLeft = 0;
_shellType = "";
_spawnHeight = 100;
_spawnVel = -10;
_spawnVelRandom = -10;
switch (_artType) do
{
   case ("40mm") : {_amountLeft = art40mmRemaining; _shellType = "G_40mm_HE"};
   case ("82mm") : {_amountLeft = art82mmRemaining; _shellType = "Sh_82mm_AMOS"};
   case ("SMOKE") : {_amountLeft = artSmokeRemaining; _shellType = "Smoke_82mm_AMOS_White"};
   case ("FLARES") : {_amountLeft = artSmokeRemaining; _shellType = "F_40mm_White"};
};

if (_amountLeft == 0) exitWith {
    artRadioOperator sideChat "No rounds left! Choose another ordinance!";
    artInProgress = false;
    publicVariable "artInProgress";
};

if (_amountLeft < _artRounds) then {
    _artRounds = _amountLeft;
    RadioOperator = artRadioOperator; publicVariable "RadioOperator";
    RadioChat = format ["We only have %1 rounds left, fire mission adjusted accordingly. ETA 25 seconds.",_artRounds]; publicVariable "RadioChat";
} else {
    RadioOperator = artRadioOperator; publicVariable "RadioOperator";
    RadioChat = "Fire mission received, ETA 35 seconds"; publicVariable "RadioChat";
};

_shellsPerRound = 0;

switch (artType) do
{
   case ("40mm") : {_shellsPerRound = 8; art40mmRemaining = art40mmRemaining - _artRounds; publicVariable "art40mmRemaining"};
   case ("82mm") : {_shellsPerRound = 6; art82mmRemaining = art82mmRemaining - _artRounds; publicVariable "art82mmRemaining"};
   case ("SMOKE") : {_shellsPerRound = 5; artSmokeRemaining = artSmokeRemaining - _artRounds; publicVariable "artSmokeRemaining"};
   case ("FLARES") : {_shellsPerRound = 5; _sleepTime = 8; _spawnHeight = 150; _spawnVel = -1; _spawnVelRandom = 0; artFlaresRemaining = artFlaresRemaining - _artRounds; publicVariable "artFlaresRemaining"};
};



sleep 10 + random 10;
RadioOperator = artRadioOperator; publicVariable "RadioOperator";
RadioChat = "Fire mission complete."; publicVariable "RadioChat";

artInProgress = false;
publicVariable "artInProgress";

sleep 10 + random 7;
RadioOperator = artRadioOperator; publicVariable "RadioOperator";
RadioChat = "Splash."; publicVariable "RadioChat";

sleep 3;



for [{_x = 0}, {_x < _artRounds}, {_x = _x+1}] do {
    for [{_i = 0}, {_i < _shellsPerRound}, {_i = _i+1}] do {
        _dir = random 360;
        _dist = random (_artArea);
        _pos =  [(_loc select 0) + sin(_dir)*_dist, (_loc select 1) + cos(_dir)*_dist, _spawnHeight + random 20];
        _shell = _shellType createVehicle _pos;
        _shell setVelocity [0,0,_spawnVel - random _spawnVelRandom];
        if (_shellType == "f_40mm_White") then {
          _light = "#lightpoint" createVehicle ( getPosATL _shell ) ;
          _light setLightBrightness 3;
          _light setLightAmbient [1, 1, 1];
          _light setLightUseFlare false;
          _light setLightFlareSize 0;
          _light setLightFlareMaxDistance 130;
          _light setLightColor [1, 0, 0];
          _light lightAttachObject [_shell, [ 0, 0, 0 ]];
          [_shell,_light] spawn {
            waitUntil {isNull (_this select 0);};
            deleteVehicle (_this select 1);
          };
        };
        sleep _sleepTime + random 1;
    };
    sleep 3 + random 2;
};






/*if (!dialog) then {
    deleteMarker "ART_TARGET";
    deleteMarker "ART_AREA";
}*/