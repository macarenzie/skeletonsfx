#Currently just used for inventory open/close/pause

extends Node

@onready var inventory = $Inventory
@onready var playerUI = $PlayerUI
@onready var playerUIPage1 = $Menu/ColorRect/MarginContainer
@onready var playerUIPage2 = $Menu/ColorRect/MarginContainer2
@onready var playerUIGameOver = $"Menu/ColorRect/Game Over"
@onready var playerCrosshair = $Crosshair
@onready var pauseMenu = $Menu

var menuOpen = false
var playerDead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#close Inventory
	inventory.close()
	Globals.player_dies.connect(kill_player)
	

func _input(event):
	#Helps togle the inventory.
	if event.is_action_pressed("toggle_inventory"):
		if inventory.isOpen:
			inventory.close()
		elif menuOpen:
			pass
		else:
			inventory.open()
	if event.is_action_pressed("Interact"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.loot.call_deferred(1,3)
		
	if event.is_action_pressed("quit"):
		if playerDead:
			pass
		if inventory.isOpen:
			inventory.close()
		else:
			openMenu()
			#get_tree().quit()

func openMenu():
	if menuOpen:
		menuOpen = false
		pauseMenu.visible = false
		playerUI.visible = true
		playerCrosshair.visible = true
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	else:
		menuOpen = true
		pauseMenu.visible = true
		playerUIPage1.visible = true
		playerUIPage2.visible = false
		playerUI.visible = false
		playerCrosshair.visible = false
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 


#unpauses the game and sets mouse back to normal
func _on_inventory_closed():
	playerUI.visible = true
	playerCrosshair.visible = true
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 

#Pauses the game and sets mouse back to visable and stuck in window
func _on_inventory_opened():
	playerUI.visible = false
	playerCrosshair.visible = false
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED 



func _on_resume_pressed():
	openMenu()


func _on_quit_pressed():
	get_tree().quit()


func _on_dev_room_pressed():
	menuOpen = false
	pauseMenu.visible = false
	playerUI.visible = true
	playerCrosshair.visible = true
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	#if get_tree().current_scene.scene_file_path == "res://Scenes/world.tscn":
		#get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
	#else :
		#get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_back_pressed():
	playerUIPage1.visible = true
	playerUIPage2.visible = false


func _on_controls_pressed():
	playerUIPage1.visible = false
	playerUIPage2.visible = true


func kill_player():
	pauseMenu.visible = true
	playerUI.visible = false
	playerUIGameOver.visible = true
	playerCrosshair.visible = false
	playerUIPage1.visible = false
	playerUIPage2.visible = false
	playerDead = true
	get_tree().paused = true
	$"Menu/ColorRect/Game Over/Label".text = "Game Over"
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	

func win_player():
	pauseMenu.visible = true
	playerUI.visible = false
	playerUIGameOver.visible = true
	playerCrosshair.visible = false
	playerUIPage2.visible = false
	playerUIPage1.visible = false
	playerDead = true
	get_tree().paused = true
	$"Menu/ColorRect/Game Over/Label".text = "You have become Bonefire"
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	



func _on_restart_pressed():
	get_tree().reload_current_scene() # you died


func _on_main_menu_pressed():
	menuOpen = false
	pauseMenu.visible = false
	playerUI.visible = true
	playerCrosshair.visible = true
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
