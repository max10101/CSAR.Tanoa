	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2013-2015 Nicolas BOITEUX
[0.114466,0.014,250]
	Real weather for MP GAMES v 1.4

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
	*/

	private ["_lastrain", "_rain", "_fog", "_mintime", "_maxtime", "_overcast", "_realtime", "_random","_startingdate", "_startingweather", "_timeforecast", "_daytimeratio", "_nighttimeratio", "_timesync", "_wind"];

	// Real time vs fast time
	// true: Real time is more realistic weather conditions change slowly (ideal for persistent game)
	// false: fast time give more different weather conditions (ideal for non persistent game)
	_realtime = false;

	// Random time before new forecast
	// true: forecast happens bewteen mintime and maxtime
	// false: forecast happens at mintime
	_random = false;

	// Min time seconds (real time) before a new weather forecast
	_mintime = 400;

	// Max time seconds (real time) before a new weather forecast
	_maxtime = 800;

	// If Fastime is on
	// Ratio 1 real time second for x game time seconds
	// Default: 1 real second = 6 second in game
	_duskDawnRatio = 6;
	_daytimeratio = 35;
	_nighttimeratio = 48;

	// send sync data across the network each xxx seconds
	// 60 real seconds by default is a good value
	// shortest time do not improve weather sync
	_timesync = 60;

	// Mission starting date is 25/09/2013 at 12:00
	_startingdate = [2026, 12, 19, 5, 34];
	//if (random 1 > 0.5) then {_startingdate = [2015, 07, 01, 20, 00]};

	// Mission starting weather "CLEAR|CLOUDY|RAIN";
//	_startingweather = ["CLEAR", "CLOUDY", "RAIN"] call BIS_fnc_selectRandom;
	_startingweather = "CLEAR";
	/////////////////////////////////////////////////////////////////
	// Do not edit below
	/////////////////////////////////////////////////////////////////

	if(_mintime > _maxtime) exitwith {hint format["Real weather: Max time: %1 can no be higher than Min time: %2", _maxtime, _mintime];};
	_timeforecast = _mintime;

	//setdate _startingdate;
	switch(toUpper(_startingweather)) do {
		case "CLEAR": {
			wcweather = [0, [0,0,0], 0, [random 3, random 3, true], date];
		};

		case "CLOUDY": {
			wcweather = [0, [0,0,0], 0.4 + (random 0.2), [random 3, random 3, true], date];
		};

		case "RAIN": {
			wcweather = [1, [0,0,0], 0.6 + (random 0.4), [random 3, random 3, true], date];
		};

		default {
			// clear
			wcweather = [0, [0,0,0], 0, [random 3, random 3, true], date];
			diag_log "Real weather: wrong starting weather";
		};
	};

	// add handler
	if (local player) then {
		wcweatherstart = true;
		"wcweather" addPublicVariableEventHandler {
			// first JIP synchronization
			if(wcweatherstart) then {
				wcweatherstart = false;
				skipTime -24;
				86400 setRain (wcweather select 0);
				86400 setfog (wcweather select 1);
				86400 setOvercast (wcweather select 2);
				skipTime 24;
				simulweatherSync;
				setwind (wcweather select 3);
				setdate (wcweather select 4);
			}else{
				wcweather = _this select 1;
				60 setRain (wcweather select 0);
				60 setfog (wcweather select 1);
				60 setOvercast (wcweather select 2);
				setwind (wcweather select 3);
				setdate (wcweather select 4);
			};
		};
	};

	// SERVER SIDE SCRIPT
	if (!isServer) exitWith{};

	// apply weather
	skipTime -24;
	86400 setRain (wcweather select 0);
	86400 setfog (wcweather select 1);
	86400 setOvercast (wcweather select 2);
	skipTime 24;
	simulweatherSync;
	setwind (wcweather select 3);
	setdate (wcweather select 4);

	// sync server & client weather & time
	[_realtime, _timesync, _daytimeratio, _nighttimeratio, _duskDawnRatio] spawn {
		private["_realtime", "_timesync", "_daytimeratio", "_nighttimeratio","_hour"];

		_realtime = _this select 0;
		_timesync = _this select 1;
		_daytimeratio = _this select 2;
		_nighttimeratio = _this select 3;
		_duskDawnRatio = _this select 4;

		while { true } do {
			wcweather set [4, date];
			publicvariable "wcweather";
			if(!_realtime) then {
				_hour = date select 3;
				if(_hour >= 20 or _hour < 4) then {
					setTimeMultiplier _nighttimeratio;
					//player sideChat "Night time";
				};
				if((_hour >= 18 && _hour < 20) or (_hour >= 4 && _hour < 6)) then {
					setTimeMultiplier _duskDawnRatio;
					//player sideChat "Dusk/Dawn";
				};
				if(_hour >= 6 && _hour < 18) then {
					setTimeMultiplier _daytimeratio;
					//player sideChat "Day";
				};
			};
			sleep _timesync;
		};
	};

	_lastrain = 0;
	_rain = 0;
	_overcast = 0;

	while {true} do {
		_overcast = random 1;
		if(_overcast > 0.70) then {
			_rain = random 1;
		} else {
			_rain = 0;
		};
		if((date select 3 > 2) and (date select 3 <6)) then {
			if(random 1 > 0.55) then {
				_fog = [0.084466,0.008,120+(random 50)];
			} else {
				_fog = [0.054466,0.0065,120+(random 50)];
			};
		} else {
			if((_lastrain > 0.6) and (_rain < 0.2)) then {
				_fog = [0.034466,0.005,120+(random 50)];
			} else {
				_fog = [(0.001466),0.001+(random 0.001),5+random 50];
			};
		};
		_hour = date select 3;
		if(_hour >= 20 or _hour < 4) then {
			_fog = [0,0,0];
			_overcast = 0;
			_rain = 0;
		};
		
		if(random 1 > 0.95) then {
			_wind = [random 7, random 7, true];
		} else {
			_wind = [random 3, random 3, true];
		};
		_lastrain = _rain;

		wcweather = [_rain, _fog, _overcast, _wind, date];
		60 setRain (wcweather select 0);
		60 setfog (wcweather select 1);
		60 setOvercast (wcweather select 2);
		setwind (wcweather select 3);
		if(_random) then {
			_timeforecast = _mintime + (random (_maxtime - _mintime));
		};
		sleep _timeforecast;
	};
