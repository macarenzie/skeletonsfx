extends Node
# this script houses all the combat for the player, attacking, blocking

@onready var anim_player = %AnimationPlayer

@export_category("Attacking")
@export var attack_distance : float = 2.0
@export var attack_delay : float = 0.4
@export var attack_speed : float = 1.0
@onready var attack_ray : RayCast3D = %RayCast3D
var attacking : bool = false
var ready_to_attack : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.animation_finished.connect(reset_animation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("attack"): 
		attack()

#functions for attacking
func attack():
	if not ready_to_attack or attacking:
		return
	ready_to_attack = false;
	attacking = true;
	
	Scheduler.schedule(reset_attack, attack_speed)
	Scheduler.schedule(attack_raycast, attack_delay)

	anim_player.play("attack")

func reset_attack():
	attacking = false
	ready_to_attack = true

func attack_raycast():
	attack_ray.target_position = Vector3(0,0,-attack_distance)
	attack_ray.force_raycast_update()
	if !attack_ray.is_colliding(): #if it's not colliding with anything don't continue
		return
	var object_hit : Hittable = attack_ray.get_collider()
	print("I hit "+object_hit.to_string())
	object_hit.hit()

func reset_animation(_anim_name):
	if _anim_name == "attack":
		anim_player.play("idle")

