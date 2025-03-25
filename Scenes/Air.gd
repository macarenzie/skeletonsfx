extends StaticBody3D
@export var oxygen: float =1.00 #percent
@export var isThereAnyFire: bool = false
func get_oxygen() -> float:
	return oxygen
func drain_oxygen()-> void:
	if(oxygen>0.02):
		oxygen -=0.001
	else:
		oxygen = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("air") # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#
#extends Area3D
#
#var fire_timer: float = 0.0
#var fire_count: int = 0   # Count of fire objects overlapping
#
#func _ready():
	#body_entered.connect(_on_body_entered)
	#body_exited.connect(_on_body_exited)
	#add_to_group("air")
#
#func _on_body_entered(body: Node3D) -> void:
	## Assume fire objects are added to the "fire" group.
	#if body.is_in_group("fire"):
		#fire_count += 1
		#print("_________________________")
		#print("Firecount = ")
		#print(fire_count)
		#print("_________________________")
#
#func _on_body_exited(body: Node3D) -> void:
	#if body.is_in_group("fire"):
		#fire_count = max(fire_count - 1, 0)
#
#func get_oxygen() -> float:
	#return fire_timer
#
#func _process(delta: float) -> void:
	#if fire_count > 0:
		#fire_timer += delta 
		##* (fire_count +1)
	## Optionally, you could reset the timer when no fire is in contact:
	#else:
		#fire_timer = 0.0
	#print("_________________________")
	#print(fire_timer)
	#print("fire timer = ")
	#print("_________________________")
