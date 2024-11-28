extends Object

class_name RandomNumber

var rng := RandomNumberGenerator.new()

func get_randi_range(from:int, to:int) -> int:
	return rng.randi_range(from, to)
	
func get_randf_range(from:float, to:float) -> float:
	return rng.randf_range(from, to)
