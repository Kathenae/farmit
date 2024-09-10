extends Camera3D

const MIN_RADIUS = 10
const MAX_RADIUS = 100
const MIN_ELEVATION = 25
const MAX_ELEVATION = 80

@export var disable_orbit_elevation = false
@export var orbit_sensitivity = 10
@export var zoom_sensitivity = 2
@export var pan_sensitivity = 1
@export var radius = 80
@export var elevation = 25
@export var azimuth = 0
@export var origin = Vector3.ZERO

var mouse_movement: Vector2
func _enter_tree() -> void:
	_update_position()
	pass

func _process(delta: float) -> void:
	
	if Input.is_action_pressed("orbit"):
		azimuth += mouse_movement.x * -orbit_sensitivity * delta
		if not disable_orbit_elevation:
			elevation += mouse_movement.y * orbit_sensitivity * delta
			elevation = clamp(elevation, MIN_ELEVATION, MAX_ELEVATION)
		_update_position()
	
	if Input.is_action_pressed("zoom"):
		var zoom_amount = mouse_movement.y
		if(abs(mouse_movement.x) > abs(mouse_movement.y)):
			zoom_amount = mouse_movement.x
		
		if projection == ProjectionType.PROJECTION_PERSPECTIVE:
			radius += zoom_amount * zoom_sensitivity * delta
			radius = clamp(radius, MIN_RADIUS, MAX_RADIUS)
		else:
			if  size + zoom_amount > 0.0001:
				size += zoom_amount
				size = clamp(size, MIN_RADIUS, MAX_RADIUS)
		
		_update_position()
	
	if Input.is_action_pressed("pan"):
		var forward = transform.basis.z
		forward.y = 0
		var right = transform.basis.x
		right.y = 0
		origin += forward * mouse_movement.y * -pan_sensitivity * delta
		origin += right * mouse_movement.x * -pan_sensitivity * delta
		_update_position()
	
	mouse_movement = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_movement = event.relative

func _update_position():
	position.x = radius * sin(deg_to_rad(azimuth)) * cos(deg_to_rad(elevation))
	position.y = radius * sin(deg_to_rad(elevation))
	position.z = radius * cos(deg_to_rad(azimuth)) * cos(deg_to_rad(elevation))
	position +=  origin
	look_at(origin)
