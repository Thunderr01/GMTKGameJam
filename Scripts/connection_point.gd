extends Node2D
class_name ConnectionPoint

enum ConnectionState {
	FREE,
	HANGING,
	CONNECTED_END,
	CONNECTED_START
}

signal notify_player

var connection_state =ConnectionState.FREE

var _rope: Rope
var _rope_handle: RopeHandle
var _other_connection_point: ConnectionPoint

"""
@brief: This function handle the interaction with the connection point, it will change its state and
		returns the new state
"""
func interact(other_connection: ConnectionPoint) -> ConnectionState:
	print(connection_state)
	match connection_state:
		ConnectionState.FREE:
			# there is an other connection, which means this one is connected to
			if other_connection != null:
				_other_connection_point = other_connection
				_other_connection_point.set_end_connection(self)
				_rope_handle.rope_path = _other_connection_point.get_rope_path()
				add_child(_rope_handle)
				print(get_children())
				print("WHY DIDNT ADD CHILD WORK", _rope_handle.rope_path)
				connection_state = ConnectionState.CONNECTED_END
			# There aren't an other connection, which means this is the connecting
			else:
				add_child(_rope)
				connection_state = ConnectionState.HANGING
		ConnectionState.HANGING:
			remove_child(_rope)
			connection_state = ConnectionState.FREE
		ConnectionState.CONNECTED_END:
			remove_child(_rope_handle)
			_rope_handle.rope_path = NodePath()
			_other_connection_point.set_as_hanging()
			connection_state = ConnectionState.FREE
		ConnectionState.CONNECTED_START:
			remove_child(_rope)
			_other_connection_point.set_as_hanging()
			connection_state = ConnectionState.FREE
	print(connection_state)
	return connection_state


func get_rope_path() -> NodePath:
	return _rope.get_path()
	
func set_as_hanging():
	if connection_state == ConnectionState.CONNECTED_END:
		remove_child(_rope_handle)
		_rope_handle.rope_path = NodePath()
		add_child(_rope)
	connection_state = ConnectionState.HANGING
	
func set_end_connection(end: ConnectionPoint):
	_other_connection_point = end
	connection_state = ConnectionState.CONNECTED_START

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_nodes_in_group("player")
	
	# connect player to 
	for i in player:
		notify_player.connect(i.connection_point_visible)
	pass # Replace with function body.
	
	# initialize rope and rope_handle
	_rope = Rope.new()
	_rope_handle = RopeHandle.new()
	_rope_handle.strength = 1.0


func detect():
	$Sprite2D.modulate = Color.hex(0xff0000ff)
	
func undetect():
	$Sprite2D.modulate = Color.hex(0x00ff00ff)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
