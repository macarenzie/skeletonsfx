extends Node
# this script houses all the combat for the player, attacking, blocking

@onready var anim_player = $"../AM_PlayerIdle/AnimationPlayer"

@onready var hitList = []
@onready var inventory = $"../UIController/Inventory"
@onready var shieldHolder = $"../PlayerHead/ShieldHolder"
@onready var weapon_area = $"../PlayerHead/WeaponHolder/Weapon/Area3D"
@onready var block_symbol = $"../UIController/Blocking"
@onready var weapon_shape = $"../PlayerHead/WeaponHolder/Weapon/Area3D/CollisionShape3D"

@export_category("Health") # I don't feel like these should be here but it's going to be here at the moment
@export var max_health : int = 100
var current_health : int

@export_category("Attacking")
@export var attack_distance : float = 2.0
@export var attack_delay : float =  0 #0.4
@export var attack_speed : float = 0 #1.0
@export var attack_damage : int = 0 #10
@onready var attack_ray : RayCast3D = %RayCast3D
var attacking : bool = false
var ready_to_attack : bool = true

@export_category("Blocking")
@export var block_startup : float = 0 #1.0
@export var block_endlag : float = 0 #0.5
@export var block_damage_reduction : float = 0 #0.5 # the percent of damage taken while blocking
@export var block_angle : float = 0 #60.0 # the angle where if you are blocking and the attack comes from within this angle it is blocked
var blocking : bool = false
var ready_to_block : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.animation_finished.connect(reset_animation)
	current_health = max_health
	block_symbol.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if inventory.slot_1 != []:
		#print($"../PlayerHead/WeaponHolder/Weapon/Area3D/CollisionShape3D".shape.get_size())
		$"../PlayerHead/WeaponHolder".visible = true
	else:
		$"../PlayerHead/WeaponHolder".visible = false
	
	if inventory.slot_2 != []:
		shieldHolder.visible = true
	else:
		shieldHolder.visible = false
	
	if Input.is_action_just_pressed("block") and shieldHolder.visible == true:
		start_block()
	elif Input.is_action_pressed("block") and shieldHolder.visible == true:
		block()
	elif Input.is_action_just_released("block") and shieldHolder.visible == true:
		#block_symbol.visible = false
		end_block()
	elif Input.is_action_pressed("attack") and $"../PlayerHead/WeaponHolder".visible == true: 
		attack()
	elif Input.is_action_just_pressed("fire") && Input.is_key_pressed(KEY_Q) == false:
		fire()
	
	if !blocking:
		$"../UIController/Crosshair".visible = true
		block_symbol.visible = false

#functions for stat_changes in combat
func take_damage(originator:Node,value:int):
	#find if the origin of the hit was within the block angle
	var player : Node = get_parent()
	var player_to_attacker = Vector2(player.posistion.x-originator.position.x,player.position.z-originator.position.z).normalized()
	var facing_direction = Vector2(sin(player.rotation.y),cos(player.rotation.y)).normalized()
	var incoming_angle = rad_to_deg(acos(player_to_attacker.dot(facing_direction)))
	#print(player_to_attacker.dot(facing_direction))

	if blocking and incoming_angle < block_angle*0.5:
		var original_value = value
		value = int(value * block_damage_reduction)
		#print("Player took "+str(value)+" points of damage after blocking to their lifeforce. Was originally "+str(original_value)+" points of damage")
	else:
		#print("Player took "+str(value)+" points of damage to their lifeforce")
		pass
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
	$"../AM_PlayerIdle/CM_Skeleton_Skeleton_Rig/Skeleton3D/P_Sword/P_Sword".visible = true
	anim_player.play("PlayerAttack/Attack")
	
	#var new_fire = load("res://Fire/Fire.tscn").instantiate()
	#new_fire.global_position = get_parent().position
	#get_parent().get_parent().add_child(new_fire)
	
	#var innerfire = get_parent().get_child(6)
	#innerfire.innerFire - 30.0

func reset_attack():
	print("ATAAAAAAAAAAAAACK!")
	hitList.clear()
	attacking = false
	ready_to_attack = true
	ready_to_block = true
	
	anim_player.play("PlayerIdle/Idle")

func attack_raycast():
	attack_ray.target_position = Vector3(0,0,-attack_distance)
	attack_ray.force_raycast_update()
	if !attack_ray.is_colliding(): #if it's not colliding with anything don't continue
		return
	if !attack_ray.get_collider() is Hittable: #if it's not hittable don't continue
		return
	var object_hit : Hittable = attack_ray.get_collider()
	print("I hit "+object_hit.to_string())
	if(!object_hit.get_parent().get_parent().is_in_group("fire")):
		object_hit.hit(self,attack_damage)
		print("obj hit")
	else:
		get_parent().get_node("InnerFire").innerFire += 20.0
		object_hit.queue_free()
		print("Fire hit!")

#functions for blocking
func start_block():
	if not ready_to_block and attacking:
		return
	ready_to_attack = false
	$"../AM_PlayerIdle/CM_Skeleton_Skeleton_Rig/Skeleton3D/P_Shield/P_Shield".visible = true
	anim_player.play("PlayerBlock/Block")
	anim_player.seek(1.0, true)  # Seek to pose and update immediately
	anim_player.pause()

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
	anim_player.play("PlayerBlock/Block")
	anim_player.seek(1.0)
	#anim_player.playback_speed = 1
	anim_player.play()
	anim_player.play("PlayerIdle/Idle")
	pass

func reset_block():
	blocking = false
	ready_to_attack = true
	ready_to_block = true
	print("BlockReset")

func reset_animation(anim_name):
	if anim_name == "attack" or anim_name == "block_end":
		anim_player.play("idle")

func fire():
	var new_fire = load("res://Fire/Fire.tscn").instantiate()
	new_fire.global_position = get_parent().position + Vector3(0, 0.8, 0)
	get_parent().get_parent().add_child(new_fire)
# Access camera
	var camera = get_parent().get_node("PlayerHead/PlayerCamera")
	if camera == null:
		print("Camera not found!")
		return
	var forward = -camera.global_transform.basis.z.normalized()  # forward = -Z
	var up = Vector3.UP  # global up
	
	# Combine forward and up for 45-degree arc
	var launch_direction = (forward + up/2).normalized()
	
	# Scale force
	var force = launch_direction * 25  # adjust this for more/less power
	
	# Apply the force
	new_fire.apply_force(force)
	var innerfire = %InnerFire
	innerfire.innerFire - 30.0


#Temparary weapon damage Code. 
func _on_area_3d_body_entered(body):
	if body.has_method("take_damage") and not hitList.has(body) and attacking:
		hitList.append(body)
		body.take_damage(attack_damage)

#
