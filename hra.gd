extends Node

@export var pozadavek_zbozi: int = 5
var zbozi: int = 0
var cilova_mlhovina: int = 0


func _ready() -> void:
	Signaly.zbozi_ziskano.connect(func() -> void: zbozi += 1)
	Signaly.zbozi_ziskano.connect(_postup_hrou)
	Signaly.konec_hry.connect(_restartovat_hru)
	_navigovat_dale()
	Signaly.zacatek_hry.emit()


func _postup_hrou() -> void:
	if pozadavek_zbozi == zbozi:
		Signaly.epilog.emit()
	else:
		cilova_mlhovina += 1
		_navigovat_dale()


func _navigovat_dale() -> void:
	get_tree().call_group('mlhoviny', '_spustit_navigaci', cilova_mlhovina)


func _restartovat_hru() -> void:
	zbozi = 0
	cilova_mlhovina = 0
	get_tree().call_group('hrac', 'navratit_na_zacatek')
	get_tree().call_group('zbozi', 'objevit', true)
	get_tree().call_group('strely', 'detonace')
	_navigovat_dale()
	await get_tree().create_timer(3).timeout
	Signaly.zacatek_hry.emit()
	
