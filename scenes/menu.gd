extends Control

@export var nb_ants = 100
@export var nb_red_squares = 300
@export var nb_blue_squares = 300

var nb_ants_label = null
var nb_ants_slider = null
var nb_blue_squares_label = null
var nb_blue_squares_slider = null
var nb_red_squares_label = null
var nb_red_squares_slider = null

var nb_ants_default_value = nb_ants
var nb_red_squares_default_value = nb_red_squares
var nb_blue_squares_default_value = nb_blue_squares

signal set_environment

func get_nb_ants() -> int: 
	return nb_ants

func get_nb_blue_squares() -> int:
	return nb_blue_squares

func get_nb_red_squares() -> int:
	return nb_red_squares


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_default_values()

func set_default_values() -> void:
	nb_ants_label = get_node("Panel/MarginContainer/VBoxContainer/GridContainer/AntSlider/NbAntsLabel")
	nb_ants_label.text = str(nb_ants_default_value)
	nb_ants_slider = get_node("Panel/MarginContainer/VBoxContainer/GridContainer/AntSlider")
	nb_ants_slider.value = nb_ants_default_value
	
	nb_red_squares_label = get_node("Panel/MarginContainer/VBoxContainer/GridContainer/RedSquareSlider/NbRedSquaresLabel")
	nb_red_squares_label.text = str(nb_red_squares_default_value)
	nb_red_squares_slider = get_node("Panel/MarginContainer/VBoxContainer/GridContainer/RedSquareSlider")
	nb_red_squares_slider.value = nb_red_squares_default_value

	nb_blue_squares_label = get_node("Panel/MarginContainer/VBoxContainer/GridContainer/BlueSquareSlider/NbBlueSquaresLabel")
	nb_blue_squares_label.text = str(nb_blue_squares_default_value)
	nb_blue_squares_slider = get_node("Panel/MarginContainer/VBoxContainer/GridContainer/BlueSquareSlider")
	nb_blue_squares_slider.value = nb_blue_squares_default_value

func _on_ant_slider_value_changed(value: float) -> void:
	nb_ants_label.text = str(value)
	nb_ants = value

func _on_red_square_slider_value_changed(value: float) -> void:
	nb_red_squares_label.text = str(value)
	nb_red_squares = value

func _on_blue_square_slider_value_changed(value: float) -> void:
	nb_blue_squares_label.text = str(value)
	nb_blue_squares = value

func _on_default_button_pressed() -> void:
	set_default_values()

func _on_fill_button_pressed() -> void:
	emit_signal("set_environment")
