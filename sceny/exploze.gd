extends Node3D

func _ready() -> void:
	for efekt: GPUParticles3D in get_children():
		efekt.emitting = true
