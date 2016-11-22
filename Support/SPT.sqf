_object = _this select 0;
_sptType = _this select 1;
_SPTTargetMarker = _this select 2;
_basePos = _this select 3;

_pos = getMarkerPos _SPTTargetMarker;

if (SPTInProgress) exitWith {player groupchat "Support already enroute, cancel current support mission or wait for it to complete!"};
if (!AATaskComplete) exitWith {player groupchat "AA site is still up! Support can't be called."};

if (_sptType in ["ReinforcementsLand","ReinforcementsPara"] && (time < SPTReinforceTime + (60*10))) exitWith {
	_newTime = (SPTReinforceTime + (60*10)) - time;
	_newTime = round(_newTime/60);
	player groupChat format ["Reinforcements will take another %1 minutes to replenish!",_newTime];
};
if (_sptType == "Extract" && (time < SPTExtractTime + (60*10))) exitWith {
    _newTime = (SPTExtractTime + (60*10)) - time;
    _newTime = round(_newTime/60);
    player groupChat format ["I can't call an extraction for another %1 minutes!",_newTime];
};

SPTInProgress = true;
publicVariable "SPTInProgress";

if (_sptType in ["ReinforcementsLand","ReinforcementsPara"]) then {
	SPTReinforceTime = time; publicVariable "SPTReinforceTime";
	_heli = createvehicle ["B_Heli_Transport_03_F",[_basePos select 0, _basePos select 1, 100], [], 0, "FLY"];
	createvehiclecrew _heli;
	_pilot = driver _heli;
	_heligroup = group _pilot;
    {_x call blufor_fnc_initUnit} forEach (crew _heli);
    _heli addEventHandler ["dammaged", {_this execVM "HelicopterEmergency.sqf"}];
    //[group _heli] execVM "waypointMarkers.sqf";
    group _heli setBehaviour "CARELESS";
    group _heli setSpeedMode "NORMAL";
    RadioOperator = leader group _heli;
    RadioChat = format["Copy, %1, reinforcements en route - ETA 5 Mikes",name player];
    publicVariable "RadioOperator";
    publicVariable "RadioChat";
    if (_sptType == "ReinforcementsLand") then {
	    helipad = "Land_HelipadEmpty_F" createvehicle _pos;
	};

    if (leader group player != player) then {
            _newGrp = createGroup west;
            [player] join _newGrp;
    };

    _group1 = [_basePos, west, (configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfTeam")] call BIS_fnc_spawnGroup;
    _leader1 = leader _group1;
    _group2 = [_basePos, west, (configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfSquad")] call BIS_fnc_spawnGroup;
    _reinforceUnits = (units _group1 + units _group2);
	
    {
        _x call blufor_fnc_initUnit;
		[_heli,[_x,"CARGO"],false,true] call bis_fnc_InitVehicleCrew;
		IF (vehicle _x == _x) then {deletevehicle _x};
        if (_x == _leader1) then {[_x] join group player} else {
            [_x] joinSilent group player
		
        };
    } forEach _reinforceUnits;



    if (_sptType == "ReinforcementsLAND") then {_heli flyInHeight 80} else {_heli flyInHeight 120};
    _pilot doMove _pos;

    _markerName = format ["SPT_Tracking_Marker%1", random 9999];
    _marker = createMarker [_markerName,getPos _heli];
    _marker setMarkerType 'o_inf';
    _marker setMarkerSize[1, 1];
    _marker setMarkerColor 'ColorRed';
    _marker setMarkerText "Reinforcements";

    [_heli,_marker] spawn {
        _heli = _this select 0;
        _marker = _this select 1;
        while {getMarkerColor _marker != ""} do {
            sleep 3;
            _marker setMarkerPos position _heli;
        };
    };

    waitUntil {!(alive _heli) || ((_heli distance2d _pos) < 100) || ((getpos _heli select 2) < 5) || !(isEngineOn _heli) || SPTAbort};
    if ((_heli distance2d _pos) < 100 && alive _heli && !SPTAbort) then {
    	RadioOperator = driver _heli; RadioChat = "Reinforcements arrived - dropping cargo"; publicVariable "RadioOperator"; publicVariable "RadioChat";
    	if (_sptType == "ReinforcementsLAND") then {
			dostop _heli;sleep 3;
       	 	(vehicle _heli) land "GET OUT";
       	 	waitUntil {(getpos _heli select 2) < 1};
       	 	_heli flyInHeight 1;
			_stayput = [_heli,_heligroup] spawn {_heli = _this select 0;_heligroup = _this select 1;
				WHILE {alive _heli && (count crew vehicle _heli) > (count units _heliGroup) && (isEngineOn _heli) && (alive driver _heli)} 
					do
					{_heli setvelocity [velocity _heli select 0,velocity _heli select 1,0]}
				};
			{unassignVehicle _x;_x action ["GETOUT",_heli]; sleep 0.3} foreach _reinforceUnits;
			waitUntil {!alive _heli || (count crew vehicle _heli) <= (count units _heliGroup) || !(isEngineOn _heli) || !(alive driver _heli)};
			sleep 5;
			_heli flyInHeight 100;
    	} else {
    		[vehicle _heli,true] execVM "Eject.sqf";
            waitUntil {!alive _heli || (count crew vehicle _heli) <= (count units _heliGroup) || !(isEngineOn _heli) || ((getpos _heli select 2) < 5)};
    	};
    } else {
    	if (SPTAbort) then {
            RadioOperator = driver _heli; RadioChat = format["10-4, %1, cancelling your reinforcements and returning to base",name player]; publicVariable "RadioOperator"; publicVariable "RadioChat";
    		SPTReinforceTime = -5000; publicVariable "SPTReinforceTime";
    		{[_x] join grpNull} foreach _reinforceUnits;
    	}
    };

    if (alive _heli) then {
    	_heli doMove _basePos;
	};

    SPTInProgress = false; publicVariable "SPTInProgress";
    deleteMarker _SPTTargetMarker;
    deleteMarker _marker;


    waitUntil {!(alive _heli) || ((_heli distance2d _basePos) < 100) || !(isEngineOn _heli)};
    if (_heli distance2d _basePos < 100) then {
    	{_heli deleteVehicleCrew _x} forEach crew _heli;
    	deleteVehicle _heli;
    };
} else {
    if (_sptType == "Extract") then {
        SPTExtractTime = time; publicVariable "SPTExtractTime";
        _heli = createVehicle ["B_Heli_Transport_01_F", _basePos, [], 0, "FLY"];
        _heli setDir 270;
        _heli addEventHandler ["dammaged", {_this execVM "HelicopterEmergency.sqf"}];
        createVehicleCrew _heli;
        waitUntil {count crew _heli >= 2};
        {_x call blufor_fnc_initUnit} forEach (crew _heli);
        _pilot = driver _heli;
        _pilot setBehaviour "CARELESS";
        _pilot addEventHandler["Getout", {(_this select 2) setBehaviour "Aware";}];

        RadioOperator = leader group _heli;
        RadioChat = format["Copy, %1, extraction en route - ETA 5 Mikes",name player];
        publicVariable "RadioOperator";
        publicVariable "RadioChat";

        helipad = "Land_HelipadEmpty_F" createvehicle _pos;
        _heli doMove _pos;

        _markerName = format ["SPT_Tracking_Marker%1",random 9999];
        _marker = createMarkerLocal[_markerName,_basePos];
        _marker setMarkerType 'o_inf';
        _marker setMarkerSize[1, 1];
        _marker setMarkerColor 'ColorRed';
        _marker setMarkerText "Extraction";

        _count = 0;
        [_heli,_marker] spawn {
            _heli = _this select 0;
            _marker = _this select 1;
            while {getMarkerColor _marker != ""} do {
                sleep 3;
                _marker setMarkerPos position _heli;
            };
        };

        waitUntil {!(alive _heli) || ((_heli distance2d _pos) < 100) || ((getpos _heli select 2) < 5) || !(isEngineOn _heli) || SPTAbort};
        if ((_heli distance2d _pos) < 100 && alive _heli && !SPTAbort) then {
             RadioOperator = driver _heli; RadioChat = "Extraction arrived at the LZ"; publicVariable "RadioOperator"; publicVariable "RadioChat";
            (vehicle _heli) land "GET IN";
        } else {
            if (SPTAbort) then {
                RadioOperator = driver _heli; RadioChat = format["10-4, %1, cancelling extraction mission and returning to base",name player]; publicVariable "RadioOperator"; publicVariable "RadioChat";
                SPTExtractTime = -5000; publicVariable "SPTReinforceTime";
            };
        };

        SPTInProgress = false; publicVariable "SPTInProgress";
        deleteMarker _SPTTargetMarker;
        deleteMarker _marker;

        if (!SPTAbort) then {
            waitUntil {(getpos _heli select 2) < 4};
            if ((_heli distance2d _pos) < 200 && alive _heli) then {
                _leader1 = leader group (driver _heli);
                doStop (driver _heli);
                {
                    if (_x == _leader1) then {
                        [_x] join group player
                    } else {
                        [_x] joinSilent group player
                    };
                } forEach units group _heli;
                doStop (driver _heli);
            };
        } else {
            if (alive _heli) then {
                _heli doMove _basePos;
                waitUntil {!(alive _heli) || ((_heli distance2d _basePos) < 100) || !(isEngineOn _heli)};
                if (_heli distance2d _basePos < 100) then {
                    {_heli deleteVehicleCrew _x} forEach crew _heli;
                    deleteVehicle _heli;
                };
            };
        }
    }
}
