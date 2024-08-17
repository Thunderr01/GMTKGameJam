extends Node2D

var _rope_handlers: Dictionary = {}	
var _timers: Dictionary = {}

var collision_pos: Vector2

const STREACH_AMOUNT = 150
const BREAK_DURATION = 0.3

func set_collision_point(point: Vector2):
	collision_pos = point


func _on_body_entered(rope_body: Node2D) -> void:
	var rope_handler =  _rope_handlers.get(rope_body)
	if rope_handler == null:
		var rope_handle = RopeHandle.new()
		rope_handle.rope_position = 0.5
		rope_handle.strength = 0.5
		rope_handle.position = Vector2(0, 0)
		rope_handle.precise = true
		
		#rope_handle.position = (collision_pos - global_position) * 5
		var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
		rope_handle.position = input_direction.normalized() * STREACH_AMOUNT
		
		# Debug symbol for the handle position
		#var sprite = Sprite2D.new()
		#rope_handle.add_child(sprite)
		#sprite.texture = load("res://rope_examples/icon.svg")
		#sprite.scale = Vector2.ONE * 0.2
		#sprite.position = Vector2.ZERO
		# ---
		
		rope_handle.rope_path = rope_body.get_node("Rope").get_path()
		_rope_handlers[rope_body] = rope_handle
		add_child(rope_handle)
		
		# create timer for breaking
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = BREAK_DURATION
		timer.autostart = true
		add_child(timer)
		_timers[rope_body] = timer


func _on_body_exited(rope_body: Node2D) -> void:
	var rope_handler = _rope_handlers.get(rope_body)
	if rope_handler != null:
		remove_child(rope_handler)
		_rope_handlers.erase(rope_body)
		_timers.erase(rope_body)


func _process(delta: float) -> void:
	for key in _timers.keys():
		if _timers[key].time_left == 0.0:
			key.break_cable()
			_rope_handlers.erase(key)
			_timers.erase(key)
