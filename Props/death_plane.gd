extends Node3D

func _on_collision_shape_3d_body_entered(body):
	#print(body.name)
	if body.name == "Player":
		Globals.player_dies.emit()
	elif body is RigidBody3D:
		body.queue_free()
