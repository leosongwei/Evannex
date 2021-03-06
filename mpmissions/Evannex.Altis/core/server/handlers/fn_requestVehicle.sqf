MP_request_vehicle = {
	params ["_vehType", "_marker", "_textures"];

	private _new_veh = createVehicle [ _vehType, getMarkerPos _marker, [], 0, "CAN_COLLIDE" ];
	private _vehDir = markerDir _marker;
	_new_veh setPosATL [ ( position _new_veh select 0 ), ( position _new_veh select 1 ), 0.25 ];
	_new_veh setDir _vehDir;
	
	private _count = 0;
	{
		_new_veh setObjectTextureGlobal [ _count, _x ];
		_count = _count + 1;
	} forEach _textures;

	br_spawned_vehicles pushBack _new_veh;
	{ if (!alive _x) then { br_spawned_vehicles deleteAt (br_spawned_vehicles find _x); deleteVehicle _x; }; } forEach br_spawned_vehicles;
	while {count br_spawned_vehicles > br_max_user_vehicles} do {
		private _toDelete = br_spawned_vehicles select 0;
		format ["The server has hit the spawnable vehicles limit: %1. Deleting one.", count br_spawned_vehicles, getText (configFile >>  "CfgVehicles" >> (typeof _new_veh) >> "displayName")] remoteExec ["systemChat"]; 
		//[[[format ["The server has hit the spawnable vehicles limit: %1, deleting ", count br_spawned_vehicles, getText (configFile >>  "CfgVehicles" >> typeof _new_veh >> "displayName")]],"core\client\fn_sySVehicle.sqf"],"BIS_fnc_execVM",true,true] call BIS_fnc_MP;
		br_spawned_vehicles deleteAt (br_spawned_vehicles find _toDelete);
		deleteVehicle _toDelete;
	}
};