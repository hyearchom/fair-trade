extends Node3D

const SCENY := {
	'strela': preload("res://sceny/strela.tscn")
}

func _ready() -> void:
	Signaly.vyslani_strely.connect(_nasadit_strelu)


func _nasadit_strelu(souradnice:Vector3, orientace:Vector3) -> void:
	_nasadit_scenu(self, SCENY.strela, souradnice, orientace)


func _nasadit_scenu(rodic:Node3D, scena:PackedScene, souradnice:Vector3,
			orientace: Vector3) -> void:
	var objekt: Node3D = scena.instantiate()
	objekt.position = souradnice
	objekt.rotation = orientace
	rodic.add_child(objekt)
