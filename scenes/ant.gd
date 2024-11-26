extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass	
#	var v = Vector2(
#		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
#		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"),
#	)
#		
#	position += v


var speed = 200  # Vitesse du personnage en pixels par seconde
var carried_object = null


func _physics_process(delta: float) -> void:

	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()  # Normalise le vecteur pour une vitesse constante

	# Définir la vélocité du personnage
	velocity = input_vector * speed

	if carried_object:
		carried_object.position = position

# Déplacer le personnage et détecter les collisions
#	var collision = move_and_collide(velocity * delta)

#	if collision:
#		var collider = collision.get_collider()
#		print("Collision avec :", collider.name)



	# Déplacer le personnage en gérant les collisions
	move_and_slide()
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	
	#print("Collision avec : {} @ {},{}".format(area.name, area.position.x, area.position.y))
	print("Collision avec : %s %s" % [area.name, area.position])

	#On peut agir sur les paramètres du Square rencontré
	area.position = position
	


func _on_area_2d_body_entered(body: Node2D) -> void:

	print("Collision", body)	
	body.position = position
	carried_object = body
	
	pass # Replace with function body.
