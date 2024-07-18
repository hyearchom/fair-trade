extends WorldEnvironment

var posun_mlhavosti: Tween


func _ready() -> void:
	Signaly.zmenit_mlhu.connect(_mlhavost)


func _mlhavost(mira) -> void:
	#environment.volumetric_fog_density = mira
	
	posun_mlhavosti = create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT)

	posun_mlhavosti.tween_property(
		environment, 'volumetric_fog_density', mira, 2)
