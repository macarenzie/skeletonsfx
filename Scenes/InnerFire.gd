extends Node

@export var innerFire:float = 100.0
@export var maxInnerFire:float = 100.0
@export var isInFire:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func switch():
	isInFire = !isInFire

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print(innerFire)
	if(isInFire):
		if innerFire <= maxInnerFire:
			innerFire += 0.1
	else:
		if (innerFire <=0.0 ):
			get_tree().reload_current_scene() # you died
		innerFire -= .4
