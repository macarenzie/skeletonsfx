extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("camera_animation")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().change_scene_to_file("res://Scenes/level_1_NEW.tscn")


func _on_animation_player_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scenes/level_1_NEW.tscn")
