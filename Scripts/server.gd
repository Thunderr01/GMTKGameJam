class_name Server

extends StaticBody2D

var connected_server: Server
@onready var connection_point: ConnectionPoint = $ConnectionPoint
var is_blinking = false
var blink_color: Color

func _process(delta):
	if is_blinking:
		self.connection_point.blink(blink_color)

func set_connected_server(server):
	self.connected_server = server
	
func set_blinking_color(color: Color):
	blink_color = color

func set_is_blinking(value):
	self.is_blinking = value
