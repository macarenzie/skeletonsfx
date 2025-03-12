extends Node

var awareness : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_awareness():
	return awareness

func set_awareness(value:float):
	awareness += value
	awareness = clampf(awareness, 0.0, 100.0)
