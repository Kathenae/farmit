extends Node

func snap_to_grid(position: Vector3, grid_size: float) -> Vector3:
	return Vector3(
		round(position.x / grid_size) * grid_size,
		round(position.y / grid_size) * grid_size,
		round(position.z / grid_size) * grid_size,
	)

func raycast_mouse(max_distance: float = 100000):
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_normal = camera.project_ray_normal(mouse_pos)
	return raycast(ray_origin, ray_normal * max_distance)

func raycast(from : Vector3, to: Vector3):
	var space = get_tree().root.world_3d.direct_space_state
	var params = PhysicsRayQueryParameters3D.new()
	params.from = from
	params.to = to
	var result = space.intersect_ray(params)
	return result
