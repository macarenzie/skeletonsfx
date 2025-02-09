extends Node3D
# this script and the node/scene it's attached to only exists for development and debug purposes
@onready var model = $Body

func take_damage(value:int):
	model.mesh.material.set_albedo(Color("red"))
	print("I "+name+" was hit for "+str(value)+" damage")
	Scheduler.schedule(reset_color,0.5)
	

func reset_color():
	model.mesh.material.set_albedo(Color("cyan"))
