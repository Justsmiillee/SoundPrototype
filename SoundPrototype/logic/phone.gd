
extends Node3D

# FMOD-Sound-Nodes
@onready var ring_sound: FmodEventEmitter3D = $RingPos/RingSound
@onready var pickup_sound: FmodEventEmitter3D = $RingPos/DialSound

# Bereiche
@onready var interaction_area: Area3D = $InteractArea

# Hier im Inspector die InteriorArea aus dem Haus hineinziehen
@export var interior_area: Area3D

# Einstellungen
@export_range(0.0, 1.0) var inside_volume: float = 1.0
@export_range(0.0, 1.0) var outside_volume: float = 0.2

var player_in_range: bool = false
var player_inside: bool = false
var is_ringing: bool = true
var phone_used: bool = false


func _ready():
	# Interaktionssignale
	interaction_area.body_entered.connect(_on_interaction_entered)
	interaction_area.body_exited.connect(_on_interaction_exited)

	# Innen-/Außensignale
	if interior_area:
		interior_area.body_entered.connect(_on_interior_entered)
		interior_area.body_exited.connect(_on_interior_exited)

	# Klingeln starten
	ring_sound.volume = outside_volume
	ring_sound.play()


func _process(_delta):
	if player_in_range and not phone_used:
		if Input.is_action_just_pressed("interact"):
			pickup_phone()


# Spieler kommt in Reichweite des Telefons
func _on_interaction_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		print("Drücke E, um das Telefon abzunehmen")


# Spieler verlässt Reichweite
func _on_interaction_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false


# Spieler betritt das Haus
func _on_interior_entered(body):
	if body.is_in_group("Player"):
		player_inside = true
		update_ring_volume()


# Spieler verlässt das Haus
func _on_interior_exited(body):
	if body.is_in_group("Player"):
		player_inside = false
		update_ring_volume()


# Lautstärke abhängig vom Aufenthaltsort
func update_ring_volume():
	if is_ringing:
		if player_inside:
			ring_sound.volume = inside_volume
		else:
			ring_sound.volume = outside_volume


# Telefon wird abgenommen
func pickup_phone():
	if phone_used:
		return

	phone_used = true
	is_ringing = false

	# Klingeln sofort stoppen
	ring_sound.stop()

	# Abheben-Sound abspielen
	pickup_sound.play_one_shot()

	print("Telefon wurde abgenommen!")
