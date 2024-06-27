extends CharacterBody3D

const RYCHLOST = 5.0
const CITLIVOST_MYSI = 0.001
const ZORNE_POLE = 90.0

var zamek_menevrovani

@onready var Vertikala = $Horizontala/Vertikala

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	var input_dir = Input.get_vector("doleva", "doprava", "dopredu", "dozadu")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var direction = ($Horizontala/Vertikala.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir:
		#velocity.x = direction.x * RYCHLOST
		#velocity.y = direction.y * RYCHLOST
		#velocity.z = direction.z * RYCHLOST
		velocity = direction * RYCHLOST
		zamek_menevrovani = false
		$pruzkumnik.transform.basis = Basis.looking_at(velocity)
	else:
		#velocity = move_toward(velocity, 0, Vector3.ONE *RYCHLOST)
		velocity.x = move_toward(velocity.x, 0, RYCHLOST)
		velocity.y = move_toward(velocity.y, 0, RYCHLOST)
		velocity.z = move_toward(velocity.z, 0, RYCHLOST)
		zamek_menevrovani = true

	move_and_slide()
	print(velocity)

func _unhandled_input(event):
	if not zamek_menevrovani:
		if event is InputEventMouseMotion:
			zamirit_pohled(event)
		#elif event is InputEventMouseButton:
			#_zvolit_akci(event)

func zamirit_pohled(event):
	var sirka = -event.relative.x *CITLIVOST_MYSI
	var vyska = event.relative.y *CITLIVOST_MYSI
	var mez: float = 0.015
	
	$Horizontala.rotate_y(clampf(sirka, -mez, mez))
	#$pruzkumnik.rotate_y(clampf(sirka, -mez, mez))
	Vertikala.rotate_x(clampf(vyska, -mez, mez))
	#$pruzkumnik.rotate_x(clampf(vyska, -mez, mez))
	#Vertikala.rotation.x = clampf(Vertikala.rotation.x, -deg_to_rad(ZORNE_POLE), deg_to_rad(ZORNE_POLE))

#func _zvolit_akci(event):
	#var terc = $Horizontala/Vertikala/Dotek.get_collider()
	#if terc:
		#if event.is_action_pressed("retez"):
			#$Akce.spoustat(terc)
		#elif event.is_action_pressed("kop"):
			#$Akce.vykopnout(terc)
