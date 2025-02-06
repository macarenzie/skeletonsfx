extends Camera3D


func _start():
	# capture and hide mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	pass

func _unhandled_input(event):
	if event == InputEventMouseMotion:
		#grab motion of mouse
		#add 
		clamp(self.rotation.x, PI, -(PI))
