extends Panel

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Signaly.epilog.connect(zobrazit_vitezstvi)
	hide()
	#zobrazit_vitezstvi()

func zobrazit_vitezstvi() -> void:
	var sirka := get_viewport_rect().size.x/2
	#get_tree().paused = true
	await get_tree().create_timer(4).timeout
	show()
	umistit_na_stred($NaStred/Konfety, sirka)
	nastavit_spawn(sirka)

func umistit_na_stred(prvek:Node2D, sirka:float) -> void:
	prvek.position = Vector2(sirka, 0)

func nastavit_spawn(sirka:float) -> void:
	$NaStred/Konfety.process_material.emission_box_extents.x = sirka
