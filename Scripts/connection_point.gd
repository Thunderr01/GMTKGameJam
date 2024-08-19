extends Node2D
class_name ConnectionPoint

enum ConnectionState {
	FREE,
	HANGING,
	CONNECTED_END,
	CONNECTED_START
}

enum ConnectionSuccessState {
	IDLE,
	WAITING_TO_CONNECT,
	CORRECT_CONNECTION,
	WRONG_CONNECTION
}

const CABLE = preload("res://Scenes/cable.tscn")
const NO_PAIR_COLOR = Color.BLACK;

@export var wrong_pair_color = Color.RED

var connection_state = ConnectionState.FREE
var connection_success_state = ConnectionSuccessState.IDLE

var _rope: Cable
var _rope_handle: RopeHandle
var _other_connection_point: ConnectionPoint
var _default_connection_color: Color
var _light_off_color: Color


var pair_color: Color = NO_PAIR_COLOR


func _ready():
	_default_connection_color = $ConnectionCloseSprite.modulate
	_light_off_color = $Light.modulate


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
	$Snap.play()

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
				set_connection_state(ConnectionState.CONNECTED_END)
				
				if pair_color != NO_PAIR_COLOR and pair_color == _other_connection_point.pair_color:
					set_connection_success_state(ConnectionSuccessState.CORRECT_CONNECTION)
					_other_connection_point.set_connection_success_state(ConnectionSuccessState.CORRECT_CONNECTION)
				else:
					set_connection_success_state(ConnectionSuccessState.WRONG_CONNECTION)
					_other_connection_point.set_connection_success_state(ConnectionSuccessState.WRONG_CONNECTION)
				
			# There aren't an other connection, which means this is the connecting
			else:
				_add_rope()
				set_connection_state(ConnectionState.HANGING)
		ConnectionState.HANGING:
			_remove_rope()
			set_connection_state(ConnectionState.FREE)
		ConnectionState.CONNECTED_END:
			_remove_cable_handle()
			_other_connection_point.set_as_hanging()
			set_connection_state(ConnectionState.FREE)
		ConnectionState.CONNECTED_START:
			_remove_rope()
			_other_connection_point.set_as_hanging()
			set_connection_state(ConnectionState.FREE)
	return connection_state

func get_rope_path() -> NodePath:
	return _rope.get_node("Rope").get_path()
	
func set_as_hanging():
	if connection_state == ConnectionState.CONNECTED_END:
		_remove_cable_handle()
		_add_rope()
		
	_rope.cable_hanging()
	set_connection_state(ConnectionState.HANGING)
	$Disconnect.play()
	
func set_end_connection(end: ConnectionPoint):
	_other_connection_point = end
	_rope.cable_connected()
	set_connection_state(ConnectionState.CONNECTED_START)
	$Connect.play()

# This functions sets as broken, basically setting it to FREE state
func set_as_broken():
	if connection_state == ConnectionState.CONNECTED_END:
		_remove_cable_handle()
	if connection_state == ConnectionState.CONNECTED_START:
		_remove_rope()
	set_connection_state(ConnectionState.FREE)

func set_connection_state(new_state: ConnectionState):
	connection_state = new_state
	var _not_paired_states = [ConnectionState.FREE, ConnectionState.HANGING]
	if connection_state in _not_paired_states:
		if pair_color == NO_PAIR_COLOR:
			set_connection_success_state(ConnectionSuccessState.IDLE)
		else:
			set_connection_success_state(ConnectionSuccessState.WAITING_TO_CONNECT)
	update_connection_sprite()

func update_connection_sprite():
	$ConnectionCloseSprite.visible = connection_state != ConnectionState.FREE

func highlight():
	$Outline.visible = true

func cancel_highlight():
	$Outline.visible = false

func set_connection_success_state(new_state: ConnectionSuccessState):
	connection_success_state = new_state
	
	if connection_success_state == ConnectionSuccessState.CORRECT_CONNECTION:
		$ConnectionCloseSprite.modulate = pair_color
	elif connection_success_state == ConnectionSuccessState.WRONG_CONNECTION:
		$ConnectionCloseSprite.modulate = wrong_pair_color
	else:
		$ConnectionCloseSprite.modulate = _default_connection_color

func blink(color: Color):
	pair_color = color
	$Light.modulate = color
	
func unblink():
	pair_color = Color.BLACK
	$Light.modulate = _light_off_color

func is_connected_to(connection: ConnectionPoint):
	return _other_connection_point == connection

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
