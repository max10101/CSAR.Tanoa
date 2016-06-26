_leader = _this select 0;
_player = _this select 1;
_leader removeAction (_this select 2);

if (isPlayer leader group _leader) then {
	_leader sideChat "Already in a group, sir!";
} else {
    if (leader group _player != _player) then {
        _newGrp = createGroup west;
        [_player] join _newGrp;
	};
		[_leader] joinsilent group _player;
		_leader setbehaviour "AWARE";
};