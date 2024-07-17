extends Node3D

@export var MALE: Array[PackedScene]
@export var VELKE: Array[PackedScene]

const HRANICE_POLE := Vector3i(2,2,-5)
var obsazene_pole: Array


func _ready() -> void:
	for poradi in range(25):
		_pridat_asteroid()
	_umistit_mlhu()


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
	var x_nahodne := randi_range(-HRANICE_POLE.x, HRANICE_POLE.x)
	var y_nahodne := randi_range(-HRANICE_POLE.y, HRANICE_POLE.y)
	var z_nahodne := randi_range(HRANICE_POLE.z, 0)
	var vybrane_souradnice := Vector3i(x_nahodne, y_nahodne, z_nahodne) *10
	if vybrane_souradnice not in obsazene_pole:
		obsazene_pole.append(vybrane_souradnice)
		return vybrane_souradnice
	else:
		return _vybrat_souranice()


func _umistit_mlhu() -> void:
	$Mlha.position = Vector3(0,0,(HRANICE_POLE.z/2) *10)
	var okraj = Vector3(50,50,50)
	$Mlha.size = Vector3(
		HRANICE_POLE.x *2, HRANICE_POLE.y *2, abs(HRANICE_POLE.z)
		) *10 + okraj
	printt($Mlha.position, $Mlha.size)
