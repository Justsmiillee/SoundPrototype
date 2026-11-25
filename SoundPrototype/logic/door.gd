
extends Node3D

@export var open_angle: float = 90.0
@export var animation_speed: float = 3.0

@onready var pivot: Node3D = $DoorPivot
@onready var interaction_area: Area3D = $DoorPivot/InteractionArea

var is_open: bool = false
var player_near: bool = false

var closed_rotation: float = 0.0
var target_rotation: float = 0.0


func _ready() -> void:
	closed_rotation = pivot.rotation.y
	target_rotation = closed_rotation

	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)


func _process(delta: float) -> void:

	if player_near and Input.is_action_just_pressed("interact"):
		is_open = not is_open
		play_door_footstep()

		if is_open:
			target_rotation = closed_rotation + deg_to_rad(open_angle)
		else:
			target_rotation = closed_rotation

	pivot.rotation.y = lerp_angle(
		pivot.rotation.y,
		target_rotation,
		1.0 - exp(-animation_speed * delta)
	)


func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		player_near = true


func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		player_near = false
		

func play_door_footstep() -> void:
	FmodServer.play_one_shot("event:/Door")
