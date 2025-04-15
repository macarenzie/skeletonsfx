extends Node3D

@onready var MainMenu = $CanvasLayer/ControlesRect
@onready var title = $"CanvasLayer/Title Rect"
@onready var controleMenu = $CanvasLayer/Menu

# Called when the node enters the scene tree for the first time.
func _ready():
	MainMenu.visible = true
	print("wocky slush")
	title.visible = true
	controleMenu.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_controles_pressed():
	MainMenu.visible = false
	title.visible = false
	controleMenu.visible = true


func _on_back_pressed():
	MainMenu.visible = true
	title.visible = true
	controleMenu.visible = false


func _on_start_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	get_tree().change_scene_to_file("res://Scenes/cutscene.tscn")


func _on_dev_room_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_quit_pressed():
	get_tree().quit()
