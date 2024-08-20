extends Node
class_name ServerConnectionEvent

var _running: bool = false
var colors: Array[Color] = [Color.GREEN, Color.BLUE, Color.GREEN_YELLOW, Color.YELLOW, Color.SKY_BLUE, Color.CORNFLOWER_BLUE, Color.DARK_VIOLET, Color.MEDIUM_ORCHID]

const INCREMENT = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_event():
	print("STARTING THE EVENT")
	var connection_points = get_tree().get_nodes_in_group("connection_point")
	var possible_points = []
	# pick two connection points that are free
	# TODO: if two server_connection_event run at the same time, they might pick 
	# 		similar connection point thus we need to change the way we pick two points
	
	for connection_point in connection_points:
		if connection_point.has_no_pair():
			possible_points.append(connection_point)
	
	if possible_points.size() < 2:
		return
	
	var _connection_point1 = possible_points.pick_random()
	possible_points.erase(_connection_point1)
	
	var _connection_point2 = possible_points.pick_random()
	
	var pair_color = colors.pick_random()
	_connection_point1.blink(pair_color)
	_connection_point2.blink(pair_color)
	_running = true
