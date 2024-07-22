extends CharacterBody3D

const MAX_VYKON = 12.0
const ZRYCHLENI = 0.2

var vykon: float
var zmena_rotace: bool
var tempomat: bool


func _ready() -> void:
	add_to_group('hrac')


func _physics_process(_delta: float) -> void:
	_nastaveni_smeru_lodi()
	_pohled_podle_pohybu()
	
	vykon = _nastaveni_rychlosti_lodi()
	if vykon:
		velocity = -transform.basis.z * vykon
	# v případě kolize, funkce pohybu vrací true
	if move_and_slide():
		_naraz()


func _nastaveni_smeru_lodi() -> void:
	if Input.is_action_pressed("dopredu"):
		_otocit_lod(Vector3.LEFT, 1)
	if Input.is_action_pressed("dozadu"):
		_otocit_lod(Vector3.LEFT, -1)
	if Input.is_action_pressed("doleva"):
		_otocit_lod(Vector3.FORWARD, -1)
	if Input.is_action_pressed("doprava"):
		_otocit_lod(Vector3.FORWARD, 1)


func _otocit_lod(osa:Vector3, smer:int) -> void:
	var VELIKOST_OTACENI := 0.02
	rotate_object_local(osa, smer *VELIKOST_OTACENI)
	zmena_rotace = true


func _nastaveni_rychlosti_lodi() -> float:
	if Input.is_action_pressed("vpred"):
		vykon += ZRYCHLENI
		tempomat = false
	elif Input.is_action_pressed("vzad"):
		vykon -= ZRYCHLENI
		tempomat = false
	elif tempomat:
		vykon += ZRYCHLENI
	else:
		var zpomaleni := vykon *0.05
		vykon -= zpomaleni 
	
	# omezení vykonu lodi
	vykon = clampf(vykon, -MAX_VYKON, MAX_VYKON)
	return vykon


func _pohled_podle_pohybu() -> void:
	if not Input.is_anything_pressed():
		if zmena_rotace:
			zmena_rotace = false
			$Pohledy.navratit_pohled(2)
	

func _naraz() -> void:
	var ucastnik: Node3D = get_last_slide_collision().get_collider()
	if ucastnik.is_in_group('zbozi'):
		Signaly.emit_signal('zbozi_ziskano')
		ucastnik.queue_free()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("drzet_rychlost"):
		tempomat = not tempomat
