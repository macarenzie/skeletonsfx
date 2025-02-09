extends CharacterBody3D
# this script controls player movement 

@export_category("Movement")
@export var speed = 5.0
@export var sprint_multiplier = 1 # I don't know if the game is going to have sprinting in it, but for me phillip i want this just for debuging, if you set this to 0 it's effectively disabled
const jump_velocity = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


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
	var sprint_mod = 1
	if Input.is_action_pressed("sprint"):
		sprint_mod += sprint_multiplier
	
	if direction:
		velocity.x = direction.x * speed * sprint_mod
		velocity.z = direction.z * speed * sprint_mod
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


