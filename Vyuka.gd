extends VBoxContainer

const CEDULE := preload("res://sceny/cedule.tscn")
const OVLADACE: Dictionary = {
	'mys': preload("res://grafika/symbol_mys.svg"),
	'klavesnice': preload("res://grafika/symbol_klavesnice.svg"),
	'konzole': preload("res://grafika/symbol_konzole.svg")
}

@onready var Zmizeni: Timer = $Zmizeni

var ocekavana_klavesa: StringName

func _ready() -> void:
	spustit_vyuku()


func spustit_vyuku() -> void:
	dat_radu('move forward', 'Hold', 'vpred')
	await _pauza_mezi_radami()
	dat_radu("choose ship's direction", 'Move [b]Mouse[/b]', '', 4)
	await _pauza_mezi_radami()
	dat_radu('lock maximum speed', 'Press', 'drzet_rychlost')
	await _pauza_mezi_radami()
	dat_radu('look around', 'Move [b]Mouse[/b] with holding', 'rozhlednout')
	await _pauza_mezi_radami(0)
	await Signaly.objeveni_mlhoviny
	dat_radu('move backwards', 'Hold', 'vzad')
	await _pauza_mezi_radami(0)
	Signaly.emit_signal("vyuka_dokoncena")


func _pauza_mezi_radami(cas:=float(2)) -> void:
	var Pauza: Timer = $Pauza
	await Zmizeni.timeout
	Pauza.start(cas)
	await Pauza.timeout


func dat_radu(vysledna_cinnost:String, druh_akce:StringName, akce: StringName='',
		cas_zobrazeni:=float(0)) -> void:
	var Sdeleni := NodePath('%Sdeleni')
	var Ovladac := NodePath('%Ovladac')
	
	var rada := CEDULE.instantiate()
	var vyrok: String
	ocekavana_klavesa = akce
	
	vyrok = _ziskat_vyrok(vysledna_cinnost, druh_akce, akce)
	rada.get_node(Sdeleni).text = vyrok
	rada.get_node(Ovladac).texture = _ziskat_ikonu(vyrok)
	add_child(rada)
	await _zobrazit_radu(cas_zobrazeni)
	rada.queue_free()


func _ziskat_vyrok(vysledna_cinnost:String, druh_akce:String, akce:StringName, 
		)-> String:
	var vyrok: String = '{0}[b]{1}[/b] to {2}'.format([
		druh_akce,
		_ziskat_klavesu(akce) if akce else '',
		vysledna_cinnost])
	return vyrok


func _ziskat_klavesu(nazev_akce: StringName) -> String:
	var odkaz_na_akci := 'input/' + nazev_akce
	var vypis_klavesy: String = ProjectSettings.get(odkaz_na_akci)\
			.events[0].as_text()
	var nazev_klavesy := vypis_klavesy.get_slice('(', 0)
	nazev_klavesy = nazev_klavesy.strip_edges()
	nazev_klavesy = ' ' + nazev_klavesy
	return nazev_klavesy


func _ziskat_ikonu(akce: String) -> CompressedTexture2D:
	var ikona: CompressedTexture2D
	if 'Mouse' in akce:
		ikona = OVLADACE['mys']
	elif 'Joypad' in akce:
		ikona = OVLADACE['konzole']
	else:
		ikona = OVLADACE['klavesnice']
	return ikona


func _zobrazit_radu(cas:float) -> void:
	var Animace: AnimationPlayer = $Animace
	
	if Zmizeni.is_stopped():
		Animace.play("prijezd")
		if not cas:
			Zmizeni.start()
		else:
			Zmizeni.start(cas)
	await Zmizeni.timeout
	Animace.play("odjezd")
	await Animace.animation_finished


func _input(event: InputEvent) -> void:
	if ocekavana_klavesa:
		if event.is_action_pressed(ocekavana_klavesa):
			Zmizeni.stop()
			Zmizeni.emit_signal("timeout")
