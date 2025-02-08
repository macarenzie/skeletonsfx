extends Node3D
# this script and the node/scene it's attached to only exists for development and debug purposes
@onready var model = $Body

func take_damage(_value):
	model.mesh.material.set_albedo(Color("red"))
	print("I "+name+" was hit")
	Scheduler.schedule(reset_color,0.5)
	

func reset_color():
	model.mesh.material.set_albedo(Color("cyan"))
