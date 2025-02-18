#Currently just used for inventory open/close/pause

extends Node

@onready var inventory = $Player/Inventory
@onready var playerUI = $Player/PlayerUI
@onready var pauseMenu = $Menu

var menuOpen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#close Inventory
	inventory.close()
	

func _input(event):
	#Helps togle the inventory.
	if event.is_action_pressed("toggle_inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()
	if event.is_action_pressed("Interact"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.loot.call_deferred(1,3)
		
	if event.is_action_pressed("quit"):
		if inventory.isOpen:
			inventory.close()
		else:
			openMenu()
			#get_tree().quit()

func openMenu():
	if menuOpen:
		menuOpen = false
		pauseMenu.visible = false
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	else:
		pauseMenu.visible = true
		menuOpen = true
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 


#unpauses the game and sets mouse back to normal
func _on_inventory_closed():
	playerUI.visible = true
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 

#Pauses the game and sets mouse back to visable and stuck in window
func _on_inventory_opened():
	playerUI.visible = false
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED 



func _on_resume_pressed():
	openMenu()


func _on_quit_pressed():
	get_tree().quit()
