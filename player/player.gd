extends CharacterBody2D

const SPEED = 100
const ACCELERATION = 800
const FRICTION = 800

@export var spawn_point := Vector2.ZERO
var facing_right = true   # true = right, false = left

func _physics_process(delta: float) -> void:
	player_movement(delta)

func player_movement(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Update facing direction ONLY from horizontal input
	if input_dir.x > 0:
		facing_right = true
	elif input_dir.x < 0:
		facing_right = false

	# Smooth movement
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(input_dir * SPEED, ACCELERATION * delta)
		play_anim(true)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		play_anim(false)

	move_and_slide()
	
	
func play_anim(is_moving: bool):
	var animation = $AnimatedSprite2D
	
	# Flip based on last horizontal direction
	animation.flip_h = not facing_right
	
	if is_moving:
		animation.play("walk")
	else:
		animation.play("idle")
