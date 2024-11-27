extends Area2D

signal body_entered_signal(emitter)

func _on_body_entered(body: Node2D) -> void:	
	emit_signal("body_entered_signal", self)
	
	
	
func get_size() -> Vector2:
	return $Sprite2D.texture.get_size() * $Sprite2D.scale

func get_width() -> int:
	return get_size()[0]

func get_height() -> int:
	return get_size()[1]
