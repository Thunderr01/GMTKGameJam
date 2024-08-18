extends Node
class_name StageManager

var _stages: Array
var _next_stage: int = 0

var _free_connection_points: Array
var _servers: Array
var _connections: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_stages = get_children()
	#_free_connection_points = get_
	pass # Replace with function body.


func _pick_connection_point(connection_points):
	while true:
		var connection_point = connection_points.pick_random()
		# No points left
		if connection_point == null:
			return null
		connection_points.erase(connection_point)
		# found a free point
		if connection_point.connection_state == ConnectionPoint.ConnectionState.FREE:
			return connection_point

## This function starts the next stage
## @return: True if a new stage is started, false otherwise if ther are no stages left
func next_level() -> bool :
	# return if there are no stages left
	if _next_stage >= _stages.size():
		return false
	
	_stages[_next_stage].start_stage()
	_next_stage += 1
	return true


# this function register a server, saving it for later use for other
# events who need them
func register_server(server: Server):
	# get connection points
	for node in server.get_children():
		if node.is_class("ConnectionPoint"):
			_free_connection_points.append(node)
	_servers.append(server)

## This function return an array containing two points which can connect
func get_server_connection() -> Array:
		var connection1 = _pick_connection_point(_free_connection_points)
		var connection2 = _pick_connection_point(_free_connection_points)
		_connections.append([connection1, connection2])
		return [connection1, connection2]
