extends StaticBody2D
class_name Cable

signal break_cable_signal

var _connection_start: ConnectionPoint
var _connection_end: ConnectionPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass


## enables cable collision
func cable_connected():
	$WaitBeforeBreaking.start()
	for i in $RopeCollisionShapeGenerator._colliders:
		i.disabled = false
	
## disables cable collision
func cable_hanging():
	for i in $RopeCollisionShapeGenerator._colliders:
		i.disabled = true
	$RopeCollisionShapeGenerator.set_enable(false)

func break_cable():
	break_cable_signal.emit()
	pass
	

# Timer to start the collision checking, otherwise the cable instantly breaks
func _on_timer_timeout() -> void:
	$RopeCollisionShapeGenerator.set_enable(true)
	pass # Replace with function body.
