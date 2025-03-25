extends Node

@onready var enemy_detection = %Head

var can_see_player := false
#awareness is the value from 0-100
#the increase and decrease rate is the rate at which the awareness value increases or decreases in seconds
var awareness := 0.0
var awareness_increase_rate := 5.0
var awareness_decrease_rate := 2.0

var searching_boundary : float = 25.0
var searching_range : float = 9.0
var searching_angle : float = 90.0

var hunting_boundary : float = 90.0
var hunting_range : float = 12.0
var hunting_angle : float = 120.0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_awareness() == 100.0:
		pass
	elif can_see_player:
		set_awareness(get_awareness()+awareness_increase_rate*delta)
	else:
		set_awareness(get_awareness()-awareness_decrease_rate*delta)
	#print("enemy awareness value of: "+str(get_awareness()))
	
	if awareness == 0.0: # idle/wandering
		pass
	elif awareness <= searching_boundary: # searching
		enemy_detection.angle = searching_angle
		enemy_detection.horizontal_range = searching_range
		pass
	elif awareness <= hunting_boundary: # hunting
		enemy_detection.angle = hunting_angle
		enemy_detection.horizontal_range = hunting_range
		pass
	else: # full awareness
		pass

func get_awareness() -> float:
	return awareness

func set_awareness(value:float):
	awareness = value
	awareness = clampf(awareness, 0.0, 100.0)

