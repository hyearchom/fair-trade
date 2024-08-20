extends CharacterBody3D

const CITLIVOST_MYSI = 0.001

const MAX_rychlost = 12.0
const ZRYCHLENI = 0.2

var rychlost: float
var tempomat: bool

var zmena_rotace: bool

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	add_to_group('hrac')
	Signaly.objeveni_mlhoviny.connect(rozsvitit_svetlomety.bind(true).unbind(1))
	Signaly.opusteni_mlhoviny.connect(rozsvitit_svetlomety.bind(false))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if not $Pohledy.Volny.current:
			if rychlost:
				_zamirit_pohled(event)
		else:
			$Pohledy._zamirit_pohled(event)


func _physics_process(_delta: float) -> void:
	zmena_rotace = Input.is_action_pressed("rotace")
	
	rychlost = _nastaveni_rychlosti_lodi()
	_signalizace_pohybu(rychlost)
	if rychlost:
		velocity = -transform.basis.z * rychlost
	# v případě kolize, funkce pohybu vrací true
	if move_and_slide():
		_naraz()

func _zmenit_rotaci(event: InputEvent) -> void:
	var sirka: float = -event.relative.x *CITLIVOST_MYSI
	var MEZ: float = 0.025
	
	rotate(transform.basis.z, clampf(sirka, -MEZ, MEZ))
	
	$Pohledy.navratit_pohled(2)



func _zamirit_pohled(event: InputEvent) -> void:
	var sirka: float = -event.relative.x *CITLIVOST_MYSI
	var vyska: float = -event.relative.y *CITLIVOST_MYSI
	var MEZ: float = 0.0125
	
	if zmena_rotace:
		rotate(transform.basis.z, clampf(sirka, 2* -MEZ, 2* MEZ))
	else:
		rotate(transform.basis.y, clampf(sirka, -MEZ, MEZ))
		rotate(transform.basis.x, clampf(vyska, -MEZ, MEZ))
	
	$Pohledy.navratit_pohled(2)


func _otocit_lod(osa:Vector3, smer:int) -> void:
	var VELIKOST_OTACENI := 0.02
	rotate_object_local(osa, smer *VELIKOST_OTACENI)


func _nastaveni_rychlosti_lodi() -> float:
	if Input.is_action_pressed("vpred"):
		rychlost += ZRYCHLENI
		tempomat = false
	elif Input.is_action_pressed("vzad"):
		rychlost -= ZRYCHLENI
		tempomat = false
	elif tempomat:
		rychlost += ZRYCHLENI
	else:
		if rychlost < 0.01:
			rychlost = 0.0
		else:
			var zpomaleni := rychlost *0.05
			rychlost -= zpomaleni
	
	# omezení rychlostu lodi
	rychlost = clampf(rychlost, -MAX_rychlost, MAX_rychlost)
	return rychlost


func _signalizace_pohybu(soucasny_rychlost:float) -> void:
	var pomer_rychlostu: float = abs(soucasny_rychlost)/MAX_rychlost 
	$Lod.get_active_material(2).emission_energy_multiplier = pomer_rychlostu *2
	$Vitr.emitting = int(pomer_rychlostu)


func _pohled_podle_pohybu() -> void:
	if not Input.is_anything_pressed():
		if zmena_rotace:
			zmena_rotace = false
			$Pohledy.navratit_pohled(2)
	

func _naraz() -> void:
	var ucastnik: Node3D = get_last_slide_collision().get_collider()
	if ucastnik.is_in_group('zbozi'):
		Signaly.emit_signal('zbozi_ziskano')
		ucastnik.objevit(false)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("drzet_rychlost"):
		tempomat = not tempomat


func rozsvitit_svetlomety(stav:bool) -> void:
	$Lod.get_active_material(3).emission_enabled = stav
	$Svetla.light_energy = 7 *int(stav)


func navratit_na_zacatek() -> void:
	global_position = Vector3.ZERO
	global_rotation = Vector3.ZERO
	$Pohledy.navratit_pohled(0.1)
