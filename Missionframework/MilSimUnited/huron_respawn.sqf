_price_s = 500;
_price_a = 0;
_price_f = 500;

_nearfob = [] call KPLIB_fnc_getNearestFob;

if ((_nearfob select 0) > 0) then {
	_storage_areas = (_nearfob nearobjects 100000) select {(_x getVariable ['KP_liberation_storage_type',-1]) == 0};
	
	{
		private _storage_positions = [];
		private _storedCrates = (attachedObjects _x);
		reverse _storedCrates;

		{
			_crateValue = _x getVariable ['KP_liberation_crate_value',0];

			switch ((typeOf _x)) do {
				case KP_liberation_supply_crate: {
					if (_price_s > 0) then {
						if (_crateValue > _price_s) then {
							_crateValue = _crateValue - _price_s;
							_x setVariable ['KP_liberation_crate_value', _crateValue, true];
							_price_s = 0;
						} else {
							detach _x;
							deleteVehicle _x;
							_price_s = _price_s - _crateValue;
						};
					};
				};
				case KP_liberation_ammo_crate: {
					if (_price_a > 0) then {
						if (_crateValue > _price_a) then {
							_crateValue = _crateValue - _price_a;
							_x setVariable ['KP_liberation_crate_value', _crateValue, true];
							_price_a = 0;
						} else {
							detach _x;
							deleteVehicle _x;
							_price_a = _price_a - _crateValue;
						};
					};
				};
				case KP_liberation_fuel_crate: {
					if (_price_f > 0) then {
						if (_crateValue > _price_f) then {
							_crateValue = _crateValue - _price_f;
							_x setVariable ['KP_liberation_crate_value', _crateValue, true];
							_price_f = 0;
						} else {
							detach _x;
							deleteVehicle _x;
							_price_f = _price_f - _crateValue;
						};
					};
				};
				default {[format ['Invalid object (%1) at storage area', (typeOf _x)], 'ERROR'] call KPLIB_fnc_log;};
			};
		} forEach _storedCrates;

		([_x] call KPLIB_fnc_getStoragePositions) params ['_storage_positions'];

		private _area = _x;
		_i = 0;
		{
			_height = [typeOf _x] call KPLIB_fnc_getCrateHeight;
			detach _x;
			_x attachTo [_area, [(_storage_positions select _i) select 0, (_storage_positions select _i) select 1, _height]];
			_i = _i + 1;
		} forEach attachedObjects (_x);

		if ((_price_s == 0) && (_price_a == 0) && (_price_f == 0)) exitWith {};

	} forEach _storage_areas;

	please_recalculate = true;
};