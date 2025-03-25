extends Node3D

@onready var enemy_behavior = %EnemyBehavior

@export var angle : float = 120.0 #degrees
@export var horizontal_range : float = 4.0 # detection in the direction that they are looking
@export var surrounding_range : float = 1.0 # detection in immediate vicinity
@export var vertical_range : float  = 3.0
@onready var player : Node3D
@onready var ray_to_player : RayCast3D = %RayToPlayer
var range_check : bool
var short_range_check : bool
var angle_check : bool
var local_player : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# finding out where the player is relative to the enemy
	local_player = to_local(player.position)
	ray_to_player.set_target_position(Vector3(local_player))
	range_check = local_player.length() < horizontal_range
	short_range_check = local_player.length() < surrounding_range
	angle_check = Vector3.FORWARD.dot(local_player.normalized()) > cos(deg_to_rad(angle/2))
	enemy_behavior.can_see_player = false
	if short_range_check:
		Player_Detected.emit(player.position)	
		enemy_behavior.can_see_player = true
	elif range_check and angle_check:
		if not ray_to_player.is_colliding():
			return
		if ray_to_player.get_collider() != player:
			return
		Player_Detected.emit(player.position)	
		enemy_behavior.can_see_player = true
		

signal Player_Detected(position:Vector3)
