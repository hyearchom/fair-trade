extends Label

var posun_viditelnosti_zpravy: Tween
var ZPRAVY := {
	'vyhledej': 'Collect hidden cargo',
	'navigace': 'Navigation updated',
	'umrti': 'Proviant wasted',
	'vyhra': "Let's install some guns!"
}

func _ready() -> void:
	Signaly.objeveni_mlhoviny.connect(_overeni_objeveni)
	Signaly.zbozi_ziskano.connect(_vypsat_zmenu.bind('navigace'))
	Signaly.konec_hry.connect(_vypsat_zmenu.bind('umrti'))
	Signaly.epilog.connect(_vypsat_zmenu.bind('vyhra'))


func _overeni_objeveni(oznaceni:int) -> void:
	var Hra: Node = $'/root/Hra'
	if Hra.cilova_mlhovina == oznaceni:
		_vypsat_zmenu('vyhledej')

func _vypsat_zmenu(typ_zpravy: String) -> void:
	# zpozdění pro přepis proměných
	await get_tree().process_frame
	
	text = ZPRAVY[typ_zpravy]
	modulate.a = 1
	_postupne_zmizeni_zpravy()
	

func _postupne_zmizeni_zpravy() -> void:
	posun_viditelnosti_zpravy = create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT)
	
	#pauza pro přectení zprávy
	posun_viditelnosti_zpravy.tween_interval(2)
	
	posun_viditelnosti_zpravy.tween_property(
		self, 'modulate', Color(1,1,1,0), 3)
		
