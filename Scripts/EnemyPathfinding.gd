extends CharacterBody3D
@onready var enemy_behavior = %EnemyBehavior

@onready var navigation_agent_3d: NavigationAgent3D = %NavigationAgent3D
@export var move_speed := 2.0


func _physics_process(delta):
	if navigation_agent_3d.is_navigation_finished():
		return
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	#var target = basis.looking_at(direction)
	#basis = basis.slerp(target,1)
	velocity = direction * move_speed
	if enemy_behavior.attacking_player:
		return
	look_at(destination)
	move_and_slide()


func _on_head_player_detected(position):
	navigation_agent_3d.set_target_position(Vector3(position.x, 0, position.z))
