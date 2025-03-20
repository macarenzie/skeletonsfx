extends Node3D

@export var angle : float = 120.0 #degrees
@export var horizontal_range : float = 4.0
@export var vertical_range : float  = 3.0
@onready var player : Node3D
@onready var ray_to_player : RayCast3D = %RayToPlayer
var range_check : bool
var angle_check : bool
var local_player : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# finding out where the player is relative to the enemy
	local_player = to_local(player.position)
	ray_to_player.set_target_position(Vector3(local_player.x,0,local_player.z))
	range_check = local_player.length() < horizontal_range
	angle_check = (-basis.z).dot(local_player.normalized()) > cos(deg_to_rad(angle/2))
	if range_check and angle_check:
		Player_Detected.emit(player.position)
		
signal Player_Detected(position:Vector3)
