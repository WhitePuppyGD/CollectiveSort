extends Object

class_name Memory

var _memory: Array = []
var _max_size: int

# Constructeur
func _init(max_size: int = 10):
	_max_size = max_size
	

func add(item) -> void:
	_memory.append(item)
	
	if _memory.size() > _max_size:
		_memory.pop_front()

func get_size() -> int:
	return _max_size

func count_items_of_type(item_type:String) -> int:
	var cnt = 0
	
	for item in _memory:
		if item == item_type:
			cnt += 1	
	return cnt

func flush() -> void:
	for i in _memory.size():
		_memory[i] = null

func print() -> void:
	for i in _memory.size():
		print(i, "->", _memory[i])
	print("---")
