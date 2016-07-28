IF (local _this) then {
_unit = _this;
IF (random 1 > 0.7) then {
_action = [format["<t color='#FF9000'>Search for intel</t>"], {FindIntel = true;publicvariable "FindIntel"}, [_unit], 10, true, true, "","!FindIntel",5];
Sleep (10 + random 30);
[_unit,_action] remoteExec ["AddAction",0];
};
};