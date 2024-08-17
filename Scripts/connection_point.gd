extends Node2D
class_name ConnectionPoint

enum ConnectionState {
	FREE,
	HANGING,
	CONNECTED_END,
	CONNECTED_START
}

const CABLE = preload("res://Scenes/cable.tscn")

var connection_state = ConnectionState.FREE

var _rope: Cable
var _rope_handle: RopeHandle
var _other_connection_point: ConnectionPoint

## Adds a new RopeHandle child which handles the rope `rope_path`
## @param rope_path: NodePath to the rope to connect to
func _add_cable_handle(rope_path: NodePath):
	# don't add a second rope
	if _rope_handle:
		return
	
	# create rope and init its properties
	_rope_handle = RopeHandle.new()
	_rope_handle.strength = 1.0
	_rope_handle.rope_position = 1.0
	_rope_handle.rope_path = rope_path
	add_child(_rope_handle)
	
## Removes the rope handle from the scene
func _remove_cable_handle():
	# dont delete if already deleted
	if _rope_handle == null:
		return
	remove_child(_rope_handle)
	_rope_handle = null
	
## Adds rope to the scene
func _add_rope():
	# dont add a second rope
	if _rope:
		return
	_rope = CABLE.instantiate()
	_rope.z_index = 10
	_rope.break_cable_signal.connect(_break_cable_handler)
	add_child(_rope)

## Removes rope from the scene
func _remove_rope():
	# dont remove a rope if there is no one
	if _rope == null:
		return
	remove_child(_rope)
	_rope = null

func _break_cable_handler():
	set_as_broken()
	_other_connection_point.set_as_broken()
	pass

## This function handle the interaction with the connection point, it will change its state and
## returns the new state
## @param other_connection: not null if this interaction is connection start point to end point
func interact(other_connection: ConnectionPoint) -> ConnectionState:
	match connection_state:
		ConnectionState.FREE:
			# there is an other connection, which means this one is connected to
			if other_connection != null:
				_other_connection_point = other_connection
				_other_connection_point.set_end_connection(self)
				_add_cable_handle(_other_connection_point.get_rope_path())
				connection_state = ConnectionState.CONNECTED_END
			# There aren't an other connection, which means this is the connecting
			else:
				_add_rope()
				connection_state = ConnectionState.HANGING
		ConnectionState.HANGING:
			_remove_rope()
			connection_state = ConnectionState.FREE
		ConnectionState.CONNECTED_END:
			_remove_cable_handle()
			_other_connection_point.set_as_hanging()
			connection_state = ConnectionState.FREE
		ConnectionState.CONNECTED_START:
			_remove_rope()
			_other_connection_point.set_as_hanging()
			connection_state = ConnectionState.FREE
	return connection_state

func get_rope_path() -> NodePath:
	return _rope.get_node("Rope").get_path()
	
func set_as_hanging():
	if connection_state == ConnectionState.CONNECTED_END:
		_remove_cable_handle()
		_add_rope()
		
	_rope.cable_hanging()
	connection_state = ConnectionState.HANGING
	$Disconnect.play()
	
func set_end_connection(end: ConnectionPoint):
	_other_connection_point = end
	_rope.cable_connected()
	connection_state = ConnectionState.CONNECTED_START
	$Connect.play()

# This functions sets as broken, basically setting it to FREE state
func set_as_broken():
	if connection_state == ConnectionState.CONNECTED_END:
		_remove_cable_handle()
	if connection_state == ConnectionState.CONNECTED_START:
		_remove_rope()
	connection_state = ConnectionState.FREE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func detect():
	$Sprite2D.modulate = Color.hex(0xff0000ff)
	
func undetect():
	$Sprite2D.modulate = Color.hex(0x00ff00ff)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
