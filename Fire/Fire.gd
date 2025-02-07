#extends RigidBoy3D
#
#var colliding_bodies = []
#
#func _ready():
	#body_entered.connect(_on_body_entered)
	#body_exited.connect(_on_body_exited)
#
#func _on_body_entered(body):
	#colliding_bodies.append(body)
	#
#
#func _on_body_exited(body):
	#colliding_bodies.erase(body)
#
#func _process(delta):
	#for body in colliding_bodies:
		#if overlaps_body(body):
			#if body.has_method("take_damage"):  # Check if the object has a damage method
				#body.take_damage(10)
extends RigidBody3D

@export var base_duplicate_chance_per_sec: float = 0.1  # 10% chance/sec to duplicate
@export var base_despawn_chance_per_sec: float = 0.05  # 5% chance/sec to despawn
@export var base_spawn_radius: float = 2.0  # Radius for new fires

# Material multipliers (adjust these in the Inspector)
@export var material_multipliers: Dictionary = {
	"wood": {"duplicate": 6.0, "despawn": 0.4, "radius": 1.2},  # Flammable!
	"grass": {"duplicate": 6.0, "despawn": 0.3, "radius": 1.5},
	"stone": {"duplicate": 0.00000001, "despawn": 0.1, "radius": 0.125}  # Fire hates stone
}
var _current_material: String = "stone"
@export var damage_per_second: int = 30  # Damage as an integer per second
var overlapping_bodies: Array = []
var damage_accumulator: float = 0.0  # Track fractional damage

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D):
	if body.has_method("take_damage"):
		overlapping_bodies.append(body)

func _on_body_exited(body: Node3D):
	if body in overlapping_bodies:
		overlapping_bodies.erase(body)
	if body.has_method("get_material"):
		_current_material = body.get_material()

func _process(delta: float):
	# Accumulate fractional damage
	damage_accumulator += damage_per_second * delta

	# Apply whole-number damage once accumulated
	if damage_accumulator >= 1.0:
		for body in overlapping_bodies:
			if body.has_method("take_damage"):
				body.take_damage(damage_accumulator)
		damage_accumulator = 0.0  # Reset accumulator
	var duplicate_chance = base_duplicate_chance_per_sec * delta
	var despawn_chance = base_despawn_chance_per_sec * delta
	var multipliers = material_multipliers.get(_current_material, {})
	duplicate_chance *= multipliers.get("duplicate", 1.0)
	despawn_chance *= multipliers.get("despawn", 1.0)
	var spawn_radius = base_spawn_radius * multipliers.get("radius", 1.0)

	# Exponential growth: Increase duplication chance over time
	duplicate_chance *= 1.0 + (0.1 * get_process_delta_time())

	# Roll for despawn
	if randf() < despawn_chance:
		queue_free()
		return

	# Roll for duplication
	if randf() < duplicate_chance:
		_spawn_fire_in_radius(spawn_radius)

func _spawn_fire_in_radius(radius: float):
	# Random direction within the radius
	var random_dir = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	var spawn_pos = global_position + random_dir * radius
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(spawn_pos, spawn_pos + Vector3(0, 0.1, 0))
	var result = space_state.intersect_ray(query)

	# Spawn only if the spot is empty
	if result.is_empty():
		var new_fire = load("res://Fire/Fire.tscn").instantiate()
		new_fire.global_position = spawn_pos
		get_parent().add_child(new_fire)
	
