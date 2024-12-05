extends Node2D

var menu_scene = null

var rng = null
var memory = null

var square_red_scene = null
var square_blue_scene = null
var ant_scene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	square_red_scene = preload("res://scenes/square_red.tscn")
	square_blue_scene = preload("res://scenes/square_blue.tscn")
	ant_scene = preload("res://scenes/ant.tscn")

	rng = RandomNumber.new()
	
	menu_scene = get_node("MenuCanvas/MenuUI")
	
	# Connecte le signal déclaré dans le script attaché à MenuUI et qui appelle
	# la fonction _on_set_environment dans le script main.gd
	get_node("MenuCanvas/MenuUI").connect("set_environment", Callable(self, "_on_set_environment"))
	
	_set_environment()


# Ajoute les ants et les squares
# Efface tout avant
func _set_environment() -> void:
	_delete_group_instances("Squares")
	_delete_group_instances("Ants")
	
	_create_squares(square_red_scene, menu_scene.get_nb_red_squares())
	_create_squares(square_blue_scene, menu_scene.get_nb_blue_squares())

	_create_ants(ant_scene, menu_scene.get_nb_ants())

func _delete_group_instances(group_name: String) -> void:
	var nodes = get_tree().get_nodes_in_group(group_name)
	for node in nodes:
		node.queue_free()  # Marque le nœud pour suppression

func _on_set_environment() -> void:
	_set_environment()

# Ecoute les Input hors node Control
func _unhandled_input(event):	
	if Input.is_action_just_pressed("ui_mouse_left_click"):
		menu_scene.visible = not menu_scene.visible


func _process(delta: float) -> void:

	var camera = get_node("Camera")

	if Input.is_action_pressed("ui_down"):
		camera.zoom -= Vector2(0.01, 0.01)

	if Input.is_action_pressed("ui_up"):
		camera.zoom += Vector2(0.01, 0.01)

	if Input.is_action_pressed("ui_left"):
		camera.position -= Vector2(1, 0.0)

	if Input.is_action_pressed("ui_right"):
		camera.position -= Vector2(-1, 0.0)

	camera.zoom.x = clamp(camera.zoom.x, 0.8, 5.0)
	camera.zoom.y = clamp(camera.zoom.y, 0.8, 5.0)
	
	camera.position.x = clamp(camera.position.x, 100, 1000)
	

func _create_ants(antscene: PackedScene, nbants: int):
	
	var field_size = get_viewport_rect().size
	
	for i in nbants:
	
		var ant = antscene.instantiate()
		
		# Les fourmis apparaissent toutes au milieu de l'écran
		# ça fait un effet sympa je trouve
		ant.position = Vector2(field_size[0]/2, field_size[1]/2)

		get_node("Ants").add_child(ant)

func _create_squares(square_scene: PackedScene, nb_squares: int) -> void:

	var field_size = get_viewport_rect().size

	for i in nb_squares:
		var square = square_scene.instantiate()

		var random_x = rng.get_randi_range(0 + square.get_width(), field_size[0] - square.get_width() - 30)
		var random_y = rng.get_randi_range(0 + square.get_height(), field_size[1] - square.get_height() -30)

		square.position = Vector2(random_x, random_y)

		get_node("Squares").add_child(square)
