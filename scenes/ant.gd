extends CharacterBody2D

var speed = 10000  # Vitesse du personnage en pixels par seconde
var carried_object = null

func _ready() -> void:
	rotation = _get_new_rotation()
	

func _physics_process(delta: float) -> void:	
	move_ahead(delta)

func move_ahead(delta) -> void:	
	var direction = Vector2(cos(rotation - PI/2), sin(rotation - PI/2))

	velocity = direction * speed * delta
		
	move_and_slide()	

	if is_on_wall():
		rotation += PI

func _get_new_rotation() -> float:
	var rng := RandomNumberGenerator.new()
	return rng.randf_range(-PI, PI)
	
func _pick_square(body: Node2D) -> void:
	body.get_parent().remove_child(body)
	body.position = Vector2.ZERO
	add_child(body)


func _on_timer_timeout() -> void:
	
	var rng := RandomNumberGenerator.new()
	
	if rng.randi_range(0,9) >= 7:
		rotation = _get_new_rotation()
				

		
func _on_square_body_entered_signal(emitter: Node2D) -> void:	
	# emitter.get_groups()[1] permet de savoir si le groupe est Red ou Blue
	# le [0] est le groupe Squares
	#print("Signal received from ", emitter.get_groups()[1])
	#print("Position is ", emitter.position)
	#_pick_square(emitter)
	pass



func get_size() -> Vector2:
	return $Sprite2D.texture.get_size() * $Sprite2D.scale

func get_width() -> int:
	return get_size()[0]

func get_height() -> int:
	return get_size()[1]
