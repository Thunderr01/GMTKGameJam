class_name Server

extends StaticBody2D

var connected_server: Server
@onready var connection_point = $ConnectionPoint
var is_blinking = false
var blink_color: Color

func set_connected_server(server):
	self.connected_server = server

func set_is_blinking(value):
	self.is_blinking = value
