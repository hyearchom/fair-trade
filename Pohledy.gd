extends Node3D

const CITLIVOST_MYSI = 0.001

@export var Hrac: CharacterBody3D
@onready var Hlava = $Oddeleni/Krk/Hlava
@onready var Krk = $Oddeleni/Krk

@onready var SEZNAM = [
	$Oddeleni/Krk/Hlava,
	$Celo,
	$Busta,
	$Temeno,
]

var otoceni_horizontaly: Tween
var otoceni_vertikaly: Tween

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#func _process(_delta):
	#printt(otoceni_horizontaly, otoceni_vertikaly)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		_zamirit_pohled(event)
	_zvolit_akci(event)


func _zamirit_pohled(event):
	var sirka = -event.relative.x *CITLIVOST_MYSI
	var vyska = event.relative.y *CITLIVOST_MYSI
	var MEZ: float = 0.015
	
	zastavit_tweeny()
	
	Krk.rotate(Krk.transform.basis.y, clampf(sirka, -MEZ, MEZ))
	Hlava.rotate(Hlava.transform.basis.x, clampf(vyska, -MEZ, MEZ))


func zastavit_tweeny() -> void:
	if otoceni_horizontaly:
		otoceni_horizontaly.kill()
	if otoceni_vertikaly:
		otoceni_vertikaly.kill()
	#print('tweeny_zastaveny')

func _zvolit_akci(event):
	if event.is_action_released('zmenit_pohled'):
		prepnout_na_dalsi_kameru()
	elif event.is_action_pressed('navratit_pohled'):
		navratit_pohled()
	elif event.is_action_pressed('pohled_1'):
		_vypnout_soucasnou_kameru()
		_zapnout_kameru(0)
	elif event.is_action_pressed('pohled_2'):
		_vypnout_soucasnou_kameru()
		_zapnout_kameru(1)
	elif event.is_action_pressed('pohled_3'):
		_vypnout_soucasnou_kameru()
		_zapnout_kameru(2)
	elif event.is_action_pressed('pohled_4'):
		_vypnout_soucasnou_kameru()
		_zapnout_kameru(3)
	elif event.is_action_pressed('pohled_5'):
		_vypnout_soucasnou_kameru()
		_zapnout_kameru(4)
	
	if event.is_action_pressed('zvysit_pohled'):
		_posunout_pohled(Vector3.UP, 1)
	elif event.is_action_pressed('snizit_pohled'):
		_posunout_pohled(Vector3.UP, -1)
	elif event.is_action_pressed('oddalit_pohled'):
		_posunout_pohled(Vector3.FORWARD, -1)
	elif event.is_action_pressed('priblizit_pohled'):
		_posunout_pohled(Vector3.FORWARD, 1)


func navratit_pohled(cas=1):
	otoceni_horizontaly = create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT)
	otoceni_vertikaly = create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT)
	#zamek_pohledu = true

	otoceni_horizontaly.tween_property(
		Krk, 'quaternion', Quaternion(
				Hrac.transform.basis.orthonormalized()), cas)
	otoceni_vertikaly.tween_property(
		Hlava, 'quaternion', Quaternion(), cas)
	
	#await otoceni_horizontaly.finished
	#await otoceni_vertikaly.finished
	#zamek_pohledu = false


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
	_vypnout_soucasnou_kameru(poradi_aktivni_kamery)
	
	poradi_aktivni_kamery = _vratit_dalsi_kameru(poradi_aktivni_kamery)
	_zapnout_kameru(poradi_aktivni_kamery)


func _vratit_dalsi_kameru(poradi=-1) -> int:
	if poradi == -1:
		poradi = _vratit_pozici_kamery()
		
	if poradi +1 == SEZNAM.size():
		poradi = 0
	else:
		poradi += 1
	return poradi


func _vypnout_soucasnou_kameru(poradi=-1) -> void:
	if poradi == -1:
		poradi = _vratit_pozici_kamery()
	
	SEZNAM[poradi].current = false


func _vratit_pozici_kamery() -> int:
	var poradi_kamery := int(0)
	for kamera in SEZNAM:
		if kamera.current:
			return poradi_kamery
		else:
			poradi_kamery += 1
	return -1


func _zapnout_kameru(poradi) -> void:
	if poradi +1 > SEZNAM.size():
		push_warning('Není taková kamera')
		return
	
	SEZNAM[poradi].current = true
