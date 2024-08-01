extends CharacterBody3D

const MAX_VYKON = 0.15

func _ready() -> void:
	add_to_group('strely')
	_odkryt_strelu(true)
	$Rozlet.start()

func _physics_process(_delta: float) -> void:
	var smer := transform.basis.z
	
	if $Rozlet.is_stopped():
		var cil := _najit_hrace()
		smer = global_position.direction_to(cil)
		look_at(cil)
	
	var srazka := move_and_collide(smer *MAX_VYKON)

	if srazka:
		detonace()
		if srazka.get_collider().is_in_group('hrac'):
			Signaly.konec_hry.emit()


func _najit_hrace() -> Vector3:
	var hrac := get_tree().get_first_node_in_group('hrac')
	return hrac.global_position


func _zhmotneni() -> void:
	$Plast.disabled = false


func detonace() -> void:
	Signaly.strela_znicena.emit()
	_odkryt_strelu(false)
	for efekt: GPUParticles3D in $Exploze.get_children():
		efekt.emitting = true
	await $Exploze/Kour.finished
	queue_free()


func _odkryt_strelu(stav:bool) -> void:
	for vizual: Node3D in [$Strela, $Zare, $Kour]:
		vizual.visible = stav
