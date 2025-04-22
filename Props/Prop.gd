#extends StaticBody3D
#@export var material: String = "wood"
#@export var health: int = 100
#
#func take_damage(amount: int):
	#health -= amount
	#if health <= 0:
		#queue_free()
extends Node3D

@export var material: String = "wood"
@export var health: int = 500  # Use integer for health
@export var destructible: bool = true
@export var burner: Node3D

func _ready():
	burner.Burnt.connect(die)

func take_damage(amount: float, fire := false):
	# Convert float damage to integer (e.g., 0.3 damage accumulates over frames)
	health -= int(amount)
	#if burner != null and fire:
		#if health <= 0 and destructible:
			#burner.burn_out()
		#else:
			#burner.burn_in()
	#elif health <= 0 and destructible:
		#queue_free()  # Destroy when health hits 0
	if health <= 0 and destructible:
		queue_free()  # Destroy when health hits 0

func get_material() -> String:
	return material 

func die():
	queue_free()
