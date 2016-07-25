//FASTTIME
IF (!IsServer) Exitwith {};
_Old = 1;
_New = 1;
While {true} do {
sleep 10;
//night 8pm-6am (x45 = 24hrs pass in 0.533 of an hour or 32min, nighttime should pass in about 15 minutes)
IF (((daytime >= 20) && (daytime <= 6))) then {_New = 45};

// x25 = 24hrs in 57.6min = 30min daytime
IF (((daytime < 20) && (daytime > 6))) then {_New = 25};

iF (_New != _Old) then {setTimeMultiplier _New;_Old = _New};
};
