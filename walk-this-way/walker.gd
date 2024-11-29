extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_vector = Vector3.ZERO

	if Input.is_key_pressed(KEY_W):  # W key
		input_vector.z -= 1
	if Input.is_key_pressed(KEY_S):  # S key
		input_vector.z += 1
	if Input.is_key_pressed(KEY_A):  # A key
		input_vector.x -= 1
	if Input.is_key_pressed(KEY_D):  # D key
		input_vector.x += 1

	input_vector = input_vector.normalized()
	
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	var rayOrigin = camera.project_ray_origin(mouse_position)
	var rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = rayOrigin  # Starting point of the ray
	ray_query.to = rayEnd   # Ending point of the ray
	ray_query.collide_with_areas = true  # Enable collisions with areas
	ray_query.collide_with_bodies = true  # Enable collisions with physics bodies
	var intersection = space_state.intersect_ray(ray_query)

		
	if intersection:
		var target_pos = intersection.position
		var distance = global_transform.origin.distance_to(target_pos)
		if distance >= 0.4:
			print_debug(distance)
			# Rotate only on the X-axis to face the target
			var direction = (target_pos - global_transform.origin).normalized()
			# Constrain to X-axis by setting Y and Z to match the node's current position
			var constrained_target = global_transform.origin + Vector3(direction.x, 0, direction.z)

			look_at(constrained_target, Vector3.UP)

	translate(input_vector * delta * 5)  # Adjust speed as needed
	pass
