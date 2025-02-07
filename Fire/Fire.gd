#extends Area3D
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
extends Area3D

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

func _process(delta: float):
    # Accumulate fractional damage
    damage_accumulator += damage_per_second * delta

    # Apply whole-number damage once accumulated
    if damage_accumulator >= 1.0:
        for body in overlapping_bodies:
            if body.has_method("take_damage"):
                body.take_damage(damage_accumulator)
        damage_accumulator = 0.0  # Reset accumulator
