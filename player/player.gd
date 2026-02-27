extends CharacterBody2D

const SPEED = 100
const ACCELERATION = 800
const FRICTION = 800

var current_dir = "down"

func _physics_process(delta: float) -> void:
	player_movement(delta)

func player_movement(delta):
	var input_dir = Vector2.ZERO

	# Only ONE direction allowed (priority order)
	if Input.is_action_pressed("ui_right"):
		input_dir = Vector2.RIGHT
		current_dir = "right"
	elif Input.is_action_pressed("ui_left"):
		input_dir = Vector2.LEFT
		current_dir = "left"
	elif Input.is_action_pressed("ui_down"):
		input_dir = Vector2.DOWN
		current_dir = "down"
	elif Input.is_action_pressed("ui_up"):
		input_dir = Vector2.UP
		current_dir = "up"

	# Smooth acceleration / stopping
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(input_dir * SPEED, ACCELERATION * delta)
		play_anim(true)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		play_anim(false)

	move_and_slide()
	
func play_anim(is_moving: bool):
	var animation = $AnimatedSprite2D
	
	match current_dir:
		"right":
			animation.flip_h = false
			animation.play("side walk" if is_moving else "side idle")
		
		"left":
			animation.flip_h = true
			animation.play("side walk" if is_moving else "side idle")
		
		"down":
			animation.flip_h = false
			animation.play("down walk" if is_moving else "down idle")
		
		"up":
			animation.flip_h = false
			animation.play("up walk" if is_moving else "up idle")
	
	
	
