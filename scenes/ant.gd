extends CharacterBody2D


var speed = 200  # Vitesse du personnage en pixels par seconde
var carried_object = null


func _physics_process(delta: float) -> void:

	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()  # Normalise le vecteur pour une vitesse constante

	# Définir la vélocité du personnage
	velocity = input_vector * speed

	# Déplacer le personnage en gérant les collisions
	move_and_slide()
	
	
func _pick_square(body: Node2D) -> void:
	body.get_parent().remove_child(body)
	body.position = Vector2.ZERO
	add_child(body)


func _on_square_body_entered_signal(emitter: Node2D) -> void:
	print("Signal received from ", emitter)
	_pick_square(emitter)
