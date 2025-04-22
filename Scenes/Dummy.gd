extends StaticBody3D

@export var material: String = "wood"
@export var health: int = 500  # Use integer for health
@export var destructible: bool = true

@onready var healthbar = $"../Sprite3D/SubViewport/ColorRect/ProgressBar"
@onready var dummy = $".."

var maxHealth = 0

func _ready():
	healthbar.max_value = health
	healthbar.value = health
	maxHealth = health

func take_damage(amount: float, _fire := false):
	# Convert float damage to integer (e.g., 0.3 damage accumulates over frames)
	health -= int(amount)
	healthbar.value = health
	#print("Dummy health: ", health)
	if health <= 0 and not destructible:
		print("Dummy health: 0 \n YOU'VE KILLED THE DUMMY!")
		health = maxHealth # Destroy when health hits 0
		healthbar.value = maxHealth
	elif  health <= 0 and destructible:
		print("Dummy health: 0 \n YOU'VE KILLED THE DUMMY!")
		dummy.queue_free()

func get_material() -> String:
	return material 
