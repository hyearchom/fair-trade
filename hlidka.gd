extends CharacterBody3D

@onready var Radar: ShapeCast3D = $Radar

func _ready() -> void:
	add_to_group('souperi')

func _physics_process(_delta: float) -> void:
	if Radar.is_colliding():
		if not get_tree().get_nodes_in_group('strely'):
			Signaly.vyslani_strely.emit(global_position)
