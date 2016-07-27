
    sleep 2.5;

    {IF (local _x) then {_x call blufor_fnc_initUnit;};} forEach list WestUnits;
    {IF (local _x) then {_x call opfor_fnc_initUnit;};} forEach list EastUnits;

    sleep 1;


    //Convoys
 //   _convoyFunc = compile preprocessFile "Convoy.sqf";

//    [] execVM "RandomPatrol.sqf";
