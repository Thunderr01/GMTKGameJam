class_name Server

extends StaticBody2D

var connected_server: Server
@export var _connection_points: Array[ConnectionPoint]

const HEAT_ANIMATION_START_TIME_S = 10
const HEAT_ANIMATION_END_TIME_S = 20
const MAX_SHAKE_AMOUNT = 10

const DEFAULT_SERVER_COLOR = Color.WHITE
const MAX_HEAT_SERVER_COLOR = Color.RED

var is_on_fire = false

func _ready() -> void:
	$FireTimer.timeout.connect(start_fire)

func _process(delta):
	var should_fire_timer_run = _should_fire_timer_run()
	var is_fire_timer_stopped = $FireTimer.is_stopped()		
	
	if should_fire_timer_run and is_fire_timer_stopped:
		$FireTimer.start(HEAT_ANIMATION_END_TIME_S)
	elif not should_fire_timer_run and not is_fire_timer_stopped:
		$ShakeParent.position = Vector2.ZERO
		$ShakeParent/Sprite2D.modulate = DEFAULT_SERVER_COLOR
		$FireTimer.stop()
	
	if should_fire_timer_run or is_on_fire:
		var heat_time_passed = HEAT_ANIMATION_END_TIME_S - $FireTimer.time_left
		var heat_state_percent = inverse_lerp(HEAT_ANIMATION_START_TIME_S, HEAT_ANIMATION_END_TIME_S, heat_time_passed)
		heat_state_percent = clampf(heat_state_percent, 0, 1)
		if is_on_fire:
			heat_state_percent = 1
		$ShakeParent.position = create_random_vector() * heat_state_percent * MAX_SHAKE_AMOUNT
		$ShakeParent/Sprite2D.modulate = lerp_color(DEFAULT_SERVER_COLOR, MAX_HEAT_SERVER_COLOR, heat_state_percent)

func _should_fire_timer_run():
	var should_run = false
	for connection_point in _connection_points:
		if connection_point.is_waiting_for_connection():
			should_run = true
	return should_run

func create_random_vector():
	return Vector2(randf_range(-1, 1), randf_range(-1, 1))

func lerp_color(a: Color, b: Color, t: float) -> Color:
	return a + (b - a) * t

func get_correct_connections_amount() -> int:
	var correct_connections_amount: int = 0
	for connection_point in _connection_points:
		if connection_point.has_correct_connection():
			correct_connections_amount += 1
	return correct_connections_amount
	
func get_wrong_connections_amount() -> int:
	var wrong_connections_amount: int = 0
	for connection_point in _connection_points:
		if connection_point.has_wrong_connection():
			wrong_connections_amount += 1
	return wrong_connections_amount

func set_connected_server(server):
	self.connected_server = server

func start_fire():
	is_on_fire = true
	pass
