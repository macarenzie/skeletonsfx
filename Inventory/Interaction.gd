extends Area3D

var invetory = null
var player_in_range = false
var storage = {}

@onready var viewport = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_range:
		if invetory != null:
			if invetory.enemy_item_data != {}:
				storage = invetory.enemy_item_data

func _on_body_entered(body):
	if body.name.match("Player"):
		player_in_range = true
		viewport.visible = true
		invetory = body.find_child("Inventory")
		invetory.in_range = true

func _on_body_exited(body):
	if body.name.match("Player"):
		player_in_range = false
		viewport.visible = false
		invetory = body.find_child("Inventory")
		invetory.in_range = false
		print(storage)
