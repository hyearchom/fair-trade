extends Node

func _ready() -> void:
	Signaly.zacatek_hry.connect(_podkresova_hudba.bind(true))
	Signaly.konec_hry.connect(_podkresova_hudba.bind(false))
	
	Signaly.vyslani_strely.connect(_akcni_hudba.bind(true).unbind(2))
	Signaly.strela_znicena.connect(_akcni_hudba.bind(false).unbind(1))
	Signaly.konec_hry.connect(_akcni_hudba.bind(false))
	

func _akcni_hudba(stav:bool) -> void:
	zapnout_skladbu($Boj, stav)


func zapnout_skladbu(skladba:AudioStreamPlayer, stav:bool) -> void:
	if stav:
		skladba.play()
	else:
		skladba.stop()


func _podkresova_hudba(stav:bool) -> void:
	zapnout_skladbu($Atmosfera, stav)
