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
	WAITING_FOR_CONNECTION,
	CORRECT_CONNECTION,
	WRONG_CONNECTION
}

const CABLE = preload("res://Scenes/cable.tscn")
const SCORE_BADGE = preload("res://Scenes/score_badge.tscn")
const NO_PAIR_COLOR = Color.BLACK;

@export var blink_interval = 0.2
@export var wrong_pair_color = Color.RED

var connection_state = ConnectionState.FREE
var connection_success_state = ConnectionSuccessState.IDLE

var _rope: Cable
var _rope_handle: RopeHandle
var _other_connection_point: ConnectionPoint
var _default_color: Color
var _light_off_color: Color
var _blink_tween: Tween

var pair_color: Color = NO_PAIR_COLOR


func _ready():
	_default_color = $ConnectionCloseSprite.modulate
	_light_off_color = $Light.modulate
	$ScoreBadgeTimer.timeout.connect(_create_score_badge)


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
			set_connection_success_state(ConnectionSuccessState.WAITING_FOR_CONNECTION)
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
		set_cable_color(pair_color)
		stop_blink(pair_color)
		_start_creating_score()
	elif connection_success_state == ConnectionSuccessState.WRONG_CONNECTION:
		set_cable_color(wrong_pair_color)
		_start_creating_score()
	else:
		set_cable_color(_default_color)
		_stop_creating_score()
		if pair_color == NO_PAIR_COLOR:
			stop_blink(_default_color)
		else:
			blink(pair_color)

func set_cable_color(new_color: Color):
	$ConnectionCloseSprite.modulate = new_color
	if _rope:
		_rope.get_node("Rope").color = new_color

func blink(color: Color):
	pair_color = color
	connection_success_state = ConnectionSuccessState.WAITING_FOR_CONNECTION
	stop_blink(pair_color)
	_blink_tween = get_tree().create_tween()
	_blink_tween.tween_property($Light, "modulate", pair_color, 0.05)
	_blink_tween.chain().tween_interval(blink_interval)
	_blink_tween.chain().tween_property($Light, "modulate", _default_color, 0.05)
	_blink_tween.chain().tween_interval(blink_interval)
	_blink_tween.set_loops()

func stop_blink(new_light_color: Color):
	$Light.modulate = new_light_color
	if _blink_tween:
		_blink_tween.kill()

func unblink():
	pair_color = Color.BLACK
	stop_blink(_light_off_color)

func is_connected_to(connection: ConnectionPoint):
	return _other_connection_point == connection
	
func has_correct_connection():
	return connection_success_state == ConnectionSuccessState.CORRECT_CONNECTION

func has_wrong_connection():
	return connection_success_state == ConnectionSuccessState.WRONG_CONNECTION

func is_waiting_for_connection():
	return connection_success_state == ConnectionSuccessState.WAITING_FOR_CONNECTION

func _start_creating_score():
	$ScoreBadgeTimer.start()

func _stop_creating_score():
	$ScoreBadgeTimer.stop()

func _create_score_badge():
	var new_score_badge = SCORE_BADGE.instantiate()
	get_parent().add_child(new_score_badge)
	new_score_badge.position = position
	if connection_success_state == ConnectionSuccessState.WRONG_CONNECTION:
		new_score_badge.set_badge_to_minus_user()
	else:
		new_score_badge.set_badge_to_plus_user()
