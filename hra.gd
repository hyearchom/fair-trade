extends Node

@export var pozadavek_zbozi: int = 5
var zbozi: int = 0
var cilova_mlhovina: int = 0


func _ready() -> void:
	Signaly.zbozi_ziskano.connect(func() -> void: zbozi += 1)
	Signaly.zbozi_ziskano.connect(_postup_hrou)
	_navigovat_dale()
	#Signaly.opusteni_mlhoviny.connect(_postup_hrou)


func _postup_hrou() -> void:
	cilova_mlhovina += 1
	_navigovat_dale()


func _navigovat_dale() -> void:
	get_tree().call_group('mlhoviny', '_spustit_navigaci', cilova_mlhovina)
