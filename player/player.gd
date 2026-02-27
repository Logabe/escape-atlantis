extends CharacterBody3D
class_name Player

const SPEED = 6.0
const JUMP_HEIGHT = 5.0

@export var model: MeshInstance3D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_HEIGHT

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		model.rotation.y = dir_to(velocity)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func dir_to(point: Vector3):
	var v1 = Vector2(position.x, position.z)
	var v2 = Vector2(point.x, point.z)
	return -v1.angle_to_point(v2) + PI / 2
