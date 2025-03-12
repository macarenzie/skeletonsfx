extends Node3D

@export var angle : float = 120.0 #degrees
@export var horizontal_range : float = 4.0
@export var vertical_range : float  = 3.0
@onready var left_ray_cast_3d = $LeftRayCast3D
@onready var right_ray_cast_3d = $RightRayCast3D
@onready var player : Node3D
var ray_to_player : RayCast3D
@onready var head = $"."


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	left_ray_cast_3d.set_target_position(Vector3(sin(deg_to_rad(-angle/2 + 180)),0,cos(deg_to_rad(-angle/2 + 180))).normalized()*horizontal_range)
	right_ray_cast_3d.set_target_position(Vector3(sin(deg_to_rad(angle/2 + 180)),0,cos(deg_to_rad(angle/2 + 180))).normalized()*horizontal_range)
	var forward = RayCast3D.new()
	forward.set_target_position(Vector3.FORWARD*horizontal_range)
	head.add_child(forward)
	ray_to_player = RayCast3D.new()
	head.add_child(ray_to_player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# finding out where the player is relative to the enemy
	var local_player := Vector3(player.position.x,0,player.position.z) - Vector3(global_position.x,0,global_position.z)
	ray_to_player.set_target_position(Vector3(local_player.x,0,local_player.z))
	
	# debug stuff
	var range_check := local_player.length() < horizontal_range
	var angle_check := Vector3.FORWARD.dot(local_player.normalized()) > cos(deg_to_rad(angle/2))
	if range_check and angle_check:
		ray_to_player.set_debug_shape_custom_color(Color("green"))
		# this line isnt debug, but commented out for now
		#Player_Detected.emit(player.position)
	elif range_check and not angle_check:
		ray_to_player.set_debug_shape_custom_color(Color("red"))
	elif angle_check and not range_check:
		ray_to_player.set_debug_shape_custom_color(Color("blue"))
	else:
		ray_to_player.set_debug_shape_custom_color(Color(0.0, 0.0, 0.0))
	pass

signal Player_Detected(position:Vector3)
