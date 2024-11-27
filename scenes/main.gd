extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var square_scene = preload("res://scenes/square.tscn")
	var ant_scene = preload("res://scenes/ant.tscn")
		
	_create_squares(square_scene)
	_create_ants(ant_scene)

	_connect_signal_between_squares_and_ants()
	

func _create_ants(ant_scene: PackedScene):	
	
	var rng := RandomNumberGenerator.new()
	var field_size = get_viewport_rect().size
	
	var random_x = rng.randi_range(0, field_size[0])
	var random_y = rng.randi_range(0, field_size[1])
	
	var ant = ant_scene.instantiate()
	
	ant.position = Vector2(random_x, random_y)	

	ant.add_to_group("Ants")

	#ant.rotation = rng.randf_range(-1, 1)

	add_child(ant)

func _create_squares(square_scene: PackedScene):

	var rng = RandomNumberGenerator.new()
	var field_size = get_viewport_rect().size

	for i in 3:
		var random_x = rng.randi_range(0, field_size[0])
		var random_y = rng.randi_range(0, field_size[1])

		var square = square_scene.instantiate()

		square.position = Vector2(random_x, random_y)
		square.scale = Vector2(3,3)

		square.add_to_group("Squares")

		add_child(square)


# Lorsque l'Ant entre en collision avec le Square
# Le Square envoie un signal à la Ant, puis c'est l'Ant qui gère ses décisions
# Cette fonction connecte le signal émis par le Square et reçu par l'Ant
func _connect_signal_between_squares_and_ants() -> void:
	var ants = get_tree().get_nodes_in_group("Ants")
	var squares = get_tree().get_nodes_in_group("Squares")
	
	for ant in ants:
		for square in squares:
			square.connect("body_entered_signal", Callable(ant, "_on_square_body_entered_signal"))	
