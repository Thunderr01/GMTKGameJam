extends Node
class_name Stage

# random number between event_delay_min and event_delay_max is gonna be used
# as timer until next events run
@export var event_delay_min: float = 2.0
@export var event_delay_max: float = 3.0

var is_running: bool

var _events: Array
var _timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_events = get_children()
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.autostart = false
	_timer.timeout.connect(_timeout_spawn_events)
	add_child(_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_stage():
	is_running = true
	_events = get_children()
	_events.erase(_timer)
	
	if event_delay_max == 0:
		for event in _events:
			event.start_event()
		is_running = false
	else:
		_timer.wait_time = 0.1  # start stage immediately
		_timer.start()
	
func _timeout_spawn_events():
	var event = _events.pick_random()
	#finished all the events
	if event == null:
		is_running = false
		return
	# start the event and remove it from the array
	event.start_event()
	_events.erase(event)
	
	_timer.wait_time = randf_range(event_delay_min, event_delay_max)
	_timer.start()
	
	
