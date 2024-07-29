extends Node3D

const SCENY := {
	'strela': preload("res://sceny/strela.tscn"),
	'hlidka': preload("res://sceny/hlidka.tscn")
}

func _ready() -> void:
	Signaly.vyslani_strely.connect(_nasadit_scenu.bind(SCENY.strela))


func _nasadit_scenu(pozice:Vector3, scena:PackedScene) -> void:
	var objekt: Node3D = scena.instantiate()
	objekt.position = pozice
	add_child(objekt)
