extends Node

@export var innerFire:float = 250.0
@export var maxInnerFire:float = 250.0 # this is 2 and a half minutes exactly
@export var isInFire:bool = false
@export var fireRegen:float = 0.0

@onready var fireBar = $"../UIController/PlayerUI/ProgressBar"
@onready var firesList = []
@onready var absorber: Area3D = get_parent().get_node("PlayerHead/FireAbsorber")
# Called when the node enters the scene tree for the first time.
func _ready():
	fireBar.max_value = maxInnerFire
	fireBar.value = innerFire
	pass # Replace with function body.


func switch():
	isInFire = !isInFire

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#print(innerFire)
	#print(firesList)
	if firesList != []:
		if innerFire <= maxInnerFire:
			innerFire += 0.1 + fireRegen
	else:
		if (innerFire <=0.0 ):
			#If in world player can't die for testing. 
			if get_tree().current_scene.scene_file_path == "res://Scenes/world.tscn":
				return
			Globals.player_dies.emit()
		elif(innerFire>maxInnerFire):
			innerFire = maxInnerFire
		innerFire -= .028 - fireRegen # aprox. 10 minutes w/o fire till you die

	fireBar.value = innerFire
	
	for area in absorber.get_overlapping_areas():
		 # check the other Area3D’s name
		if area.name == "FireFloorDetector":
			if Input.is_key_pressed(KEY_Q):
				innerFire += 5 *  area.get_parent().size
				area.get_parent().queue_free()
		elif area.name == "InfiniteFireSource":
			if Input.is_key_pressed(KEY_Q):
				innerFire += .1
				print("I AM HEALING")
		elif area.name == "FiniteFireSource":
			if Input.is_key_pressed(KEY_Q):
				innerFire += .1
				print("I Healed once")
				area.get_parent().queue_free()
