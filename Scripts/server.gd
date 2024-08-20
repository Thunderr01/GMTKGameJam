class_name Server

extends StaticBody2D

var connected_server: Server
@export var connection_points: Array[ConnectionPoint]


func _process(delta):
	pass
	
func get_correct_connections_amount() -> int:
	var correct_connections_amount: int = 0
	for connection_point in connection_points:
		if connection_point.has_correct_connection():
			correct_connections_amount += 1
	return correct_connections_amount
	
func get_wrong_connections_amount() -> int:
	var wrong_connections_amount: int = 0
	for connection_point in connection_points:
		if connection_point.has_wrong_connection():
			wrong_connections_amount += 1
	return wrong_connections_amount

func set_connected_server(server):
	self.connected_server = server
