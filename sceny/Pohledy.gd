extends Node3D

const CITLIVOST_MYSI = 0.001

var aktivni_pohled: Camera3D

@onready var Hrac := owner
@onready var Krk := $Izolace/Krk

# jednotlivé pohledy
@onready var Hlava := $Izolace/Krk/Hlava
@onready var Busta := $Busta
@onready var Celo := $Celo
@onready var Temeno := $Temeno
@onready var Volny := $Osa/Volny

var otoceni_horizontaly: Tween
var otoceni_vertikaly: Tween

func _ready() -> void:
	prepnout_kameru(Hlava)


func prepnout_kameru(kamera: Camera3D) -> void:
	if aktivni_pohled:
		aktivni_pohled.current = false
	kamera.current = true
	aktivni_pohled = kamera


func _physics_process(_delta: float) -> void:
	_ukazat_volny_pohled()


func _ukazat_volny_pohled() -> void:
	Volny.current = Input.is_action_pressed("rozhlednout")
	if Input.is_action_just_pressed("rozhlednout"):
		Volny.quaternion = Quaternion()
		$Osa.quaternion = Quaternion()
	elif Input.is_action_just_released("rozhlednout"):
		aktivni_pohled.current = true


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Volny.current:
			_zamirit_pohled(event)
	elif event is InputEventMouseButton:
		_manipulace_hlavni_kamery(event)
	elif event is InputEventKey:
		_vybrat_kameru(event)


func _zamirit_pohled(event: InputEvent) -> void:
	var sirka: float = -event.relative.x *CITLIVOST_MYSI
	var vyska: float = event.relative.y *CITLIVOST_MYSI
	var MEZ: float = 0.015

	$Osa.rotate(transform.basis.y, clampf(sirka, -MEZ, MEZ))
	Volny.rotate(transform.basis.x, clampf(vyska, -MEZ, MEZ))


func _manipulace_hlavni_kamery(event: InputEvent) -> void:
	#if event.is_action_pressed('navratit_pohled'):
		#navratit_pohled()
	if event.is_action_pressed('zvysit_pohled'):
		_posunout_pohled(Vector3.UP, 1)
	elif event.is_action_pressed('snizit_pohled'):
		_posunout_pohled(Vector3.UP, -1)
	elif event.is_action_pressed('oddalit_pohled'):
		_posunout_pohled(Vector3.FORWARD, -1)
	elif event.is_action_pressed('priblizit_pohled'):
		_posunout_pohled(Vector3.FORWARD, 1)

#func zastavit_tweeny() -> void:
	#if otoceni_horizontaly:
		#otoceni_horizontaly.kill()
	#if otoceni_vertikaly:
		#otoceni_vertikaly.kill()
	#printt(otoceni_horizontaly, otoceni_vertikaly)


func _vybrat_kameru(event: InputEvent) -> void:
	if event.is_action_pressed('pohled_1'):
		prepnout_kameru(Hlava)
	elif event.is_action_pressed('pohled_2'):
		prepnout_kameru(Busta)
	elif event.is_action_pressed('pohled_3'):
		prepnout_kameru(Celo)
	elif event.is_action_pressed('pohled_4'):
		prepnout_kameru(Temeno)


func _posunout_pohled(osa:Vector3, smer:int) -> void:
	const RYCHLOST_ODDALENI = 0.5
	match osa:
		Vector3.FORWARD:
			Hlava.position.z += smer *RYCHLOST_ODDALENI
		Vector3.UP:
			Hlava.position.y += smer *RYCHLOST_ODDALENI
	
	# omezit limitní hodnoty
	Hlava.position.z = clampf(Hlava.position.z, 3, 15)


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
