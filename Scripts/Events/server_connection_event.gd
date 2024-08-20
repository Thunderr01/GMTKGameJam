extends Node
class_name ServerConnectionEvent

var _connection_point1: ConnectionPoint
var _connection_point2: ConnectionPoint
var _running: bool = false
var _rng = RandomNumberGenerator.new()

const INCREMENT = 2

func _pick_connection_point(connection_points):
	while true:
		var connection_point = connection_points.pick_random()
		# No points left
		if connection_point == null:
			return null
		connection_points.erase(_connection_point1)
		# found a free point
		if connection_point.connection_state == ConnectionPoint.ConnectionState.FREE:
			return connection_point

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_event():
	print("STRTING THE EVENT")
	var connection_points = get_tree().get_nodes_in_group("connection_point")
	# pick two connection points that are free
	# TODO: if two server_connection_event run at the same time, they might pick 
	# 		similar connection point thus we need to change the way we pick two points
	_connection_point1 = _pick_connection_point(connection_points)
	_connection_point2 = _pick_connection_point(connection_points)

	# shit is fucked
	if _connection_point1 == null or _connection_point2 == null:
		return
	
	var hue = lerp(0.2, 0.8, _rng.randf()) # pick a non-red hue
	var pair_color = Color.from_hsv(hue, 0.8, 0.8)
	_connection_point1.blink(pair_color)
	_connection_point2.blink(pair_color)
	_running = true	
	pass
