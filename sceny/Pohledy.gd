extends Node3D

const CITLIVOST_MYSI = 0.001

@onready var Hrac := owner
@onready var Hlava := $Izolace/Krk/Hlava
@onready var Krk := $Izolace/Krk
@onready var Volny := $Osa/Volny

@onready var SEZNAM := [
	$Izolace/Krk/Hlava,
	$Busta,
	$Celo,
	$Temeno,
	$Osa/Volny
]

var otoceni_horizontaly: Tween
var otoceni_vertikaly: Tween

func _physics_process(_delta: float) -> void:
	_prepinani_pohledu()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Volny.current:
			_zamirit_pohled(event)


func _zamirit_pohled(event: InputEvent) -> void:
	var sirka: float = -event.relative.x *CITLIVOST_MYSI
	var vyska: float = event.relative.y *CITLIVOST_MYSI
	var MEZ: float = 0.015

	$Osa.rotate(transform.basis.y, clampf(sirka, -MEZ, MEZ))
	Volny.rotate(transform.basis.x, clampf(vyska, -MEZ, MEZ))


#func zastavit_tweeny() -> void:
	#if otoceni_horizontaly:
		#otoceni_horizontaly.kill()
	#if otoceni_vertikaly:
		#otoceni_vertikaly.kill()
	#printt(otoceni_horizontaly, otoceni_vertikaly)

#
#func _zvolit_akci(event: InputEvent) -> void:
	#_prepinani_pohledu(event)
	#_manipulace_akcni_kamery(event)
#
#
func _prepinani_pohledu() -> void:
	Volny.current = Input.is_action_pressed("rozhlednout")
	if Input.is_action_just_pressed("rozhlednout"):
		Volny.quaternion = Quaternion()
		$Osa.quaternion = Quaternion()
	
	## rotace mezi pohledy
	#if event.is_action_released('zmenit_pohled'):
		#prepnout_na_dalsi_kameru()
	## jednotlivé pohledy
	#elif event.is_action_pressed('pohled_1'):
		#_vypnout_soucasnou_kameru()
		#_zapnout_kameru(0)
	#elif event.is_action_pressed('pohled_2'):
		#_vypnout_soucasnou_kameru()
		#_zapnout_kameru(1)
	#elif event.is_action_pressed('pohled_3'):
		#_vypnout_soucasnou_kameru()
		#_zapnout_kameru(2)
	#elif event.is_action_pressed('pohled_4'):
		#_vypnout_soucasnou_kameru()
		#_zapnout_kameru(3)
	#elif event.is_action_pressed('pohled_5'):
		#_vypnout_soucasnou_kameru()
		#_zapnout_kameru(4)
#
#
#func _manipulace_akcni_kamery(event: InputEvent) -> void:
	#if event.is_action_pressed('navratit_pohled'):
		#navratit_pohled()
	#elif event.is_action_pressed('zvysit_pohled'):
		#_posunout_pohled(Vector3.UP, 1)
	#elif event.is_action_pressed('snizit_pohled'):
		#_posunout_pohled(Vector3.UP, -1)
	#elif event.is_action_pressed('oddalit_pohled'):
		#_posunout_pohled(Vector3.FORWARD, -1)
	#elif event.is_action_pressed('priblizit_pohled'):
		#_posunout_pohled(Vector3.FORWARD, 1)
#
#
func navratit_pohled(cas:=1) -> void:
	otoceni_horizontaly = create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT)
	otoceni_vertikaly = create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT)
	
	otoceni_horizontaly.tween_property(
			Krk, 'quaternion', Quaternion(
					Hrac.transform.basis.orthonormalized()), cas)
	otoceni_vertikaly.tween_property(
			Hlava, 'quaternion', Quaternion(), cas)
#
#
#func _posunout_pohled(osa:Vector3, smer:int) -> void:
	#const RYCHLOST_ODDALENI = 0.5
	#match osa:
		#Vector3.FORWARD:
			#Hlava.position.z += smer *RYCHLOST_ODDALENI
		#Vector3.UP:
			#Hlava.position.y += smer *RYCHLOST_ODDALENI
	#
	## omezit limitní hodnoty
	#Hlava.position.z = clampf(Hlava.position.z, 3, 15)
#
#
#func prepnout_na_dalsi_kameru() -> void:
	#var poradi_aktivni_kamery: int = _vratit_pozici_kamery()
	#_vypnout_soucasnou_kameru(poradi_aktivni_kamery)
	#
	#poradi_aktivni_kamery = _vratit_dalsi_kameru(poradi_aktivni_kamery)
	#_zapnout_kameru(poradi_aktivni_kamery)
#
#
#func _vratit_dalsi_kameru(poradi:=-1) -> int:
	#if poradi == -1:
		#poradi = _vratit_pozici_kamery()
		#
	#if poradi +1 == SEZNAM.size():
		#poradi = 0
	#else:
		#poradi += 1
	#return poradi
#
#
#func _vypnout_soucasnou_kameru(poradi:=-1) -> void:
	#if poradi == -1:
		#poradi = _vratit_pozici_kamery()
	#
	#SEZNAM[poradi].current = false
#
#
#func _vratit_pozici_kamery() -> int:
	#var poradi_kamery := int(0)
	#for kamera: Camera3D in SEZNAM:
		#if kamera.current:
			#return poradi_kamery
		#else:
			#poradi_kamery += 1
	#return -1
#
#
#func _zapnout_kameru(poradi: int) -> void:
	#if poradi +1 > SEZNAM.size():
		#push_warning('Není taková kamera')
		#return
	#
	#SEZNAM[poradi].current = true
