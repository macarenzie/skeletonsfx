extends StaticBody3D

@export var isOpen:bool = false
var isMoving = false
var rest

# Called when the node enters the scene tree for the first time.
func _ready():
	rest = position.y
	if isOpen:
		position.y -= 5
		visible = false
	else:
		visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isMoving:
		if isOpen:
			if position.y > rest - 5:
				position.y -= 0.1
			else:
				isMoving = false
				visible = false
		else:
			if position.y < rest:
				position.y += 0.1
			else:
				isMoving = false
			

func open():
	if not isOpen:
		isOpen = true
		isMoving = true

func close():
	if isOpen:
		visible = true
		isOpen = false
		isMoving = true
