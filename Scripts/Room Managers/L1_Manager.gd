extends Node3D

@onready var Player = %Player

@onready var Gate_A = %"Gate A"
@onready var Gate_B1 = %"Gate B1"
@onready var Gate_B2 = %"Gate B2"
@onready var Gate_C1 = %"Gate C1"
@onready var Gate_C2 = %"Gate C2"

@onready var Chest = %Chest

var EncA_Flag = false
var EncB_Count = 0

func _on_weapon_tree_exited():
	Gate_A.open()

func _on_encounter_a_body_entered(body):
	if not EncA_Flag and body == Player:
		Gate_B1.close()
		Gate_B2.close()
		EncA_Flag = true

func _on_enemy_a_tree_exited():
	Gate_B2.open()

func _on_encounter_b_body_entered(body):
	if body == Player:
		Gate_C1.close()

func _on_enemy_b_1_tree_exited():
	EncB_Count += 1
	if EncB_Count >= 2:
		Gate_C2.open()
		Chest.visible = true

func _on_enemy_b_2_tree_exited():
	EncB_Count += 1
	if EncB_Count >= 2:
		Gate_C2.open()
		Chest.visible = true
