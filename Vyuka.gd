extends VBoxContainer

const CEDULE := preload("res://sceny/cedule.tscn")

func _ready() -> void:
	pass
	#dat_radu('vpred', 'drzet', 'move forward')


func dat_radu(akce: StringName, druh_akce:StringName, vysledna_cinnost:String,
		cas_zobrazeni:=float(2)) -> void:
	var Sdeleni := NodePath('Odsazeni/Sdeleni')
	var Zmizeni := NodePath('Zmizeni')
	
	var rada := CEDULE.instantiate()
	rada.get_node(Sdeleni).text = _ziskat_vyrok(akce, druh_akce, vysledna_cinnost)
	add_child(rada)
	rada.get_node(Zmizeni).start(cas_zobrazeni)
	await rada.get_node(Zmizeni).timeout
	rada.queue_free()


func _ziskat_vyrok(akce: StringName, druh_akce:StringName, vysledna_cinnost:String
		)-> String:
	const AKCE: Dictionary = {
		'stisk': 'Press',
		'drzet': 'Hold',
		'pohnout': 'Move',
	}
	var vyrok: String = '{0} {1} to {2}'.format([
		AKCE[druh_akce],
		_ziskat_klavesu(akce),
		vysledna_cinnost])
	return vyrok


func _ziskat_klavesu(nazev_akce: StringName) -> String:
	var odkaz_na_akci := 'input/' + nazev_akce
	var vypis_klavesy: String = ProjectSettings.get(odkaz_na_akci)\
			.events[0].as_text()
	var nazev_klavesy := vypis_klavesy.get_slice('(', 0)
	nazev_klavesy = nazev_klavesy.strip_edges()
	return nazev_klavesy
