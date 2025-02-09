extends Node

@onready var anim_player = %AnimationPlayer

@export_category("Attacking")
@export var attack_distance : float = 2.0
@export var attack_delay : float = 0.4
@export var attack_speed : float = 1.0
var attacking : bool = false
var ready_to_attack : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.animation_finished.connect(reset_animation)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("attack"): 
		attack()
	pass

#functions for attacking
func attack():
	if not ready_to_attack or attacking:
		return
	ready_to_attack = false;
	attacking = true;
	
	Scheduler.schedule(reset_attack, attack_speed)
	Scheduler.schedule(attack_raycast, attack_delay)

	anim_player.play("attack")
	
	var new_fire = load("res://Fire/Fire.tscn").instantiate()
	new_fire.global_position = get_parent().position;
	get_parent().get_parent().add_child(new_fire)
	var innerfire = get_parent().get_child(6)
	innerfire.innerFire - 30.0

func reset_attack():
	attacking = false
	ready_to_attack = true

func attack_raycast():
	#var raycast = RayCast3D.new()
	pass

func reset_animation():
	if anim_player.current_animation == "attack":
		anim_player.play("idle")

