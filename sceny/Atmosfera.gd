extends WorldEnvironment

var posun_mlhavosti: Tween
var posun_svetelnosti: Tween


func _ready() -> void:
	environment.adjustment_brightness = 0
	
	Signaly.mlha_zmenena.connect(_mlhavost)
	Signaly.zacatek_hry.connect(_rozsvitit.bind(true).bind(5))
	Signaly.konec_hry.connect(_rozsvitit.bind(false))
	Signaly.epilog.connect(_rozsvitit.bind(false))

func _mlhavost(mira:float, barva:=Color.BLACK) -> void:
	if barva:
		environment.volumetric_fog_emission = barva
	
	# ochrana proti zbytečnému přechodu
	if not mira and not environment.volumetric_fog_density:
		return
	
	posun_mlhavosti = create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT)

	posun_mlhavosti.tween_property(
		environment, 'volumetric_fog_density', mira, 2)


func _rozsvitit(stav:bool, cas:=float(3)) -> void:
	var cilova_hodnota := int(stav)
	
	posun_svetelnosti = create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT)
	
	posun_svetelnosti.tween_property(
		environment, 'adjustment_brightness', cilova_hodnota, cas)
