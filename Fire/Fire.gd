extends RigidBody3D

@export var damage_per_second: int = 30
var damage_accumulator: float = 0.0
var overlapping_bodies: Array = []

# Material multipliers for different surface types
@export var material_multipliers: Dictionary = {
	"wood": {"duplicate": 6.0, "despawn": 0.4, "radius": 1.2, "nextFire": 2},  # Flammable!
	"grass": {"duplicate": 6.0, "despawn": 0.3, "radius": 1.5, "nextFire": 3},
	"stone": {"duplicate": 1.0, "despawn": 2.0, "radius": 0.125, "nextFire": 1}  # Fire hates stone
}

# Variables for size interpolation
var spawn_oxygen: float
var max_size: float
var current_time: float = 0.0
var lifetime: float = 4.0  # Increased base lifetime in seconds
var multipliers

func _ready() -> void:
	
	# Connect signals for detecting overlapping bodies
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)
	
	# Get initial oxygen from air node
	var air_node = get_tree().get_first_node_in_group("air")
	if air_node:
		spawn_oxygen = air_node.get_oxygen()
	
	# Check floor material and set max size
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	var shape = SphereShape3D.new()
	shape.radius = 0.1
	query.shape = shape
	query.transform = Transform3D(Basis(), global_position + Vector3(0, -0.1, 0))
	query.collision_mask = 3  # Layer for ground/floor
	
	var result = space_state.intersect_shape(query)
	if result.size() > 0:
		var floor_material = "stone"  # Default to stone
		for hit in result:
			if hit.collider.has_method("get_material"):
				floor_material = hit.collider.get_material()
				break
		
		# Get material multipliers
		multipliers = material_multipliers.get(floor_material, material_multipliers["stone"])
		max_size = multipliers["duplicate"] * spawn_oxygen  # Use duplicate property multiplied by spawn oxygen
		lifetime *= multipliers["despawn"]
	
	# Add to fire group for air system
	add_to_group("fire")
	sleeping = false
	

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		overlapping_bodies.append(body)
	else:
		if body.get_parent().get_parent().name =="Death Plane":
			queue_free()



func _on_body_exited(body: Node3D) -> void:
	if body in overlapping_bodies:
		overlapping_bodies.erase(body)

func _process(delta: float) -> void:
	# Handle damage to destructible props
	damage_accumulator += damage_per_second * delta
	if damage_accumulator >= 1.0:
		for body in overlapping_bodies:
			if body.has_method("take_damage"):
				body.take_damage(damage_accumulator)
		damage_accumulator = 0.0
	
	# Update time and calculate size
	current_time += delta
	
	# Quadratic interpolation for size
	var t = current_time / lifetime
	var size: float
	
	if t < 0.5:
		# Growing phase (0 to 0.5)
		t = t * 2  # Scale to 0-1
		size = lerp(0.05, max_size * 1.5, t * t)  # Start from 0.05 and grow 50% bigger
	else:
		# Shrinking phase (0.5 to 1)
		t = (t - 0.5) * 2  # Scale to 0-1
		size = lerp(max_size * 1.5, 0.0, t * t)  # Quadratic interpolation
	
	$FireSmall.visible = false
	$FireMedium.visible = false
	$FireLarge.visible = false
	
	# Show based on t
	if  overlapping_bodies.size() ==0 && t < 0.25 or t > 0.75:
		$FireSmall.visible = true
	elif overlapping_bodies.size() ==0 && t < 0.5001 or t > 0.5:
		$FireSmall.visible = true
	else:
		$FireSmall.visible = true
	
	# Update collision shape extents
	var shape = $CollisionShape3D.shape
	if shape is BoxShape3D:
		# Create a more natural fire shape that's wider than it is tall
		shape.extents = Vector3(
			size * 0.8,  # Width (X)
			size * 0.5,  # Height (Y)
			size * 0.8   # Depth (Z)
		)
	
	# Update visual mesh scale
	var mesh = $MeshInstance3D
	if mesh:
		mesh.scale = Vector3(
			size * 0.8,  # Width (X)
			size * 0.5,  # Height (Y)
			size * 0.8   # Depth (Z)
		)
		
	
	# Remove fire when size reaches 0
	if size <= 0:
		print(multipliers["nextFire"])
		var new_fire = load("res://Fire/Fire.tscn").instantiate()
		for i in multipliers["nextFire"] + 1:
				#var new_fire = load("res://Fire/Fire.tscn").instantiate()
				#new_fire.global_position = position + Vector3(cos((2*PI/i)) *10 , 0, sin((2*PI/i)) *10)
				#new_fire.sleeping = true
				#get_parent().add_child(new_fire)
				var angle = TAU / float(i)
				var offset = Vector3(cos(angle), 0, sin(angle)) * 5
				new_fire.global_position = global_position + offset
				#new_fire.sleeping = true
				get_parent().add_child(new_fire)
		queue_free()
