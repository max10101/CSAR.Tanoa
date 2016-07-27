_unit = _this;
IF (random 1 > 0) then {
_action = [format["<t color='#FF9000'>Search for intel</t>"], {FindIntel = true;publicvariable "FindIntel"}, [_unit], 10, true, true, "","!FindIntel",5];
Sleep (1 + random 3);
[_unit,_action] remoteExec ["AddAction",0];
};