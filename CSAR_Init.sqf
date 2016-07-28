
    sleep 2.5;

    {_x call blufor_fnc_initUnit;} forEach list WestUnits;
    {_x call opfor_fnc_initUnit;} forEach list EastUnits;

    sleep 1;


    //Convoys
 //   _convoyFunc = compile preprocessFile "Convoy.sqf";

//    [] execVM "RandomPatrol.sqf";
