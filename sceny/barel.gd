extends StaticBody3D

func objevit(stav:bool) -> void:
	visible = stav
	$Plast.disabled = not stav
	if stav:
		add_to_group('zbozi')