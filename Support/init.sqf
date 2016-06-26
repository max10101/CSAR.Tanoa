/********************
		CAS
*********************/
if (isNil "CASChangeText") then {CASChangeText = false};
if (isNil "CASUsed") then {CASUsed = 0};
if (isNil "CASInProgress") then {CASInProgress = false};
if (isNil "CASAbort") then {CASAbort = false};
if (isNil "CASRequest") then {CASRequest = false};
if (isNil "CASMissions") then {CASMissions = 4};

PlayerCASActionID = 0;
CASDoSnap = true;

/********************
		Arty
*********************/
if (isNil "art40mmRemaining") then {art40mmRemaining = 36};
if (isNil "art82mmRemaining") then {art82mmRemaining = 12};
if (isNil "artSmokeRemaining") then {artSmokeRemaining = 10};
if (isNil "artFlaresRemaining") then {artFlaresRemaining = 20};
if (isNil "artInProgress") then {artInProgress = false};


//Local
PlayerARTActionID = 0;

/*if (isServer) then {
	_grp = createGroup west;
	artRadioOperator = _grp createUnit ["B_Pilot_F", getPos WestBase, [], 0, "FORM"];
	publicVariable "artRadioOperator";
};*/

/********************
		Support
*********************/
PlayerSPTActionID = 0;
if (isNil "SPTRequest") then {SPTRequest = false};
if (isNil "SPTAbort") then {SPTAbort = false};
if (isNil "SPTInProgress") then {SPTInProgress = false};
if (isNil "SPTReinforceTime") then {SPTReinforceTime = -5000};
if (isNil "SPTExtractTime") then {SPTExtractTime = -5000};