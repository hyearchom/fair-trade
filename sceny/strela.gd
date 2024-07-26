extends CharacterBody3D

const MAX_VYKON = 0.2

func _ready() -> void:
	add_to_group('souperi')
	$Rozlet.start()


func _physics_process(_delta: float) -> void:
	var smer = Vector3.BACK
	
	if $Rozlet.is_stopped():
		var cil = _najit_hrace()
		smer = _navadeni_za_hracem(cil)
		look_at(cil)
	
	var srazka = move_and_collide(smer *MAX_VYKON)

	if srazka:
		#queue_free()
		if srazka.get_collider().is_in_group('hrac'):
			print('Zničen!')


func _najit_hrace() -> Vector3:
	var hrac := get_tree().get_first_node_in_group('hrac')
	return hrac.global_position


func _navadeni_za_hracem(cil: Vector3) -> Vector3:
	var smer = (cil -global_position).normalized()
	return smer
