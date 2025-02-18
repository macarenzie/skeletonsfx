extends StaticBody3D

@export var material: String = "wood"
@export var health: int = 500  # Use integer for health

func take_damage(amount: float):
	# Convert float damage to integer (e.g., 0.3 damage accumulates over frames)
	health -= int(amount)
	print("Dummy health: ", health)
	if health <= 0:
		print("Dummy health: 0 \n YOU'VE KILLED THE DUMMY!")
		health = 500 # Destroy when health hits 0
func get_material() -> String:
	return material 
