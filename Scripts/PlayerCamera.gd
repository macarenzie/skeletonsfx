extends Camera3D
# this script controls the player camera through rotating the player and tilting their head

@export var SENSITIVITY_X : float = 0.02
@export var SENSITIVITY_Y : float = 0.02

@onready var player = $"../.."
@onready var head = %PlayerHead

func _ready():
	# capture and hide mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		#grab motion of mouse and rotate camera
		player.rotate_y(-event.relative.x * SENSITIVITY_X)
		head.rotate_x(-event.relative.y * SENSITIVITY_Y)
		#clamp the rotation so that it doesnt flip upside down
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#if Input.is_action_just_pressed("quit"):
	#	get_tree().quit()
	pass

