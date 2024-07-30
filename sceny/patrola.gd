extends PathFollow3D

const RYCHLOST := 0.025
var smer := int(1)
var presun := bool(true)

@onready var Radar: ShapeCast3D = $Hlidka/Radar

func _ready() -> void:
	add_to_group('souperi')


func _physics_process(delta: float) -> void:
	if presun:
		_overit_smer(progress_ratio)
		progress_ratio += smer *RYCHLOST *delta

	_detekce_hrace()


func _overit_smer(postup:float) -> void:
	if postup == 0:
		smer = 1
	elif postup == 1:
		smer = -1
		$Hlidka.rotate_object_local(Vector3.LEFT, PI)


func _detekce_hrace() -> void:
	if Radar.is_colliding():
		if not get_tree().get_nodes_in_group('strely'):
			Signaly.vyslani_strely.emit(global_position, global_rotation)
	presun = not Radar.is_colliding()
