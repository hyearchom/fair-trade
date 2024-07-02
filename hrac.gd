extends CharacterBody3D

const MAX_VYKON = 5.0
const ZRYCHLENI = 0.1

const CITLIVOST_MYSI = 0.001
#const ZORNE_POLE = 90.0

var vykon: float
#var zamek_menevrovani

@onready var Vertikala = $Horizontala/Vertikala
var otoceni_horizontaly: Tween
var otoceni_vertikaly: Tween


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	if Input.is_action_pressed("dopredu"):
		_otocit_lod(Vector3.LEFT, 1)
	if Input.is_action_pressed("dozadu"):
		_otocit_lod(Vector3.LEFT, -1)
	if Input.is_action_pressed("doleva"):
		_otocit_lod(Vector3.FORWARD, -1)
	if Input.is_action_pressed("doprava"):
		_otocit_lod(Vector3.FORWARD, 1)
	
	if Input.is_action_pressed("zrychlit"):
		vykon += ZRYCHLENI
	elif Input.is_action_pressed("zpomalit"):
		vykon -= ZRYCHLENI
	vykon = clampf(vykon, -MAX_VYKON, MAX_VYKON)
	
	#var input_dir = Input.get_vector("doleva", "doprava", "dopredu", "dozadu")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if vykon:
		velocity = -transform.basis.z * vykon
	else:
		velocity.x = move_toward(velocity.x, 0, vykon)
		velocity.y = move_toward(velocity.y, 0, vykon)
		velocity.z = move_toward(velocity.z, 0, vykon)

	move_and_slide()


func _otocit_lod(osa, smer):
	var VELIKOST_OTACENI = 0.02
	rotate_object_local(osa, smer *VELIKOST_OTACENI)


func _unhandled_input(event):
	#if not zamek_menevrovani:
	if event is InputEventMouseMotion:
		_zamirit_pohled(event)
	_zvolit_akci(event)


func _zamirit_pohled(event):
	var sirka = -event.relative.x *CITLIVOST_MYSI
	var vyska = event.relative.y *CITLIVOST_MYSI
	var MEZ: float = 0.015
	
	$Horizontala.rotate_y(clampf(sirka, -MEZ, MEZ))
	Vertikala.rotate_x(clampf(vyska, -MEZ, MEZ))
	#rotate_object_local(Vector3.FORWARD, clampf(sirka, -MEZ, MEZ))
	#rotate_object_local(Vector3.LEFT, clampf(vyska, -MEZ, MEZ))


func _navratit_pohled():
	otoceni_horizontaly = create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT)
	otoceni_vertikaly = create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT)

	otoceni_horizontaly.tween_property(
		$Horizontala, 'quaternion', Quaternion(), 1)
	otoceni_vertikaly.tween_property(
		Vertikala, 'quaternion', Quaternion(), 1)


func _zvolit_akci(event):
	if event.is_action_pressed('oddalit'):
		_posunout_pohled(-1)
	elif event.is_action_pressed('priblizit'):
		_posunout_pohled(1)
	elif event.is_action_pressed('navratit_pohled'):
		_navratit_pohled()

func _posunout_pohled(smer):
	const RYCHLOST_ODDALENI = 0.5
	Vertikala.position.z += smer *RYCHLOST_ODDALENI
	#omezit limitní hodnoty
	Vertikala.position.z = clampf(Vertikala.position.z, 3, 15)
	
