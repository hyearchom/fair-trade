extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CITLIVOST_MYSI = 0.01
const ZORNE_POLE = 90.0

@onready var Oci = $Hlava/Oci

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	#print($Hlava/Oci/Dotek.get_collider())
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("skok") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	#var input_dir = Input.get_vector("doleva", "doprava", "dopredu", "dozadu")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var direction = ($Hlava/Oci.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		zamirit_pohled(event)
	#elif event is InputEventMouseButton:
		#_zvolit_akci(event)

func zamirit_pohled(event):
	var sirka = -event.relative.x *CITLIVOST_MYSI
	var vyska = event.relative.y *CITLIVOST_MYSI
		
	$Hlava.rotate_y(sirka)
	Oci.rotate_x(vyska)
	Oci.rotation.x = clampf(Oci.rotation.x, -deg_to_rad(ZORNE_POLE), deg_to_rad(ZORNE_POLE))

#func _zvolit_akci(event):
	#var terc = $Hlava/Oci/Dotek.get_collider()
	#if terc:
		#if event.is_action_pressed("retez"):
			#$Akce.spoustat(terc)
		#elif event.is_action_pressed("kop"):
			#$Akce.vykopnout(terc)
