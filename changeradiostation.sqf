_pos = getpos radio;
deletevehicle radio;
radio = "Land_Survivalradio_F" createvehicle _pos;
radio setpos [_pos select 0,_pos select 1,0.81];
publicvariable "radio";
SkipRadio = true;publicvariable "SkipRadio";
sleep 1.5;
[radio,"uns_song2"] remoteExec ["Say3D",0];