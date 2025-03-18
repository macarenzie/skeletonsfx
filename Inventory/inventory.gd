extends Control

@onready var slot_scene = preload("res://Inventory/slot.tscn")
@onready var item_scene = preload("res://Inventory/item.tscn")

@onready var grid_container = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var scroll_container = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer

@onready var enemy_grid_container = $EnemyGrid/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var enemy_scroll_container = $EnemyGrid/MarginContainer/VBoxContainer/ScrollContainer

@onready var other_Button = $EnemyGrid/MarginContainer/VBoxContainer/Header/Button_Spawn

@onready var col_count = grid_container.columns

@onready var player_rect = $ColorRect
@onready var enemy_rect = $EnemyGrid
@onready var equipment_rect = $"equipment Slots"

signal opened
signal closed
signal placed_enemy

var player_grid_array := []
var enemy_grid_array := []
var grid_array := []
var item_held = null
var current_slot = null
var can_place := false
var icon_anchor : Vector2
var isOpen: bool = false
var perferd_grid = null

#controll looting
var in_range = false
#var 
var number_of_slots = 100
var enemy_item_data := {}
var loaded_enemy_item_data := {}
var is_Loaded = false

#Slot Data
@onready var item_slot_1 = $"equipment Slots/MarginContainer/VBoxContainer/ScrollContainer/GridContainer/Item_Slot"
var slot_1 = []

@onready var item_slot_2 = $"equipment Slots/MarginContainer/VBoxContainer/ScrollContainer/GridContainer/Item_Slot2"
var slot_2 = []

@onready var item_slot_3 = $"equipment Slots/MarginContainer/VBoxContainer/ScrollContainer/GridContainer/Item_Slot3"
var slot_3 = []


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(number_of_slots):
		create_slot(grid_container)
	for i in range(number_of_slots):
		create_slot(enemy_grid_container)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if item_held:
		#right click 
		if Input.is_action_just_pressed("block"):
			rotate_item()
		#left click
		if Input.is_action_just_pressed("attack"):
			if scroll_container.get_global_rect().has_point(get_global_mouse_position()):
				place_item(0.15)
			elif enemy_scroll_container.get_global_rect().has_point(get_global_mouse_position()):
				place_item(0.15)
			else:
				check_slots()
			
	else:
		#left click
		if Input.is_action_just_pressed("attack"):
			if scroll_container.get_global_rect().has_point(get_global_mouse_position()):
				pick_item()
			if enemy_scroll_container.get_global_rect().has_point(get_global_mouse_position()):
				pick_item()
	#print(get_global_mouse_position())

#Handels creating the instances of the slots. 
func create_slot(grid_base):
	var new_slot = slot_scene.instantiate()
	if grid_base == grid_container:
		new_slot.slot_ID = player_grid_array.size()
		player_grid_array.push_back(new_slot)
	if grid_base == enemy_grid_container:
		new_slot.slot_ID = enemy_grid_array.size()
		enemy_grid_array.push_back(new_slot)
	grid_base.add_child(new_slot)
	new_slot.slot_entered.connect(_on_slot_mouse_entered)
	new_slot.slot_exited.connect(_on_slot_mouse_exited)


#handels when mouse is over the slot
func _on_slot_mouse_entered(a_Slot):
	icon_anchor = Vector2(10000,10000)
	current_slot = a_Slot
	if item_held:
		check_slot_avaliblity(current_slot)
		set_grids.call_deferred(current_slot)

#handels when mouse exits the slot
func _on_slot_mouse_exited(a_Slot):
	clear_grid()

#handles button press to spawn Item
func _on_button_spawn_pressed():
	spawn_item(randi_range(1,2),3,0)




#---------------------Item Controle--------------

func spawn_item(item:int, slot:int, itemRotate:int):
	#Set required varbles up
	var new_item = item_scene.instantiate()
	add_child(new_item)
	new_item.load_item(item)
	new_item.selected = true
	item_held = new_item
	if itemRotate == 90:
		item_held.rotate_item()
		clear_grid()
	if itemRotate == 180:
		item_held.rotate_item()
		clear_grid()
		item_held.rotate_item()
		clear_grid()
	if itemRotate == 270:
		item_held.rotate_item()
		clear_grid()
		item_held.rotate_item()
		clear_grid()
		item_held.rotate_item()
		clear_grid()
	
	if slot > -1:
		set_desired_slot(slot)

#Used to place the item
func place_item(speed):
	if not can_place or not current_slot:
		return
	update_array_grid_to_check()
	
	var calculated_grid_id = current_slot.slot_ID + icon_anchor.x * col_count + icon_anchor.y
	item_held._snap_to(grid_array[calculated_grid_id].global_position,speed)

	item_held.get_parent().remove_child(item_held)
	
	if perferd_grid == null:
		if player_rect.get_global_rect().has_point(get_global_mouse_position()):
			grid_container.add_child(item_held)
		if enemy_rect.get_global_rect().has_point(get_global_mouse_position()):
			enemy_grid_container.add_child(item_held)
	if perferd_grid == enemy_grid_array:
		enemy_grid_container.add_child(item_held)
	if perferd_grid == player_grid_array:
		grid_container.add_child(item_held)
		
	item_held.global_position = get_global_mouse_position()
	item_held.grid_anchor = current_slot
	for grid in item_held.item_grids:
		var grid_to_check = current_slot.slot_ID + grid[0] + grid[1] * col_count
		grid_array[grid_to_check].state = grid_array[grid_to_check].Status.TAKEN
		grid_array[grid_to_check].item_stored = item_held
	
	item_held = null
	perferd_grid = null
	clear_grid()
	placed_enemy.emit()

#Used to pickup placed items
func pick_item():
	if not current_slot or not current_slot.item_stored:
		return
	item_held = current_slot.item_stored
	item_held.selected = true
	
	item_held.get_parent().remove_child(item_held)
	add_child(item_held)
	item_held.global_position = get_global_mouse_position()
	
	update_array_grid_to_check()
	
	for grid in item_held.item_grids:
		var grid_to_check = item_held.grid_anchor.slot_ID + grid[0] + grid[1] * col_count
		grid_array[grid_to_check].state = grid_array[grid_to_check].Status.FREE
		grid_array[grid_to_check].item_stored = null
		
	check_slot_avaliblity(current_slot)
	set_grids.call_deferred(current_slot)

#Used to rotate the held item
func rotate_item():
	item_held.rotate_item()
	clear_grid()
	if current_slot:
		_on_slot_mouse_entered(current_slot)


func set_desired_slot(slot_number):
	if perferd_grid == enemy_grid_array:
		current_slot = enemy_grid_container.get_child(slot_number)
		icon_anchor = Vector2(10000,10000)
		current_slot = enemy_grid_container.get_child(slot_number)
	else:
		current_slot = grid_container.get_child(slot_number)
		icon_anchor = Vector2(10000,10000)
		current_slot = grid_container.get_child(slot_number)
	
	if item_held:
		check_slot_avaliblity(current_slot)
		set_grids.call_deferred(current_slot)
		place_item.call_deferred(0.01)


#runs checks to see if the item can be placed in the grid.
func check_slot_avaliblity(a_slot):
	for grid in item_held.item_grids:
		#grid Test
		update_array_grid_to_check()
		var grid_to_check = a_slot.slot_ID + grid[0] + grid[1] * col_count
		var line_switch_check = a_slot.slot_ID % col_count + grid[0]
		if line_switch_check < 0 or line_switch_check >= col_count:
			can_place = false
			perferd_grid = null
			return
		if grid_to_check < 0 or grid_to_check >= grid_array.size():
			can_place = false
			perferd_grid = null
			return 
		if grid_array[grid_to_check].state == grid_array[grid_to_check].Status.TAKEN:
			can_place = false
			perferd_grid = null
			return
	can_place = true

#sets up the grid to color the squares
func set_grids(a_slot):
	for grid in item_held.item_grids:
		update_array_grid_to_check()
		
		var grid_to_check = a_slot.slot_ID + grid[0] + grid[1] * col_count
		var line_switch_check = a_slot.slot_ID % col_count + grid[0]
		if grid_to_check < 0 or grid_to_check >= grid_array.size():
			continue
		if line_switch_check < 0 or line_switch_check >= col_count:
			continue
		
		if can_place:
			grid_array[grid_to_check].set_color(grid_array[grid_to_check].Status.FREE)
			
			if grid[1] < icon_anchor.x: icon_anchor.x = grid[1]
			if grid[0] < icon_anchor.y: icon_anchor.y = grid[0]
		else:
			grid_array[grid_to_check].set_color(grid_array[grid_to_check].Status.TAKEN)



#-----------------Maintence----------------

#kills anything more than the grids when inventory is closed.
#if more is added or changed to the inventory UI change the number appropriately. 
func kill_out_of_place_items():
	var children = get_children()  
	for child in children:
		if child.get_index() > 2:
			child.queue_free()
			item_held = null


func update_array_grid_to_check():
	if perferd_grid == null:
		if player_rect.get_global_rect().has_point(get_global_mouse_position()):
			grid_array = player_grid_array
		if enemy_rect.get_global_rect().has_point(get_global_mouse_position()):
			grid_array = enemy_grid_array
	else:
		grid_array = perferd_grid

#resets the grid square color
func clear_grid():
	for grid in player_grid_array:
		grid.set_color(grid.Status.DEAFAULT)
		
	for grid in enemy_grid_array:
		grid.set_color(grid.Status.DEAFAULT)




#------------Interface Controles-----------

#used for openong/closing inventory
func open():
	enemy_item_data = {}
	visible = true
	isOpen = true
	opened.emit()

func close():
	kill_out_of_place_items()
	visible = false
	isOpen = false
	enemy_rect.visible = false
	closed.emit()

func loot(item:int, slot:int):
	if in_range:
		enemy_item_data = {}
		visible = true
		enemy_rect.visible = true
		isOpen = true
		perferd_grid = enemy_grid_array
		#other_Button.emit_signal("pressed")
		opened.emit()
		#spawn_item.call_deferred(item,slot,0)
		for items in loaded_enemy_item_data:
			perferd_grid = enemy_grid_array
			spawn_item.call_deferred(loaded_enemy_item_data[items][0],loaded_enemy_item_data[items][1],loaded_enemy_item_data[items][2])
			await placed_enemy
		loaded_enemy_item_data = {}
	else:
		pass





#--------------------Enemy Storage Information-------

#gets the data of all obkects in the enemy grid.
func pull_enemy_grid():
	enemy_item_data = {}
	var children = enemy_grid_container.get_children()
	for child in children:
		if child.get_index() >= number_of_slots:
			#print("I got Slots")
			var temp_grid_array := []
			temp_grid_array.push_back(child.item_ID)
			temp_grid_array.push_back(child.grid_anchor.slot_ID)
			temp_grid_array.push_back(child.rotation_degrees)
			enemy_item_data[child.get_index() - number_of_slots] = temp_grid_array

#used to kill all objects in the enemy grid after leaving a pickup location
func clear_enemy_grid():
	var children = enemy_grid_container.get_children()
	for child in children:
		child.queue_free()
	
	enemy_grid_array = []
	for i in range(number_of_slots):
		create_slot(enemy_grid_container)


#Used to get the storage from pickup objects
func load_enemy_grid(storage):
	is_Loaded = true
	loaded_enemy_item_data = storage

#Used to send the storage data to pickup objects after leaving the objects area
func left_looting_area():
	pull_enemy_grid()
	is_Loaded = false
	clear_enemy_grid()
	return enemy_item_data



#----------------------Equipment Slots-------------
func check_slots():
	if item_slot_1.get_global_rect().has_point(get_global_mouse_position()):
		_on_item_slot_pressed()
	if item_slot_2.get_global_rect().has_point(get_global_mouse_position()):
		_on_item_slot_2_pressed()
	if item_slot_3.get_global_rect().has_point(get_global_mouse_position()):
		_on_item_slot_3_pressed()

func _on_item_slot_pressed():
	if slot_1 != []:
		if item_held == null:
			spawn_item(slot_1[0],0,0)
			item_slot_1.icon = load("res://Assets/UI Assets/equipment_texture_main.png")
			slot_1.clear()
		else:
			if item_held.slot_type == "mainhand":
				var temp_list = []
				temp_list.push_back(slot_1[0])
				slot_1.clear()
				slot_1.push_back(item_held.item_ID)
				item_slot_1.icon = item_held.IconRect_path.texture
				
				kill_out_of_place_items()
				spawn_item(temp_list[0],0,0)
	else:
		if item_held != null and item_held.slot_type == "mainhand":
			slot_1.push_back(item_held.item_ID)
			item_slot_1.icon = item_held.IconRect_path.texture
			kill_out_of_place_items()
	#print(slot_1)


func _on_item_slot_2_pressed():
	if slot_2 != []:
		if item_held == null:
			spawn_item(slot_2[0],0,0)
			item_slot_2.icon = load("res://Assets/UI Assets/equipment_texture_off.png")
			slot_2.clear()
		else:
			if item_held.slot_type == "offhand":
				var temp_list = []
				temp_list.push_back(slot_2[0])
				
				slot_2.clear()
				slot_2.push_back(item_held.item_ID)
				item_slot_2.icon = item_held.IconRect_path.texture
				
				kill_out_of_place_items()
				spawn_item(temp_list[0],0,0)
	else:
		if item_held != null and item_held.slot_type == "offhand":
			slot_2.push_back(item_held.item_ID)
			
			item_slot_2.icon = item_held.IconRect_path.texture
			kill_out_of_place_items()
	#print(slot_2)


func _on_item_slot_3_pressed():
	if slot_3 != []:
		if item_held == null:
			spawn_item(slot_3[0],0,0)
			item_slot_3.icon = load("res://Assets/UI Assets/inventory_texture.png")
			slot_3.clear()
		else:
			var temp_list = []
			temp_list.push_back(slot_3[0])
			
			slot_3.clear()
			slot_3.push_back(item_held.item_ID)
			item_slot_3.icon = item_held.IconRect_path.texture
				
			kill_out_of_place_items()
			spawn_item(temp_list[0],-1,0)
	else:
		if item_held != null:
			slot_3.push_back(item_held.item_ID)
			item_slot_3.icon = item_held.IconRect_path.texture
			kill_out_of_place_items()
	#print(slot_3)
