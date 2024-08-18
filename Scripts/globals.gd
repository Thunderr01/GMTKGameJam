extends Node

var subs_count: int = 0
var subs_increment: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# adds an increment, could be negative if we want to reduce it
func add_increment(increment: int):
	subs_increment += increment


func _on_timer_timeout() -> void:
	subs_count += subs_increment
	$Score.text = str(subs_count)
	pass # Replace with function body.
