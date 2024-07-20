extends WorldEnvironment

var posun_mlhavosti: Tween


func _ready() -> void:
	Signaly.mlha_zmenena.connect(_mlhavost)


func _mlhavost(mira:float, barva:=Color.BLACK) -> void:
	if barva:
		environment.volumetric_fog_emission = barva
	
	if mira:
		posun_mlhavosti = create_tween() \
			.set_trans(Tween.TRANS_QUINT) \
			.set_ease(Tween.EASE_OUT)

		posun_mlhavosti.tween_property(
			environment, 'volumetric_fog_density', mira, 2)
