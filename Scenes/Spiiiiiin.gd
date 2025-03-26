extends MeshInstance3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(Vector3.UP, 0.1);
