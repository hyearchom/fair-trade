extends Node

func _ready() -> void:
	Signaly.zacatek_hry.connect(podkresova_hudba.bind(true))
	Signaly.konec_hry.connect(podkresova_hudba.bind(false))
	
	Signaly.vyslani_strely.connect(akcni_hudba.bind(true).unbind(2))
	Signaly.strela_znicena.connect(akcni_hudba.bind(false).unbind(1))
	Signaly.konec_hry.connect(akcni_hudba.bind(false))
	

func akcni_hudba(stav:bool) -> void:
	zapnout_skladbu($Boj, stav)


func zapnout_skladbu(skladba:AudioStreamPlayer, stav:bool) -> void:
	if stav:
		skladba.play()
	else:
		skladba.stop()


func podkresova_hudba(stav:bool) -> void:
	zapnout_skladbu($Atmosfera, stav)
