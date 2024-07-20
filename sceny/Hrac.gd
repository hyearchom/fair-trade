extends CharacterBody3D

const MAX_VYKON = 10.0
const ZRYCHLENI = 0.2

var vykon: float
var zmena_rotace: bool
var tempomat: bool

func _ready() -> void:
	add_to_group('hrac')

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("dopredu"):
		_otocit_lod(Vector3.LEFT, 1)
	if Input.is_action_pressed("dozadu"):
		_otocit_lod(Vector3.LEFT, -1)
	if Input.is_action_pressed("doleva"):
		_otocit_lod(Vector3.FORWARD, -1)
	if Input.is_action_pressed("doprava"):
		_otocit_lod(Vector3.FORWARD, 1)
	
	if Input.is_action_pressed("vpred"):
		vykon += ZRYCHLENI
		tempomat = false
	elif Input.is_action_pressed("vzad"):
		vykon -= ZRYCHLENI
		tempomat = false
	elif tempomat:
		vykon += ZRYCHLENI
	else:
		var zpomaleni = vykon *0.05
		vykon -= zpomaleni 
	vykon = clampf(vykon, -MAX_VYKON, MAX_VYKON)

	if not Input.is_anything_pressed():
		if zmena_rotace:
			zmena_rotace = false
			$Pohledy.navratit_pohled(2)
	
	if vykon:
		velocity = -transform.basis.z * vykon

	var kolize = move_and_slide()
	if kolize:
		_naraz()


func _otocit_lod(osa, smer) -> void:
	var VELIKOST_OTACENI := 0.02
	rotate_object_local(osa, smer *VELIKOST_OTACENI)
	zmena_rotace = true


func _naraz() -> void:
	var ucastnik: Node3D = get_last_slide_collision().get_collider()
	if ucastnik.is_in_group('zbozi'):
		Signaly.emit_signal('zbozi_ziskano')
		ucastnik.queue_free()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("drzet_rychlost"):
		tempomat = not tempomat