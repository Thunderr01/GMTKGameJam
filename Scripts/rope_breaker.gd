extends Node2D

var _rope_handlers: Dictionary = {}	
var _timers: Dictionary = {}

func _on_body_entered(body: Node2D) -> void:
	var rope_handler =  _rope_handlers.get(body)
	if rope_handler == null:
		var rope_handle = RopeHandle.new()
		rope_handle.rope_position = 0.5
		rope_handle.strength = 0.0
		rope_handle.precise = true
		
		rope_handle.rope_path = body.get_node("Rope").get_path()
		_rope_handlers[body] = rope_handle
		add_child(rope_handle)
		
		# create timer for breaking
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 0.3
		timer.autostart = true
		add_child(timer)
		_timers[body] = timer


func _on_body_exited(body: Node2D) -> void:
	var rope_handler =  _rope_handlers.get(body)
	if rope_handler != null:
		remove_child(rope_handler)
		_rope_handlers.erase(body)
		_timers.erase(body)

func _process(delta: float) -> void:
	for key in _timers.keys():
		if _timers[key].time_left == 0.0:
			key.break_cable()
			_rope_handlers.erase(key)
			_timers.erase(key)
