extends Object
class_name Farm

signal on_plow(coord: Vector2i)
signal on_flatten(coord: Vector2i)
signal on_plant(crop: CropInstance)
signal on_uproot(crop: CropInstance)
signal on_grown(crop: CropInstance)

var _plown_fields : Dictionary = {}
var _planted_crops : Dictionary = {}

func _init() -> void:
	
	pass

func tick(delta: float):
	for crop : CropInstance in _planted_crops.values():
		if crop.update_growth(delta):
			on_grown.emit(crop)

func plow(coord: Vector2i):
	if get_field_at(coord) != null:
		return
	
	_plown_fields[_coord_to_key(coord)] = true
	on_plow.emit(coord)

func flatten(coord: Vector2i):
	var field = get_field_at(coord)
	if field == null:
		return
	
	_plown_fields.erase(_coord_to_key(coord))
	on_flatten.emit(coord)

func plant(coord: Vector2i, crop: Crop):
	if get_crop_at(coord) != null:
		return
	
	var instance = CropInstance.new(crop, coord)
	_planted_crops[_coord_to_key(coord)] = instance
	on_plant.emit(instance)

func uproot(coord: Vector2i):
	var crop = get_crop_at(coord)
	if crop == null:
		return
	
	_planted_crops.erase(_coord_to_key(coord))
	on_uproot.emit(crop)

func get_field_at(coord: Vector2i):
	return _plown_fields.get(_coord_to_key(coord))

func get_crop_at(coord: Vector2i) -> CropInstance:
	return _planted_crops.get(_coord_to_key(coord))

func _coord_to_key(coord: Vector2i):
	return "{x}-{y}".format({"x": coord.x, "y": coord.y}) 
