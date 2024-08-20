extends Node2D

const SCORE_FOR_CORRECT_CONNECTION: int = 2
const PENALTY_FOR_WRONG_CONNECTION: int = 1


func get_connections_score() -> int:
	var connections_score: int = 0
	for server in get_children():
		connections_score += server.get_correct_connections_amount() * SCORE_FOR_CORRECT_CONNECTION
		connections_score -= server.get_wrong_connections_amount() * PENALTY_FOR_WRONG_CONNECTION
	return connections_score
