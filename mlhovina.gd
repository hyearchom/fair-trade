extends Node3D

@export var HRANICE_POLE: Vector3i
@export_range(0,0.1,0.01) var HUSTOTA_MLHY: float

@export var MALE: Array[PackedScene]
@export var VELKE: Array[PackedScene]

var obsazene_pole: Array


func _ready() -> void:
	for poradi in range(25):
		_pridat_asteroid()
	_podoba_mlhy()
	if HUSTOTA_MLHY:
		_podoba_mlhy()
		#_umistit_mlhu(HUSTOTA_MLHY)
	_nastavit_dohled_asteroidu()

func _pridat_asteroid() -> void:
	var scena_asteroidu: PackedScene
	var rozptyl := randi_range(0,19)
	match rozptyl:
		var cislo when cislo <= 18:
			scena_asteroidu = MALE.pick_random()
			#scena_asteroidu = load("res://mesh/asteroidy/maly_odstipnuty.tscn")
		_:
			scena_asteroidu = VELKE.pick_random()
	var asteroid := scena_asteroidu.instantiate()
	var asymetrie := Vector3i(
		randi_range(-1,1), randi_range(-1,1), randi_range(-1,1)
		)
	asteroid.position = _vybrat_souranice() + asymetrie
	add_child(asteroid)


func _vybrat_souranice() -> Vector3i:
	var vybrane_souradnice := Vector3i(
		randi_range(-HRANICE_POLE.x, HRANICE_POLE.x),
		randi_range(-HRANICE_POLE.y, HRANICE_POLE.y),
		randi_range(-HRANICE_POLE.z, HRANICE_POLE.z)
	) *10
	
	if vybrane_souradnice not in obsazene_pole:
		obsazene_pole.append(vybrane_souradnice)
		#print(vybrane_souradnice)
		return vybrane_souradnice
	else:
		return _vybrat_souranice()

func _podoba_mlhy() -> void:
	$Oblast.scale = HRANICE_POLE *10
	$Oblast.show()

#func _umistit_mlhu(hustota) -> void:
	#var mlha := $Oblak
	#var okraj := Vector3i.ONE *50
	#mlha.scale = HRANICE_POLE *20 + okraj
	#mlha.material.density = hustota
	#mlha.show()
	#printt(mlha.size, mlha.position)


func _nastavit_dohled_asteroidu() -> void:
	for asteroid in get_children():
		if asteroid is MeshInstance3D:
			asteroid.visibility_range_end = 20
			asteroid.visibility_range_end_margin = 20
			asteroid.visibility_range_fade_mode = \
					GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF




func _prekroceni(body: Node3D, vstup: bool) -> void:
	if body.is_in_group('hrac'):
		match vstup:
			true:
				Signaly.zmenit_mlhu.emit(HUSTOTA_MLHY)
			false:
				Signaly.zmenit_mlhu.emit(0)
