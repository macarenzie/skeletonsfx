extends Node

@onready var enemy_detection = %Head
@onready var enemy_pathfinding = $".."


var attacking_player := false
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

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_awareness() == 100.0:
		pass
	elif can_see_player:
		set_awareness(get_awareness()+awareness_increase_rate*delta)
	else:
		set_awareness(get_awareness()-awareness_decrease_rate*delta)
	
	#print("i can see the player" if can_see_player else "i cant see the player")
	
	if awareness == 0.0: # idle/wandering
		pass
	elif awareness <= searching_boundary: # searching
		enemy_detection.angle = searching_angle
		enemy_detection.forward_pathfinding_detection_range = searching_range
		pass
	elif awareness <= hunting_boundary: # hunting
		enemy_detection.angle = hunting_angle
		enemy_detection.forward_pathfinding_detection_range = hunting_range
		pass
	else: # full awareness
		pass

func get_awareness() -> float:
	return awareness

func set_awareness(value:float):
	awareness = value
	awareness = clampf(awareness, 0.0, 100.0)

func _on_head_attack_player():
	attacking_player = true
	#temporary timed function to act as the time an animation would run for
	Scheduler.schedule(func(): 
		attacking_player = false
		print("i can move again")
	, 1.0)
	pass # Replace with function body.
