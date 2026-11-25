
extends Area3D

@export var step_interval: float = 0.85

var player_inside: bool = false
var player_moving: bool = false

var step_timer: Timer


func _ready() -> void:
	step_timer = Timer.new()
	step_timer.wait_time = step_interval
	step_timer.one_shot = false
	add_child(step_timer)

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	step_timer.timeout.connect(_on_step_timer_timeout)


func _process(_delta: float) -> void:
	if not player_inside:
		return

	# Alle Bewegungstasten gemeinsam prüfen
	var movement = Input.get_vector(
		"walk_left",
		"walk_right",
		"walk_up",
		"walk_down"
	)

	# Nur prüfen, ob eine Bewegung stattfindet
	var is_moving = movement.length() > 0.1

	# Bewegung gestartet
	if is_moving and not player_moving:
		player_moving = true

		play_wood_footstep()
		step_timer.start()

	# Bewegung beendet
	elif not is_moving and player_moving:
		player_moving = false
		step_timer.stop()


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_inside = true


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_inside = false
		player_moving = false
		step_timer.stop()


func _on_step_timer_timeout() -> void:
	if player_inside and player_moving:
		play_wood_footstep()


func play_wood_footstep() -> void:
	FmodServer.play_one_shot("event:/GrassFootsteps")
