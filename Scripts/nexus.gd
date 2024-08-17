extends StaticBody2D
class_name Nexus

var _connection_points: Array

func connect_cable(start_point: ConnectionPoint):
	var connection_point = ConnectionPoint.new()
	connection_point.interact(start_point)
	add_child(connection_point)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
