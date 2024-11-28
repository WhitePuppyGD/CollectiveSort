extends Node2D

@export var nb_red_squares = 10
@export var nb_blue_squares = 10
@export var nb_ants = 5


var rng = null
var memory = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var square_red_scene = preload("res://scenes/square_red.tscn")
	var square_blue_scene = preload("res://scenes/square_blue.tscn")
	var ant_scene = preload("res://scenes/ant.tscn")
	
	rng = RandomNumber.new()

	_create_squares(square_red_scene, nb_red_squares)
	_create_squares(square_blue_scene, nb_blue_squares)

	_create_ants(ant_scene, nb_ants)

	_connect_signal_between_squares_and_ants()
	

func _create_ants(ant_scene: PackedScene, nb_ants: int):	
	
	var field_size = get_viewport_rect().size
	
	for i in nb_ants:
	
		var ant = ant_scene.instantiate()
	
		var random_x = rng.get_randi_range(0 + ant.get_width(), field_size[0] - ant.get_width())
		var random_y = rng.get_randi_range(0 + ant.get_height(), field_size[1] - ant.get_height())
	
		ant.position = Vector2(random_x, random_y)

		add_child(ant)

func _create_squares(square_scene: PackedScene, nb_squares: int) -> void:

	var field_size = get_viewport_rect().size

	for i in nb_squares:
		var square = square_scene.instantiate()

		var random_x = rng.get_randi_range(0 + square.get_width(), field_size[0] - square.get_width() - 30)
		var random_y = rng.get_randi_range(0 + square.get_height(), field_size[1] - square.get_height() -30)

		square.position = Vector2(random_x, random_y)

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
