extends Node
class_name StageManager

var _stages: Array
var _next_stage: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_stages = get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## This function starts the next stage
## @return: True if a new stage is started, false otherwise if ther are no stages left
func next_level() -> bool :
	# return if there are no stages left
	if _next_stage >= _stages.size():
		return false
	
	_stages[_next_stage].start_stage()
	_next_stage += 1
	return true
