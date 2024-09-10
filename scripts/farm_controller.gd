extends Node3D

const CELL_SIZE = 2
var field_prefab = preload("res://Prefabs/field.tscn")

@export var crops: Array[Crop]

var selected_crop : int = 0
var fields : Dictionary = {}
var crops_meshes: Dictionary = {}
var farm : Farm

func _enter_tree() -> void:
	farm = Farm.new()
	farm.on_plow.connect(_on_farm_plow)
	farm.on_flatten.connect(_on_farm_flatten)
	farm.on_plant.connect(_on_farm_plant)
	farm.on_uproot.connect(_on_farm_uproot)
	farm.on_grown.connect(_on_farm_grown)

func _process(delta: float) -> void:
	var raycast = MathUtils.raycast_mouse()
	if not raycast.is_empty():
		$selection.global_position = MathUtils.snap_to_grid(raycast.position, CELL_SIZE)
	
	if Input.is_action_just_pressed("plant"):
		var coord = _to_coord($selection.global_position)
		
		if farm.get_field_at(coord):
			farm.plant(coord, crops[selected_crop])
		else:
			farm.plow(coord)
	
	if Input.is_action_just_pressed("uproot"):
		var coord = _to_coord($selection.global_position)
		
		if farm.get_crop_at(coord):
			farm.uproot(coord)
		else:
			farm.flatten(coord)
	
	if Input.is_action_just_pressed("cycle_crops"):
		selected_crop += 1
		if selected_crop >= crops.size():
			selected_crop = 0
		if selected_crop < 0:
			selected_crop = crops.size() - 1
	

func _on_tick_timeout():
	farm.tick($tick.wait_time)

func _on_farm_plow(coord: Vector2i):
	var pos = _to_pos(coord)
	var field_instance : Node3D = field_prefab.instantiate()
	fields[_to_key(pos)] = field_instance
	add_child(field_instance)
	field_instance.global_position = pos

func _on_farm_flatten(coord: Vector2i):
	var pos = _to_pos(coord)
	var field_instance: Node3D = fields[_to_key(pos)]
	field_instance.queue_free()
	fields.erase(_to_key(pos))

func _on_farm_plant(crop: CropInstance):
	var instance = MeshInstance3D.new()
	instance.mesh = crop.steps[crop.step]
	instance.name = crop.name
	add_child(instance)
	var pos = _to_pos(crop.coord)
	instance.global_position = pos
	crops_meshes[_to_key(pos)] = instance

func _on_farm_uproot(crop: CropInstance):
	var pos = _to_pos(crop.coord)
	var instance : MeshInstance3D = crops_meshes[_to_key(pos)]
	instance.queue_free()
	crops_meshes.erase(_to_key(pos))

func _on_farm_grown(crop: CropInstance):
	var pos = _to_pos(crop.coord)
	var instance : MeshInstance3D = crops_meshes[_to_key(pos)]
	instance.mesh = crop.steps[crop.step]

func _to_pos(coord: Vector2i) -> Vector3:
	return Vector3(coord.x * CELL_SIZE, 0, coord.y * CELL_SIZE)

func _to_coord(pos: Vector3) -> Vector2i:
	return Vector2i(roundi(pos.x / CELL_SIZE), roundi(pos.z / CELL_SIZE))

func _to_key(pos: Vector3):
	return "{x}-{y}-{z}".format({"x": pos.x, "y": pos.y, "z": pos.z}) 
