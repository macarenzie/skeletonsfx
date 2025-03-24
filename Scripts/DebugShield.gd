extends MeshInstance3D

@onready var anim_player = %AnimationPlayer

func _process(delta):
	if anim_player.current_animation == "block_start":
		mesh.material.set_albedo(Color("white"))
		#mesh.material.set_albedo(Color("green"))
	elif anim_player.current_animation == "block_active":
		mesh.material.set_albedo(Color("white"))
		#mesh.material.set_albedo(Color("red"))
	elif anim_player.current_animation == "block_end":
		mesh.material.set_albedo(Color("white"))
		#mesh.material.set_albedo(Color("blue"))
	else:
		mesh.material.set_albedo(Color("white"))
