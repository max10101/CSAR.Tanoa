_leader = _this select 0;
sleep 1;
{_x addAction["<t color='#0088FF'>-Recruit Soldier-</t>","addFireTeam.sqf",[],10,true,true,"","!(isPlayer _target) && alive _target",3]} foreach units _leader;