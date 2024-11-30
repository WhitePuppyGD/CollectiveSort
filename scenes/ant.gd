extends CharacterBody2D


var speed = 200000  # Vitesse du personnage en pixels par seconde
var carried_object = null
var carried_object_type = null
var rng = null
var memory = null
var memory_size = 20


func _ready() -> void:
	
	rng = RandomNumber.new()
	memory = Memory.new(memory_size)
	carried_object = null

	rotation = _get_new_rotation()

func _physics_process(delta: float) -> void:

	move_ahead(delta)
	
	return
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()  # Normalise le vecteur pour une vitesse constante

	velocity = input_vector * speed

	move_and_slide()  

	#move_ahead(delta)

func move_ahead(delta) -> void:
	var direction = Vector2(cos(rotation - PI/2), sin(rotation - PI/2))

	velocity = direction * speed * delta

	move_and_slide()

	if is_on_wall():
		rotation += PI


func _get_new_rotation() -> float:
	return rng.get_randf_range(-PI, PI)
	
func __pick_square(square: Node2D) -> void:

	if carried_object:
		return

	square.get_parent().call_deferred("remove_child", square)
	square.position = Vector2.ZERO
	call_deferred("add_child", square)
	square.get_node("CollisionShape2D").call_deferred("set_disabled", true)

	carried_object_type = square.get_groups()[1]
	carried_object = square

func _pick_square(square: Node2D) -> void:

	if carried_object:
		return

	carried_object_type = square.get_groups()[1]
	carried_object = square

	# Appeler la fonction différée
	call_deferred("_deferred_pick_square", square)

func _deferred_pick_square(square: Node2D) -> void:
	if not is_instance_valid(square):
		print("Erreur : 'square' n'est plus une instance valide.")
		return

	var parent = square.get_parent()
	if parent != null:
		parent.remove_child(square)
	else:
		print("Erreur : 'square' n'a pas de parent.")

	add_child(square)
	square.position = Vector2.ZERO

	var collision_shape = square.get_node("CollisionShape2D")
	if collision_shape:
		collision_shape.set_disabled(true)
	else:
		print("Erreur : 'CollisionShape2D' introuvable dans 'square'.")


func _drop_square() -> void:
	print("drop : ", carried_object)
	if carried_object != null and is_instance_valid(carried_object):
		call_deferred("_deferred_drop_square")
	else:
		print("Erreur : 'carried_object' est nul ou invalide.")

func _deferred_drop_square() -> void:
	print("defered : ", carried_object)

	carried_object.position = position

	if carried_object.has_node("CollisionShape2D"):
		carried_object.get_node("CollisionShape2D").set_disabled(false)
	else:
		print("Erreur : 'carried_object' n'a pas de nœud 'CollisionShape2D'.")

	remove_child(carried_object)

	var parent = get_parent()
	if parent != null:
		parent.add_child(carried_object)
	else:
		print("Erreur : le nœud courant n'a pas de parent.")

	carried_object = null
	carried_object_type = null


func __drop_square() -> void:
	
	return
	#carried_object.collision_layer = 1
	#carried_object = null

	#print("Drop !")	
	carried_object.position = position
	carried_object.get_node("CollisionShape2D").call_deferred("set_disabled", false)
	call_deferred("remove_child", carried_object)
	get_parent().call_deferred("add_child", carried_object)
	#memory.flush()
	carried_object = null
	carried_object_type = null


func _decide_action(object_ant_is_on: Node2D, object_ant_is_on_type: String) -> void:

	# Combien d'objets du type sur lequel est la fourmi sont dans sa mémoire
	#var count_items_types = memory.count_items_of_type(object_ant_is_on_type)

	# Si la fourmi transporte un objet, 
	# Plus il y a d'objets dans sa mémoire du même type que l'objet transporté, 
	# Plus elle a de chance de le déposer
	if carried_object:
		var carried_object_type = carried_object.get_groups()[1]
		var count_object_types = memory.count_items_of_type(carried_object_type)

		# Si elle a 8 objets de même type dans sa mémoire elle a 80% de drop
		#if rng.get_randi_range(0, 10) < count_object_types:
		if rng.get_randi_range(0, memory_size) < count_object_types:
			_drop_square()

	# Si la fourmi ne porte pas d'objet
	# Plus il y d'objet dans sa mémoire du même type que l'objet rencontré
	# Moins elle a de chance de la prendre
	else:
		var count_object_types = memory.count_items_of_type(object_ant_is_on_type)
		
		# Si elle a 8 objets de même type dans sa mémoire, elle a 20% de pick
		if rng.get_randi_range(0, memory_size) >= count_object_types:
			#print("Object :", object_ant_is_on_type, " in Memory :", count_object_types)
			_pick_square(object_ant_is_on)


func next_move(square: Node2D) -> void:

	#print("Decide next move from ", square, " with ", self)
	_decide_action(square, square.get_groups()[1])	
	memory.add(square.get_groups()[1])


func _on_timer_timeout() -> void:

	if rng.get_randi_range(0,9) >= 7:
		rotation = _get_new_rotation()

	#if carried_object:
	#	remove_child(carried_object)
		#get_parent().add_child(carried_object)
	#	memory.flush()
	#	carried_object = null


func get_size() -> Vector2:
	return $Sprite2D.texture.get_size() * $Sprite2D.scale

func get_width() -> int:
	return get_size()[0]

func get_height() -> int:
	return get_size()[1]
