extends TextureRect

signal slot_entered(slot)
signal slot_exited(slot)

@onready var filter = $Status

var slot_ID
var is_hovering := false
enum Status {DEAFAULT, TAKEN, FREE, BARRIER}
var state := Status.DEAFAULT
var item_stored = null

#sets the color to the aproprate state
func set_color(a_state = Status.DEAFAULT):
	match a_state:
		Status.DEAFAULT:
			filter.color = Color(Color.WHITE, 0.0)
		Status.TAKEN:
			filter.color = Color(Color.RED, 0.2)
		Status.FREE:
			filter.color = Color(Color.GREEN, 0.2)
		Status.BARRIER:
			filter.color = Color(Color.BLACK, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Keeps track of current slot the mouse is over
	if get_global_rect().has_point(get_global_mouse_position()):
		if not is_hovering:
			is_hovering = true
			emit_signal("slot_entered",self)
		else:
			if is_hovering:
				is_hovering = false
				emit_signal("slot_exited",self)
