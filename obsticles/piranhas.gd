extends Area2D

var active := false:
	set(val):
		active = val
		$GPUParticles2D.emitting = val
@export var loop_speed := 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(kill_player)
	var tween = create_tween().set_loops().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "active", true, loop_speed / 2)
	tween.tween_property(self, "active", false, loop_speed / 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func kill_player(body: CollisionObject2D):
	if body.is_in_group("player") and active:
		body.die()
