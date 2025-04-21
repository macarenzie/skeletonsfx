extends CharacterBody3D
# this script controls player movement 
@onready var anim_player = $"AM_PlayerIdle/AnimationPlayer"
@export_category("Movement")
@export var speed = 5.0
@export var sprint_multiplier = 1 # I don't know if the game is going to have sprinting in it, but for me phillip i want this just for debuging, if you set this to 0 it's effectively disabled
const jump_velocity = 4.5
@export var oxygen: float = 1.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	add_to_group("player")
	# Connect signals from the player air detector (an Area3D child)
	$PlayerAirDetector.area_entered.connect(_on_air_entered)
	$PlayerAirDetector.area_exited.connect(_on_air_exited)
	anim_player.play("PlayerIdle/Idle")

func decrement_oxygen(delta: float) -> void:
	oxygen = max(oxygen - 0.01 * delta, 0)

func _on_air_entered(area: Area3D) -> void:
	 # Check if the area we entered is a room's Air node (assumed to be in the "air" group)
	print("AIR ENTERED")
	

func _on_air_exited(area: Area3D) -> void:
	# (Optional) Do something when exiting a room's air area.
	if area.is_in_group("air"):
		 # Reset oxygen to one
		oxygen = 1.0
		# Destroy all fires in the scene immediately
		for fire in get_tree().get_nodes_in_group("fire"):
			fire.queue_free()
			print("Room transition: oxygen reset and fires destroyed.")
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#var sprint_mod = 1
	#if Input.is_action_pressed("sprint"):
	#	sprint_mod += sprint_multiplier              
	
	if direction:
		velocity.x = direction.x * speed# * sprint_mod
		velocity.z = direction.z * speed# * sprint_mod
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


