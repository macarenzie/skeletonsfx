extends Area3D

var invetory = null
@onready var viewport = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

signal nearPlayer
signal notNearPlayer

func _on_body_entered(body):
	if body.name.match("Player"):
		print("lets go")
		viewport.visible = true
		invetory = body.find_child("Inventory")
		invetory.in_range = true



func _on_body_exited(body):
	if body.name.match("Player"):
		print("you left")
		viewport.visible = false
		invetory = body.find_child("Inventory")
		invetory.in_range = false
