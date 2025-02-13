extends Area3D
class_name Hittable

@export var combat_controller : Node

func hit(_originator:Node,_damage:int = 0):
	combat_controller.take_damage(_originator,_damage)
