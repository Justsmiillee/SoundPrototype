
extends CharacterBody3D

@export var speed: float = 5.0
@export var acceleration: float = 15.0
@export var friction: float = 15.0
@export var mouse_sensitivity: float = 0.002

@onready var camera: Camera3D = $Camera3D

var mouse_rotation_x: float = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:

	# Mausbewegung
	if event is InputEventMouseMotion:
		# Charakter drehen (links/rechts)
		rotate_y(-event.relative.x * mouse_sensitivity)

		# Kamera drehen (oben/unten)
		mouse_rotation_x -= event.relative.y * mouse_sensitivity

		mouse_rotation_x = clamp(
			mouse_rotation_x,
			deg_to_rad(-89),
			deg_to_rad(89)
		)

		camera.rotation.x = mouse_rotation_x

	# ESC zum Freigeben der Maus
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _physics_process(delta: float) -> void:

	var input_dir: Vector2 = Input.get_vector(
		"walk_down",
		"walk_up",
		"walk_left",
		"walk_right"
	)

	var direction: Vector3 = transform.basis * Vector3(
		input_dir.x,
		0.0,
		input_dir.y
	)

	direction = direction.normalized()

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

	move_and_slide()
