
extends CharacterBody3D

@export var speed: float = 5.0
@export var acceleration: float = 15.0
@export var friction: float = 15.0

func _physics_process(delta: float) -> void:

	# Eingabe abfragen
	var input_dir: Vector2 = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	# Bewegungsrichtung berechnen
	var direction: Vector3 = transform.basis * Vector3(
		input_dir.x,
		0.0,
		input_dir.y
	)

	direction = direction.normalized()

	# Bewegung
	if direction.length() > 0.0:
		velocity.x = move_toward(
			velocity.x,
			direction.x * speed,
			acceleration * delta
		)

		velocity.z = move_toward(
			velocity.z,
			direction.z * speed,
			acceleration * delta
		)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
		velocity.z = move_toward(velocity.z, 0.0, friction * delta)

	# Schwerkraft
	if not is_on_floor():
		velocity.y -= float(
			ProjectSettings.get_setting("physics/3d/default_gravity")
		) * delta

	# Physik ausführen
	move_and_slide()
