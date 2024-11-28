extends CharacterBody2D


var speed = 10000  # Vitesse du personnage en pixels par seconde
var carried_object = null
var carried_object_type = null
var rng = null
var memory = null
var memory_size = 10


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
			
	move_and_slide()

	if is_on_wall():
		rotation += PI

	#if carried_object:
	#	carried_object.position = position

func _get_new_rotation() -> float:
	return rng.get_randf_range(-PI, PI)
	
func _pick_square(body: Node2D) -> void:

	if carried_object:
		return

	body.get_parent().remove_child(body)
	body.position = Vector2.ZERO
	add_child(body)
	carried_object_type = body.get_groups()[1]
	carried_object = body

func _drop_square() -> void:
	
	return
	#carried_object.collision_layer = 1
	#carried_object = null
		
	#print("Drop !")	
	#carried_object.position = position
	remove_child(carried_object)
	get_parent().add_child(carried_object)
	memory.flush()
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
		#if rng.get_randi_range(0, 10) < count_object_types:
		if rng.get_randi_range(0, 5) > 3:		
			_drop_square()
		
	# Si la fourmi ne porte pas d'objet
	# Plus il y d'objet dans sa mémoire du même type que l'objet rencontré
	# Moins elle a de chance de la prendre
	else:
		var count_object_types = memory.count_items_of_type(object_ant_is_on_type)
		
		# Si elle a 8 objets de même type dans sa mémoire, elle a 20% de pick
		#if rng.get_randi_range(0, 10) > count_object_types:
		if rng.get_randi_range(0, 5) < 4:
			_pick_square(object_ant_is_on)



func _on_timer_timeout() -> void:
		
	if rng.get_randi_range(0,9) >= 7:
		rotation = _get_new_rotation()
		
	#if carried_object:
	#	remove_child(carried_object)
		#get_parent().add_child(carried_object)
	#	memory.flush()
	#	carried_object = null



func _on_square_body_entered_signal(emitter: Node2D) -> void:	
	# emitter.get_groups()[1] permet de savoir si le groupe est Red ou Blue
	# le [0] est le groupe Squares
	
	#print("Signal received from ", emitter.get_groups()[1])

	#memory.add(emitter.get_groups()[1])

	#_decide_action(emitter, emitter.get_groups()[1])

	#memory.print()
	
	# print("Position is ", emitter.position)
	_pick_square(emitter)
	pass



func get_size() -> Vector2:
	return $Sprite2D.texture.get_size() * $Sprite2D.scale

func get_width() -> int:
	return get_size()[0]

func get_height() -> int:
	return get_size()[1]
