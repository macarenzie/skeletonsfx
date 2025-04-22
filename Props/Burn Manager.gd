extends Node3D

signal Burnt

@export var mesh: MeshInstance3D

var burn := 0.0
var target := 0.0
var isBurning := false
var mat:ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	mat = mesh.get_active_material(0).next_pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isBurning:
		if burn == target:
			isBurning = false
		else:
			burn += 0.1
	
	mat.set_shader_parameter("BurnTransition", burn)
	
	if burn == 2.0:
		Burnt.emit()

func burn_in():
	target = 1.0
	isBurning = true

func burn_out():
	target = 2.0
	isBurning = true
