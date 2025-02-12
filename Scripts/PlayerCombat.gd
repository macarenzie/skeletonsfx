extends Node
# this script houses all the combat for the player, attacking, blocking

@onready var anim_player = %AnimationPlayer

@export_category("Health") # I don't feel like these should be here but it's going to be here at the moment
@export var max_health : int = 100
var current_health : int

@export_category("Attacking")
@export var attack_distance : float = 2.0
@export var attack_delay : float = 0.4
@export var attack_speed : float = 1.0
@export var attack_damage : int = 10
@onready var attack_ray : RayCast3D = %RayCast3D
var attacking : bool = false
var ready_to_attack : bool = true

@export_category("Blocking")
@export var block_startup : float = 1.0
@export var block_endlag : float = 0.5
@export var block_damage_reduction : float = 0.5 #the percent of damage taken while blocking
var blocking : bool = false
var ready_to_block : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.animation_finished.connect(reset_animation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("block"):
		start_block()
	elif Input.is_action_pressed("block"):
		block()
	elif Input.is_action_just_released("block"):
		end_block()
	elif Input.is_action_pressed("attack"): 
		attack()

#functions for stat_changes in combat
func take_damage(value):
	if blocking:
		var original_value = value
		value = int(value * block_damage_reduction)
		print("Player took "+str(value)+" points of damage after blocking to their lifeforce. Was originally "+str(original_value)+" points of damage")
	else:
		print("Player took "+str(value)+" points of damage to their lifeforce")
	current_health -= value

#functions for attacking
func attack():
	if not ready_to_attack or attacking:
		return
	ready_to_attack = false
	attacking = true
	ready_to_block = false
	
	Scheduler.schedule(reset_attack, attack_speed)
	Scheduler.schedule(attack_raycast, attack_delay)

	anim_player.play("attack")
	
	var new_fire = load("res://Fire/Fire.tscn").instantiate()
	new_fire.global_position = get_parent().position
	get_parent().get_parent().add_child(new_fire)
	var innerfire = get_parent().get_child(6)
	innerfire.innerFire - 30.0

func reset_attack():
	attacking = false
	ready_to_attack = true
	ready_to_block = true

func attack_raycast():
	attack_ray.target_position = Vector3(0,0,-attack_distance)
	attack_ray.force_raycast_update()
	if !attack_ray.is_colliding(): #if it's not colliding with anything don't continue
		return
	if !attack_ray.get_collider() is Hittable: #if it's not hittable don't continue
		return
	var object_hit : Hittable = attack_ray.get_collider()
	print("I hit "+object_hit.to_string())
	object_hit.hit(attack_damage)

func start_block():
	if not ready_to_block and attacking:
		return
	ready_to_attack = false
	anim_player.play("block_start")
	anim_player.queue("block_active")

func block():
	blocking = true
	if anim_player.current_animation == "block_start":
		return
	anim_player.play("block_active")

func end_block():
	if not blocking:
		return
	blocking = false
	Scheduler.schedule(reset_block, block_endlag)
	anim_player.play("block_end")
	pass
	
func reset_block():
	blocking = false
	ready_to_attack = true
	ready_to_block = true

func reset_animation(anim_name):
	if anim_name == "attack" or anim_name == "block_end":
		anim_player.play("idle")

