params ["_units", "_static"];
private ["_unit1", "_unit2", "_pos1","_posStatic","_pos2","_array","_wh1","_wh2","_bp1","_bp2", "_size", "_distance", "_tempU", "_bb", "_initPos", "_vehclass", "_vehname"];
if !(_static isKindOf "StaticWeapon") exitWith {};
_vehclass = typeOf _static;
_vehname = getText (configFile >>  "CfgVehicles" >> _vehclass >> "displayName");
if (AIO_useVoiceChat) then {
/*
[] spawn {
	private _dummy = "#particlesource" createVehicleLocal ASLToAGL getPosWorld player;
	_dummy say2D "AIO_say_Disassemble";
	sleep 2; 
	deleteVehicle _dummy;
};
*/
player groupRadio "SentDisassemble";
};
player groupChat (format ["Disassemble that %1 .", _vehname]);
if (count _units == 2) then {
	_unit1 = _units select 0;
	_unit2 = _units select 1;
	_initPos = getPos _static;
	if (vehicle _unit1 != _unit1 OR vehicle _unit2 != _unit2) exitWith {};
	_bb = [_static] call AIO_get_Bounding_Box;
	_bb = [_bb,[],{_x distance _unit1},"ASCEND"] call BIS_fnc_sortBy;
	_posStatic = (_bb select 0);
	_unit1 doMove _posStatic;
	_posStatic = (_bb select 1);
	_unit2 doMove _posStatic;
	_size = sizeOf (typeOf _static);
	_distance = _size/3 + 5;
	_posStatic = getPos _static;
	while {!(unitReady _unit1) && (alive _unit1) && (alive _static)} do {
		if (unitReady _unit2 OR (!alive _unit2)) exitWith {
			_tempU = _unit2;
			_unit2 = _unit1;
			_unit1 = _tempU;
		};
		sleep 1;
	};
	if (_unit1 distance _static > _distance) exitWith {_units doMove (getpos _unit1)}; 
	_pos1 = getPos _unit1;
	_pos2 = getPos _unit2;
	_unit1 action ["PutBag"];
	_unit1 action ["Disassemble", _static];
	sleep 2.5;
	_unit1 doMove _posStatic;
	waitUntil {unitReady _unit1 OR !(alive _unit1)};
	_array = nearestObjects [_initPos, ["WeaponHolder"], 5];
	_wh1 = _array select 0;
	_wh2 = _array select 1;
	_bp1 = firstBackpack _wh1;
	_bp2 = firstBackpack _wh2;
	_unit1 action ["AddBag", _wh1, typeOf _bp1];
	sleep 1;
	_unit1 doMove _pos1;
	waitUntil {unitReady _unit2 OR !(alive _unit2)};
	_unit2 action ["PutBag"];
	sleep 0.5;
	_unit2 doMove _posStatic;
	waitUntil {unitReady _unit2 OR !(alive _unit2)};
	_unit2 action ["AddBag", _wh2, typeOf _bp2];
	sleep 1;
	_unit2 doMove _pos2;
} else {
	_unit1 = _units select 0;
	if (vehicle _unit1 != _unit1) exitWith {};
	_bb = [_static] call AIO_get_Bounding_Box;
	_bb = [_bb,[],{_x distance _unit1},"ASCEND"] call BIS_fnc_sortBy;
	_posStatic = (_bb select 0);
	_unit1 doMove _posStatic;
	while {!(unitReady _unit1) && (alive _unit1) && (alive _static)} do {sleep 1;};
	if (_unit1 distance _static > 10) exitWith {_units doMove (getpos _unit1)}; 
	_unit1 action ["Disassemble", _static];
};