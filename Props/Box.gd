#extends StaticBody3D
#@export var material: String = "wood"
#@export var health: int = 100
#
#func take_damage(amount: int):
	#health -= amount
	#if health <= 0:
		#queue_free()
extends StaticBody3D

@export var material: String = "wood"
@export var health: int = 500  # Use integer for health

func take_damage(amount: float):
	# Convert float damage to integer (e.g., 0.3 damage accumulates over frames)
	health -= int(amount)
	#print("Box health: ", health)
	if health <= 0:
		get_parent().queue_free()  # Destroy when health hits 0
func get_material() -> String:
	return material 
