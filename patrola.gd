extends PathFollow3D

const RYCHLOST := 0.025

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	progress_ratio += RYCHLOST *delta
