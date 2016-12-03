_unit = _this select 0;
sleep 0.5;
IF (_unit != player) then {
deletevehicle _unit;
};