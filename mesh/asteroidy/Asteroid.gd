extends MeshInstance3D

var osa := _nahodny_vektor()
var rychlost_otaceni := randf_range(0, 0.005)


func _physics_process(_delta: float) -> void:
	rotate_object_local(osa, rychlost_otaceni)


func _nahodny_vektor() -> Vector3:
	var vektor := Vector3(
		randf_range(-1,1),
		randf_range(-1,1),
		randf_range(-1,1),
	)
	vektor = vektor.normalized()
	return vektor
