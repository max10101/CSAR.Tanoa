playSound "MYSOUND4";
["RTB","FAILED"] call BIS_fnc_taskSetState;
if (!alive POW) then {
    titleText ["THE POW DIED. YOU HAD ONE JOB.", "BLACK OUT"];
    sleep 12;
    endMission "LOSER";
} else {
    titleText ["YOU ALL DIED.", "BLACK OUT"];
    sleep 12;
    endMission "LOSER";
}