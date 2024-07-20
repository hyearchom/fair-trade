extends Label

var posun_viditelnosti_zpravy: Tween


func _ready() -> void:
	Signaly.zbozi_ziskano.connect(_vypsat_zmenu)


func _vypsat_zmenu() -> void:
	var Hra = $'/root/Hra' 
	text = 'Cargo collected: ({0}/{1})'.format(
		[str(Hra.zbozi), str(Hra.pozadavek_zbozi)])
	modulate.a = 1
	_postupne_zmizeni_zpravy()
	

func _postupne_zmizeni_zpravy() -> void:
	posun_viditelnosti_zpravy = create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT)
	
	#pauza pro přectení zprávy
	posun_viditelnosti_zpravy.tween_interval(5)
	
	posun_viditelnosti_zpravy.tween_property(
		self, 'modulate', Color(0,0,0,0), 3)
		
