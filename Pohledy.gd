extends Node3D

const CITLIVOST_MYSI = 0.001

@export var Hrac: CharacterBody3D
@onready var Hlava = $Oddeleni/Krk/Hlava
@onready var Krk = $Oddeleni/Krk

@onready var SEZNAM = [
	$Oddeleni/Krk/Hlava,
	$Celo,
	$Busta
]

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		_zamirit_pohled(event)
	_zvolit_akci(event)


func _zamirit_pohled(event):
	var sirka = -event.relative.x *CITLIVOST_MYSI
	var vyska = event.relative.y *CITLIVOST_MYSI
	var MEZ: float = 0.015
	
	Krk.rotate(Krk.transform.basis.y, clampf(sirka, -MEZ, MEZ))
	Hlava.rotate(Hlava.transform.basis.x, clampf(vyska, -MEZ, MEZ))


func _navratit_pohled(cas=1):
	
	var otoceni_horizontaly = create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT)
	var otoceni_vertikaly = create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT)

	otoceni_horizontaly.tween_property(
		Krk, 'quaternion', Quaternion(
				Hrac.transform.basis.orthonormalized()), cas)
		#Krk, 'quaternion', Quaternion(), cas)
	otoceni_vertikaly.tween_property(
		Hlava, 'quaternion', Quaternion(), cas)


func _zvolit_akci(event):
	if event.is_action_released('zmenit_pohled'):
		prepnout_na_dalsi_kameru()
	elif event.is_action_pressed('navratit_pohled'):
		_navratit_pohled()
	#elif event.is_action_pressed('zamirit_lod'):
		#_otocit_lod_za_pohledem()
	
	if event.is_action_pressed('zvysit_pohled'):
		_posunout_pohled(Vector3.UP, 1)
	elif event.is_action_pressed('snizit_pohled'):
		_posunout_pohled(Vector3.UP, -1)
	elif event.is_action_pressed('oddalit_pohled'):
		_posunout_pohled(Vector3.FORWARD, -1)
	elif event.is_action_pressed('priblizit_pohled'):
		_posunout_pohled(Vector3.FORWARD, 1)


func _posunout_pohled(osa, smer):
	const RYCHLOST_ODDALENI = 0.5
	match osa:
		Vector3.FORWARD:
			Hlava.position.z += smer *RYCHLOST_ODDALENI
		Vector3.UP:
			Hlava.position.y += smer *RYCHLOST_ODDALENI
	
	# omezit limitní hodnoty
	Hlava.position.z = clampf(Hlava.position.z, 3, 15)


func prepnout_na_dalsi_kameru() -> void:
	var poradi_aktivni_kamery = _vratit_pozici_kamery()
	# vypne současnou kameru
	SEZNAM[poradi_aktivni_kamery].current = false
	
	# určí další kameru
	if poradi_aktivni_kamery +1 == SEZNAM.size():
		poradi_aktivni_kamery = 0
	else:
		poradi_aktivni_kamery += 1
	
	# aktivuje další kameru
	SEZNAM[poradi_aktivni_kamery].current = true
	
func _vratit_pozici_kamery() -> int:
	var poradi_kamery := int(0)
	for kamera in SEZNAM:
		if kamera.current:
			return poradi_kamery
		else:
			poradi_kamery += 1
	return -1
