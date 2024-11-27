extends Area2D

signal body_entered_signal(emitter)
	
func _on_body_entered(body: Node2D) -> void:
	
	emit_signal("body_entered_signal", self)
