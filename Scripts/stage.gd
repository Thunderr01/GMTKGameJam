extends Node
class_name Stage

# random number between event_delay_min and event_delay_max is gonna be used
# as timer until next events run
@export var event_delay_min: float = 2.0
@export var event_delay_max: float = 3.0

# random number between event_run_min and event_run_max is gonna be used to
# spawn that amount of events each time the timer runs out
@export var event_run_min: int = 1
@export var event_run_max: int = 1


@export var connection_events: int

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
	_events = get_children()
	_events.erase(_timer)
	_timer.wait_time = randf_range(event_delay_min, event_delay_max)
	_timer.start()
	pass
	
func _timeout_spawn_events():
	
	var events_to_run = randi_range(event_run_min, event_run_max)
	for i in events_to_run:
		var event = _events.pick_random()
		#finished all the events
		if event == null:
			return
		# start the event and remove it from the array
		event.start_event()
		_events.erase(event)
	
	_timer.wait_time = randf_range(event_delay_min, event_delay_max)
	_timer.start()
	
	
