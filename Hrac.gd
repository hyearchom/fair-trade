extends CharacterBody3D

const MAX_VYKON = 10.0
const ZRYCHLENI = 0.2

var vykon: float
var zmena_rotace: bool

func _ready():
	add_to_group('hrac')

func _physics_process(_delta):
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
	else:
		var zpomaleni = vykon *0.05
		vykon -= zpomaleni 
	vykon = clampf(vykon, -MAX_VYKON, MAX_VYKON)

	
	if not Input.is_anything_pressed():
		if zmena_rotace:
			zmena_rotace = false
			$Pohledy.navratit_pohled(2)
	
	#var input_dir = Input.get_vector("doleva", "doprava", "dopredu", "dozadu")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if vykon:
		velocity = -transform.basis.z * vykon
	#else:
		#velocity.x = move_toward(velocity.x, 0, vykon)
		#velocity.y = move_toward(velocity.y, 0, vykon)
		#velocity.z = move_toward(velocity.z, 0, vykon)

	var kolize = move_and_slide()
	if kolize:
		print('Naraz!')


func _otocit_lod(osa, smer):
	var VELIKOST_OTACENI = 0.02
	rotate_object_local(osa, smer *VELIKOST_OTACENI)
	zmena_rotace = true

#func _otocit_lod_za_pohledem():
	#var otoceni_lodi = create_tween() \
		#.set_trans(Tween.TRANS_QUINT) \
		#.set_ease(Tween.EASE_OUT)
	#
	#otoceni_lodi.tween_property(
		#self, 'quaternion', 
		#Quaternion(
			#(Hlava.transform.basis *Krk.transform.basis).orthonormalized()
			#),
		#1)
	
	#await otoceni_lodi.finished
	#_navratit_pohled()
