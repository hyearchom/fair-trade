extends Area3D

func _on_body_entered(body):
	print(body)
	queue_free()
