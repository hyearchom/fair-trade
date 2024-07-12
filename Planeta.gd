extends MeshInstance3D


func _physics_process(delta):
	get_active_material(0).get('shader_parameter/tex_frg_5').noise.offset.x += 0.01
	get_active_material(0).get('shader_parameter/tex_frg_5').noise.frequency += 0.000_000_1
