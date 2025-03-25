extends Node

@export var material : String = "enemy"

@export var health : int = 500
@export var max_health : int = 0
@onready var health_bar = %ProgressBar

@onready var enemy = $".."

func _ready():
	health_bar.max_value = health
	health_bar.value = health
	max_health = health

func take_damage(originator:Node,damage:int):
	health -= damage
	health_bar.value = health
	if health <= 0:
		enemy.queue_free()

func get_material() -> String:
	return material
