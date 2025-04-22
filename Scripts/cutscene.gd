extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Start_1")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_Q):
		$AnimationPlayer.stop()
		$AnimationPlayer.play("Start_3")
	pass


func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().change_scene_to_file("res://Scenes/level_1_NEW.tscn")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "camera_animation":
		get_tree().change_scene_to_file("res://Scenes/level_1_NEW.tscn")
	if anim_name == "Start_1":
		$AnimationPlayer.play("Start_2")
	if anim_name == "Start_3":
		$AnimationPlayer.play("camera_animation")
