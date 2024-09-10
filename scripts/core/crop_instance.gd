extends RefCounted
class_name CropInstance

var _step: int
var _coord: Vector2i
var _crop: Crop
var _seconds_until_grown : float

var name: String:
	get:
		return _crop.name

var step: int:
	get:
		return _step

var coord: Vector2i:
	get:
		return _coord

var steps: Array[Mesh]:
	get:
		return _crop.steps

var is_grown: 
	get:
		return _step >= _crop.steps.size()

@warning_ignore("shadowed_variable")
func _init(crop: Crop, coord: Vector2i) -> void:
	_crop = crop
	_coord = coord
	_seconds_until_grown = crop.minutes_to_grow * 60

func update_growth(delta: float):
	_seconds_until_grown -= delta
	_seconds_until_grown = max(_seconds_until_grown, 0)
	var t = inverse_lerp(_crop.minutes_to_grow * 60, 0, _seconds_until_grown)
	var new_step = floor(lerp(0, steps.size() - 1, t))
	var progressed = new_step > _step
	_step = new_step
	return progressed
