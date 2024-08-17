extends Node2D
class_name ConnectionHandler

var _rope: Rope
var _rope_handle: RopeHandle
var _temp_handler: RopeHandle

var _current_connection_point: ConnectionPoint

var _connection_point_start: ConnectionPoint

func handle(connection: ConnectionPoint):
	if connection.connection_state == ConnectionPoint.ConnectionState.FREE:
		add_point(connection)
	# remove self hanging
	elif _connection_point_start == connection and connection.connection_state == connection.ConnectionState.HANGING:
		_connection_point_start.interact(null)
		_connection_point_start = null
	elif _connection_point_start == null:
		connection.interact(null)
		_connection_point_start = connection._other_connection_point
		get_parent().get_node("RopeHandle").rope_path = _connection_point_start.get_rope_path()

func add_point(connection_point: ConnectionPoint):
	if not _connection_point_start:
		_connection_point_start = connection_point
		_connection_point_start.interact(null)
		get_parent().get_node("RopeHandle").rope_path = _connection_point_start.get_rope_path()
	else:
		connection_point.interact(_connection_point_start)
		get_parent().get_node("RopeHandle").rope_path = NodePath()
		_connection_point_start = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if  _current_connection_point and Input.is_action_just_pressed("GetConnection"):
		handle(_current_connection_point)
	if _connection_point_start and Input.is_action_just_pressed("DropCable"):
		handle(_connection_point_start)
	
	
func _on_area_detect_connection_body_entered(body: Node2D) -> void:
	_current_connection_point = body
	print(body.get_class())
	
func _on_area_detect_connection_body_exited(body: Node2D) -> void:
	if _current_connection_point == body:
		_current_connection_point = null
