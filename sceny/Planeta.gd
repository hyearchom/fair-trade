extends MeshInstance3D

func _physics_process(delta: float) -> void:
	_otoceni_planety(0.007 *delta)
	_otacet_mracny(0.2 *delta)


func _otacet_mracny(rychlost:=float(1)) -> void:
	get_active_material(0).get(
	  'shader_parameter/tex_frg_5').noise.offset.x += rychlost
	get_active_material(0).get(
	  'shader_parameter/tex_frg_5').noise.frequency += rychlost *0.000_1


func _otoceni_planety(rychlost:=float(1)) -> void:
	rotate_object_local(Vector3.UP, rychlost)
