extends Node

@export var barvy: Array[Color]

func _ready() -> void:
	for barva in barvy:
		var policko = ColorRect.new()
		policko.custom_minimum_size = Vector2(100,100)
		policko.color = barva
		$Tabulka.add_child(policko)
