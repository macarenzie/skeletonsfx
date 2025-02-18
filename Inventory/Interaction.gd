extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

signal nearPlayer
signal notNearPlayer

func _on_body_entered(body):
	if body.name.match("Player"):
		print("lets go")



func _on_body_exited(body):
	if body.name.match("Player"):
		print("you left")
