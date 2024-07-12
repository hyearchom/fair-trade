extends CharacterBody3D

const MAX_VYKON = 0.2

var cil: Vector3

func _ready():
	add_to_group('souperi')

func _physics_process(_delta):
	cil = _najit_hrace()
	var smer = (cil -global_position).normalized()
	
	var srazka = move_and_collide(smer *MAX_VYKON)
	look_at(cil)

	if srazka:
		queue_free()
		if srazka.get_collider().is_in_group('hrac'):
			print('Zničen!')

func _najit_hrace() -> Vector3:
	var hrac = get_tree().get_first_node_in_group('hrac')
	return hrac.global_position
