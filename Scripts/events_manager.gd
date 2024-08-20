extends Node
class_name StageManager

var _stages: Array
var _stage_index: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_stages = get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func is_stage_running():
	if _stage_index < 0 or _stage_index >= _stages.size():
		return false
	return _stages[_stage_index].is_running


## This function starts the next stage
## @return: True if a new stage is started, false otherwise if ther are no stages left
func next_level() -> bool :
	_stage_index += 1
	
	# return if there are no stages left
	if _stage_index >= _stages.size():
		return false
	
	_stages[_stage_index].start_stage()
	return true
