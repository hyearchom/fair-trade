extends MeshInstance3D

var osa := _nahodny_vektor()
var rychlost_otaceni := randf_range(0, 0.005)


func _ready() -> void:
	_nastavit_zmizeni_asteroidu()


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


func _nastavit_zmizeni_asteroidu() -> void:
	visibility_range_end = 20
	visibility_range_end_margin = 20
	visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
