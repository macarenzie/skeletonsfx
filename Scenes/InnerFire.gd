extends Node

signal player_dies()

@export var innerFire:float = 1000.0
@export var maxInnerFire:float = 1000.0
@export var isInFire:bool = false
@export var fireRegen:float = 0.0

@onready var fireBar = $"../UIController/PlayerUI/ProgressBar"
@onready var firesList = []
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
	print(firesList)
	if firesList != []:
		if innerFire <= maxInnerFire:
			innerFire += 0.1 + fireRegen
	else:
		if (innerFire <=0.0 ):
			#If in world player can't die for testing. 
			if get_tree().current_scene.scene_file_path == "res://Scenes/world.tscn":
				return
			player_dies.emit()
		innerFire -= .028 - fireRegen # aprox. 10 minutes w/o fire till you die

	fireBar.value = innerFire
