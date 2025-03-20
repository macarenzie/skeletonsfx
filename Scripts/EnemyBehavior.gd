extends Node


var can_see_player := false

#awareness is the value from 0-100
#the increase and decrease rate is the rate at which the awareness value increases or decreases in seconds
var awareness := 0.0
var awareness_increase_rate := 5.0
var awareness_decrease_rate := 2.0

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


