extends Area3D
class_name Hittable

@export var combat_controller : Node3D

func hit(_value = 0):
	combat_controller.take_damage(_value)
