extends Node3D
# this script and the node/scene it's attached to only exists for development and debug purposes
@onready var model = $Body

@export_category("Dummy Attack")
@export var attack_delay:float = 2.0
@export var attack_damage:float = 10.0
@export var attack_distance:float = 1.0
@onready var attack_ray : RayCast3D = %RayCast3D

func _ready():
	#print("target dummy ready called")
	#attack()
	pass
	
func take_damage(originator:Node,value:int):
	model.mesh.material.set_albedo(Color("red"))
	#print("I "+name+" was hit for "+str(value)+" damage")
	attack()
	Scheduler.schedule(reset_color,0.5)
	
func reset_color():
	model.mesh.material.set_albedo(Color("cyan"))

func attack():
	attack_raycast()
	model.mesh.material.set_albedo(Color("gold"))
	Scheduler.schedule(reset_color,0.5)
	Scheduler.schedule(attack,attack_delay)

func attack_raycast():
	attack_ray.target_position = Vector3(0,0,-attack_distance)
	attack_ray.force_raycast_update()
	if !attack_ray.is_colliding(): #if it's not colliding with anything don't continue
		return
	if !attack_ray.get_collider() is Hittable: #if it's not hittable don't continue
		return
	var object_hit : Hittable = attack_ray.get_collider()
	#print("I hit "+object_hit.to_string())
	object_hit.hit(self,attack_damage)
