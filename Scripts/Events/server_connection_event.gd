extends Node
class_name ServerConnectionEvent

var _connection: Array
var _running: bool = false
var _added_increment = false

const INCREMENT = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# event not running -> dont need to check
	if not _running:
		return
	# shit is good, need to give + score
	if _connection[0].is_connected_to(_connection[1]):
		if not _added_increment:
			get_tree().root.get_child(0).get_node("SubscriptionCounter").add_increment(INCREMENT)
			_added_increment = true
		pass
	elif _added_increment:
		get_tree().root.get_node("SubscriptionCounter").add_increment(-INCREMENT)
		_added_increment = false
	pass

func start_event():
	_connection = get_tree().root.get_node("StageManager").get_server_connection

	# shit is fucked
	if _connection[2] == null or _connection[1] == null:
		return	
	_connection[1].blink(Color.DARK_MAGENTA)
	_connection[2].blink(Color.DARK_MAGENTA)
	_running = true	
	pass
