extends Node2D

const SCORE_FOR_CORRECT_CONNECTION: int = 2
const PENALTY_FOR_WRONG_CONNECTION: int = 1


func get_connections_score() -> int:
	var connections_score: int = 0
	for server in get_children():
		connections_score += server.get_correct_connections_amount() * SCORE_FOR_CORRECT_CONNECTION
		connections_score -= server.get_wrong_connections_amount() * PENALTY_FOR_WRONG_CONNECTION
	return connections_score


func get_blinking_servers_count() -> int:
	var count = 0
	for server in get_children():
		count += server.get_blinking_connections_amount()
	return count


func get_connection_points():
	var connection_points = []
	for server in get_children():
		connection_points.append_array(server.get_connection_points())
	print("connections count: " + str(connection_points.size()))
	return connection_points
