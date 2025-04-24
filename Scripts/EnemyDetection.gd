extends Node3D

@onready var enemy_behavior = %EnemyBehavior

@export var angle : float = 120.0 #degrees
@export var forward_pathfinding_detection_range : float = 4.0 # detection in the direction that they are looking
@export var vicinity_pathfinding_detection_range : float = 1.0 # detection in immediate vicinity
@export var forward_attack_detection_range : float = 3.0 # the range that when the player is in the enemy will decide to attack, determined by the attack range of the enemy

@onready var player : Node3D
@onready var ray_to_player : RayCast3D = %RayToPlayer
var attack_range_check : bool
var detection_range_check : bool
var short_range_check : bool
var angle_check : bool
var local_player : Vector3

signal Attack_Player
signal Player_Detected(position:Vector3)

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	#forward_attack_detection_range 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# finding out where the player is relative to the enemy
	local_player = to_local(player.position)
	ray_to_player.set_target_position(Vector3(local_player))
	detection_range_check = local_player.length() < forward_pathfinding_detection_range
	short_range_check = local_player.length() < vicinity_pathfinding_detection_range
	attack_range_check = local_player.length() <= forward_attack_detection_range
	angle_check = Vector3.FORWARD.dot(local_player.normalized()) > cos(deg_to_rad(angle/2))
	#print(Vector3.FORWARD.dot(local_player.normalized()))
	#print(angle_check)
	enemy_behavior.can_see_player = false
	if attack_range_check and angle_check and not enemy_behavior.attacking_player:
		#print("I want to attack")
		Attack_Player.emit()
	if short_range_check:
		Player_Detected.emit(player.position)	
		enemy_behavior.can_see_player = true
	elif detection_range_check and angle_check:
		if not ray_to_player.is_colliding():
			return
		if ray_to_player.get_collider() != player:
			return
		Player_Detected.emit(player.position)	
		enemy_behavior.can_see_player = true
	elif enemy_behavior.get_awareness() == 100.0:
		Player_Detected.emit(player.position)	
		enemy_behavior.can_see_player = true

