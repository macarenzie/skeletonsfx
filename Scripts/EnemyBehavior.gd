extends Node

@onready var enemy_detection = %Head
@onready var enemy_pathfinding = $".."
@onready var hit_box = %WeaponHitBox
@onready var animation_player = $"../AnimationPlayer"



@export var attacking_player := false
var can_see_player := false

var attack_landed := false
var damage := 50.0

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

func _physics_process(delta):
	print("physics process")
	if not attacking_player:
		print("not attacking the player")
		return
	print("trying to attack the player")
	if attack_landed:
		print("attack was already hit")
		return
	print("attack hasn't hit yet")
	if not hit_box.enabled:
		print("hit box isnt active")
		return
	print("hit box is active")
	# the line that get the object the hit box is touching
	hit_box.force_shapecast_update()
	var obj_hit = hit_box.get_collider(0)
	print(obj_hit)
	if obj_hit == null:
		print("obj detected was null")
		return
	print("hit the player")
		
	# the next two lines virtually have the same effect
	attack_landed = true
	hit_box.set_enabled(false)		
	# the line that does the damage to the player
	obj_hit.get_child(6).innerFire = obj_hit.get_child(6).innerFire - damage

func get_awareness() -> float:
	return awareness

func set_awareness(value:float):
	awareness = value
	awareness = clampf(awareness, 0.0, 100.0)

func _on_head_attack_player():
	if not attacking_player:
		#attacking_player = true
		attack_landed = false
		animation_player.play("attack")
		animation_player.queue("idle")
		#temporary timed function to act as the time an animation would run for
		#Scheduler.schedule(func(): 
		#	attacking_player = false
		#	print("i can move again")
		#, 1.0)
		pass # Replace with function body.
