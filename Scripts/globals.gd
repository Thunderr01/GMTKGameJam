extends Node

var subs_count: int = 0
var subs_increment: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not $"../Servers":
		return
	subs_increment = $"../Servers".get_connections_score()
	$UsersPerSecond.text = str(subs_increment * 2) + "/s"

# adds an increment, could be negative if we want to reduce it
func add_increment(increment: int):
	pass
	#subs_increment += increment


func _on_timer_timeout() -> void:
	subs_count += subs_increment
	if subs_count < 0:
		subs_count = 0
	$Score.text = str(subs_count)
