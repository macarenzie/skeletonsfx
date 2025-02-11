extends MeshInstance3D

func _on_animation_player_animation_changed(old_name, new_name):
	if new_name == "block_start":
		mesh.material.set_albedo(Color("green"))
	elif new_name == "block_active":
		mesh.material.set_albedo(Color("red"))
	elif new_name == "block_end":
		mesh.material.set_albedo(Color("blue"))
	else:
		mesh.material.set_albedo(Color("white"))
