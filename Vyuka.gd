extends VBoxContainer

const CEDULE := preload("res://sceny/cedule.tscn")
const OVLADACE: Dictionary = {
	'mys': preload("res://grafika/symbol_mys.svg"),
	'klavesnice': preload("res://grafika/symbol_klavesnice.svg"),
	'konzole': preload("res://grafika/symbol_konzole.svg")
}

func _ready() -> void:
	#dat_radu('move forward', 'hold', 'test')
	dat_radu('move forward', 'hold', 'dopredu')
	#dat_radu("choose ship's direction", 'move mouse')


func dat_radu(vysledna_cinnost:String, druh_akce:StringName, akce: StringName='',
		cas_zobrazeni:=float(2)) -> void:
	var Sdeleni := NodePath('%Sdeleni')
	var Ovladac := NodePath('%Ovladac')
	var Animace: AnimationPlayer = $Animace
	var Zmizeni: Timer = $Zmizeni
	
	var rada := CEDULE.instantiate()
	var vyrok: String
	vyrok = _ziskat_vyrok(vysledna_cinnost, druh_akce, akce)
	rada.get_node(Sdeleni).text = vyrok
	rada.get_node(Ovladac).texture = _ziskat_ikonu(vyrok)
	
	add_child(rada)
	Animace.play("prijezd")
	Zmizeni.start(cas_zobrazeni)
	await Zmizeni.timeout
	Animace.play("odjezd")
	await Animace.animation_finished
	rada.queue_free()


func _ziskat_vyrok(vysledna_cinnost:String, druh_akce:String, akce:StringName, 
		)-> String:
	var vyrok: String = '{0} [b][font_size=30]{1}[/font_size][/b] to {2}'.format([
		druh_akce.capitalize(),
		_ziskat_klavesu(akce) if akce else '',
		vysledna_cinnost])
	return vyrok


func _ziskat_klavesu(nazev_akce: StringName) -> String:
	var odkaz_na_akci := 'input/' + nazev_akce
	var vypis_klavesy: String = ProjectSettings.get(odkaz_na_akci)\
			.events[0].as_text()
	var nazev_klavesy := vypis_klavesy.get_slice('(', 0)
	nazev_klavesy = nazev_klavesy.strip_edges()
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
