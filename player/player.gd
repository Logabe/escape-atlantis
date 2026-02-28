extends CharacterBody2D

# ========================
# Movement Settings
# ========================
const SPEED = 100
const ACCELERATION = 800
const FRICTION = 800

# ========================
# Roll Settings
# ========================
const ROLL_SPEED = 200
const ROLL_DURATION = 0.1
const ROLL_COOLDOWN = 1.0

@export var spawn_point := Vector2.ZERO

# ========================
# State Variables
# ========================
var facing_right = true
var is_rolling = false
var roll_timer = 0.0
var cooldown_timer = 0.0
var roll_count = 0


func _physics_process(delta: float) -> void:
	handle_roll(delta)

	if not is_rolling:
		player_movement(delta)

	move_and_slide()


# ========================
# Movement
# ========================
func player_movement(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Update facing direction from horizontal input
	if input_dir.x > 0:
		facing_right = true
	elif input_dir.x < 0:
		facing_right = false

	# Smooth acceleration / stopping
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(input_dir * SPEED, ACCELERATION * delta)
		play_anim(true)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		play_anim(false)


# ========================
# Roll System
# ========================
func handle_roll(delta):

	# Reduce cooldown timer
	if cooldown_timer > 0.0:
		cooldown_timer -= delta

	# Start roll (Space key = ui_accept by default)
	if Input.is_action_just_pressed("ui_accept") and cooldown_timer <= 0 and not is_rolling:
		start_roll()

	# During roll
	if is_rolling:
		roll_timer -= delta
		if roll_timer <= 0:
			end_roll()


func start_roll():
	is_rolling = true
	roll_timer = ROLL_DURATION
	cooldown_timer = ROLL_COOLDOWN
	roll_count += 1

	print("Roll count:", roll_count)
	$AnimatedSprite2D.play("roll")
	# Roll forward based on facing direction
	if facing_right:
		velocity = Vector2.RIGHT * ROLL_SPEED
	else:
		velocity = Vector2.LEFT * ROLL_SPEED

	


func end_roll():
	is_rolling = false


# ========================
# Animation
# ========================
func play_anim(is_moving: bool):
	var animation = $AnimatedSprite2D

	# Flip sprite based on facing
	animation.flip_h = not facing_right

	# Don't override roll animation
	if is_rolling:
		animation.play("roll")

	if is_moving:
		animation.play("walk")
	else:
		animation.play("idle")


# ========================
# Respawn
# ========================
func die():
	position = spawn_point
