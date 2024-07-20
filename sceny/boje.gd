extends Area3D

func _on_body_entered(body) -> void:
	print(body)
	queue_free()
