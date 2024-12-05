extends CharacterBody2D


var speed = 10000  # Vitesse du personnage en pixels par seconde
var carried_object = null
var rng = null
var memory = null
var memory_size = 16
var nb_of_steps = 0

func _ready() -> void:
	
	rng = RandomNumber.new()
	memory = Memory.new(memory_size)
	carried_object = null

	rotation = _get_new_rotation()


func _physics_process(delta: float) -> void:
	move_ahead(delta)

func move_ahead(delta) -> void:
	var direction = Vector2(cos(rotation - PI/2), sin(rotation - PI/2))

	velocity = direction * speed * delta
	
	nb_of_steps +=1

	# Si la fourmis n'a pas rencontré d'objet depuis qq pas,
	# Elle enregistre "Void" dans sa mémoire
	# Cela évite d'avoir une fourmis qui parcourt tout le terrain
	# Et se souvient d'un Square rencontré plusieurs centaines de pas avant
	if nb_of_steps % memory_size == 0:
		memory.add("Void")
	
	if carried_object:
		carried_object.position = position

	move_and_slide()

	if is_on_wall():
		rotation += PI


func _get_new_rotation() -> float:
	return rng.get_randf_range(-PI, PI)
	

func _pick_square(square: Node2D) -> void:

	# On enlève la détection une fois l'objet transporté
	# Call_deferred car la propriété d'un noeud doit être traité 
	# Une fois la gestion de la physique terminée
	square.get_node("CollisionShape2D").call_deferred("set_disabled", true)
	
	# Pour que l'objet apparaisse au dessus de la fourmis
	square.z_index = z_index + 1
	carried_object = square


func _drop_square() -> void:

	carried_object.get_node("CollisionShape2D").call_deferred("set_disabled", false)

	# Pour que l'objet déposé soit en dessous de la fourmis
	carried_object.z_index = z_index - 1
	carried_object.position = position
	carried_object = null

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
		if rng.get_randi_range(0, memory_size) < count_object_types:
			_drop_square()

	# Si la fourmi ne porte pas d'objet
	# Plus il y d'objet dans sa mémoire du même type que l'objet rencontré
	# Moins elle a de chance de la prendre
	else:
		var count_object_types = memory.count_items_of_type(object_ant_is_on_type)
		
		# Si elle a 8 objets de même type dans sa mémoire, elle a 20% de pick
		if rng.get_randi_range(0, memory_size) >= count_object_types:
			_pick_square(object_ant_is_on)


func next_move(square: Node2D) -> void:

	# Cette fonction est appelée après une collision
	# On remet le nb de pas à 0 après une collision
	# Car la fourmis a rencontré un objet
	nb_of_steps = 0
	_decide_action(square, square.get_groups()[1])	
	memory.add(square.get_groups()[1])


func _on_timer_timeout() -> void:
	if rng.get_randi_range(0,9) >= 7:
		rotation = _get_new_rotation()
