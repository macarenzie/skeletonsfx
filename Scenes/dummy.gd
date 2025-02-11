extends Area3D

@export var material: String = "wood"
@export var health: int = 500  # Use integer for health

func take_damage(amount: float):
	# Convert float damage to integer (e.g., 0.3 damage accumulates over frames)
	health -= int(amount)
	print("Dummy health: ", health)
	if health <= 0:
		print("DEAD")
		health +=500  # Destroy when health hits 0
func get_material() -> String:
	return material 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		print("Dummy health: ", health)
