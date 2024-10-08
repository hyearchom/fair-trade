extends Node3D

const PATROLA := preload("res://sceny/patrola.tscn")

@export_category('Pole')
var poradi: int
@export var HRANICE_POLE := Vector3i(1,1,5)

@export_category('Mlha')
@export_range(0,0.1,0.01) var HUSTOTA := float(0.01)
@export_range(0,100) var VIDITELNOST := int(20)
@export var BARVA: Color

@export_category('Asteroidy')
@export_range(0,50) var POCET := int(25)
@export_range(0,1,0.1) var POMER := float(0.9)

@export_category('Scény')
@export var MALE: Array[PackedScene]
@export var VELKE: Array[PackedScene]
@export var CILOVY: PackedScene

@export_category('Patroly')
@export_range(0,99,1) var POCET_LODI := int(0) 

var obsazene_pole: Array

func _ready() -> void:
	poradi = get_index()
	add_to_group('mlhoviny')
	_vytvorit_pole()
	if HUSTOTA:
		_podoba_mlhy()
	for _i in POCET_LODI:
		_nasadit_patrolu()

func _vytvorit_pole() -> void:
	$Oblast.scale = HRANICE_POLE *10
	for _i:int in range(POCET):
		_pridat_prazdny_asteroid()
	if CILOVY:
		_pridat_cilovy_asteroid()
	_nastavit_dohled($Asteroidy, VIDITELNOST)

func _pridat_prazdny_asteroid() -> void:
	var scena_asteroidu: PackedScene
	const MAX_ROZPTYL := int(10)
	var rozptyl := randi_range(0, MAX_ROZPTYL)
	
	match rozptyl:
		var cislo when cislo <= POMER *MAX_ROZPTYL:
			scena_asteroidu = MALE.pick_random()
		_:
			scena_asteroidu = VELKE.pick_random()
	
	var asteroid := scena_asteroidu.instantiate()
	var asymetrie := Vector3i(
		randi_range(-1,1), randi_range(-1,1), randi_range(-1,1)
		)
	asteroid.position = _vybrat_souranice() + asymetrie
	$Asteroidy.add_child(asteroid)


func _pridat_cilovy_asteroid() -> void:
	var asteroid := CILOVY.instantiate()
	asteroid.position = _vybrat_souranice()
	asteroid.get_node('Barel').objevit(true)
	_nastavit_dohled(asteroid.get_node('Barel'), VIDITELNOST -20)
	$Asteroidy.add_child(asteroid)
	

func _vybrat_souranice() -> Vector3i:
	var vybrane_souradnice := Vector3i(
		randi_range(-HRANICE_POLE.x, HRANICE_POLE.x),
		randi_range(-HRANICE_POLE.y, HRANICE_POLE.y),
		randi_range(-HRANICE_POLE.z, HRANICE_POLE.z)
	) *10
	
	if vybrane_souradnice not in obsazene_pole:
		obsazene_pole.append(vybrane_souradnice)
		return vybrane_souradnice
	else:
		return _vybrat_souranice()


func _podoba_mlhy() -> void:
	#$Oblast.scale = HRANICE_POLE *10
	$Oblast/Podoba.get_active_material(0).get(
			'shader_parameter/tex_frg_11').gradient.set_color(1, BARVA)
	$Oblast/Podoba.show()
	#$Oblast/Hranice.disabled = false


func _nastavit_dohled(rodic:Node, mez:int) -> void:
	for prvek: Node3D in rodic.get_children():
		if prvek is MeshInstance3D:
			if not prvek.is_in_group('velky'):
				prvek.visibility_range_end = mez
				prvek.visibility_range_end_margin = 20
				prvek.visibility_range_fade_mode = \
						GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
			else:
				prvek.visibility_range_end = mez +20

func _prekroceni(body: Node3D, vstup: bool) -> void:
	if body.is_in_group('hrac'):
		match vstup:
			true:
				Signaly.mlha_zmenena.emit(HUSTOTA, BARVA)
				Signaly.objeveni_mlhoviny.emit(poradi)
				$Navigace.hide()
			false:
				Signaly.mlha_zmenena.emit(0)
				Signaly.opusteni_mlhoviny.emit()


func _spustit_navigaci(cilova_mlhovina: int) -> void:
	if cilova_mlhovina == poradi:
		$Navigace.show()
	else:
		$Navigace.hide()


func _nasadit_patrolu() -> void:
	var letovy_plan := _vytvorit_letovy_plan()
	var patrola := PATROLA.instantiate()
	$Lode.add_child(letovy_plan)
	letovy_plan.add_child(patrola)


func _vytvorit_letovy_plan() -> Path3D:
	var cesta := Path3D.new()
	cesta.curve = Curve3D.new()
	for _poradi in range(3):
		var nahodny_bod := Vector3(
			randf_range(-HRANICE_POLE.x, HRANICE_POLE.x),
			randf_range(-HRANICE_POLE.y, HRANICE_POLE.y),
			randf_range(-HRANICE_POLE.z, HRANICE_POLE.z),
		)
		cesta.curve.add_point(nahodny_bod *10)
	return cesta
	#var nahodne_natoceni := randf_range(0, 2*PI)
