extends Area3D

var invetory = null
var player_in_range = false
var storage = {0: [1,32,90], 1: [2,15,0], 2:[2,60,180]}
var old_storage = {}

@onready var viewport = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport.visible = false
	old_storage = storage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if player_in_range:
		#if invetory != null:
			#print(storage)
			#if invetory.is_Loaded:
				#storage = invetory.pull_enemy_grid()
				

func _on_body_entered(body):
	if body.name.match("Player"):
		player_in_range = true
		viewport.visible = true
		invetory = body.find_child("Inventory")
		invetory.in_range = true
		invetory.load_enemy_grid(storage)

func _on_body_exited(body):
	if body.name.match("Player"):
		player_in_range = false
		viewport.visible = false
		invetory = body.find_child("Inventory")
		invetory.in_range = false
		storage = invetory.left_looting_area()
		#print(storage)
