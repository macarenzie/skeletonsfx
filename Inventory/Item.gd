extends Node2D

@onready var IconRect_path = $Icon

var item_ID : int
var item_grids := []
var selected = false
var grid_anchor = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)


#Loads an item from the assets folder using the name in the item_data sheet
func load_item(a_ItemID : int):
	var Icon_path = "res://Assets/UI Assets/" + DataHandler.item_data[str(a_ItemID)]["Name"] + ".png"
	IconRect_path.texture = load(Icon_path)
	for grid in DataHandler.item_grid_data[str(a_ItemID)]:
		var converter_array := []
		for i in grid:
			converter_array.push_back(int(i))
		item_grids.push_back(converter_array)


#Math to rotate held item.
func rotate_item():
	for grid in item_grids:
		var temp_y = grid[0]
		grid[0] = -grid[1]
		grid[1] = temp_y
	rotation_degrees += 90
	if rotation_degrees >= 360:
		rotation_degrees = 0

#Moves the item to the position of the grid squares
func _snap_to(destination:Vector2,speed:float):
	var tween = get_tree().create_tween()
	if int(rotation_degrees) % 180 == 0:
		destination += IconRect_path.size/2
		
	else:
		var temp_xy_switch = Vector2(IconRect_path.size.y, IconRect_path.size.x)
		destination += temp_xy_switch/2
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	tween.tween_property(self, "global_position", destination, speed).set_trans(Tween.TRANS_SINE)
	selected = false





