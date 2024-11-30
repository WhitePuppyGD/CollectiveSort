extends Area2D


func _on_body_entered(body: Node2D) -> void:	
	#print("Collision avec : ", body)

	if body.is_in_group("Ants"):
		body.next_move(self)

	
func get_size() -> Vector2:
	return $Sprite2D.texture.get_size() * $Sprite2D.scale

func get_width() -> int:
	return get_size()[0]

func get_height() -> int:
	return get_size()[1]
