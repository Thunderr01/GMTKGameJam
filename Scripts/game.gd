extends Node2D

@onready var servers = $Servers
@onready var timer = $Timer
var available_colors = [Color.RED, Color.PURPLE, Color.ORANGE, Color.DEEP_PINK]
var used_colors = []
var rng = RandomNumberGenerator.new()
var time
var time_of_last_blinking = 0.0
var time_per_blink = 2.0

func _ready():
	timer.wait_time = 9999
	timer.start()
	$ThemeBase.play()
	$ThemeEpic.play()
	$ThemeEpic.volume_db = -100

func _process(delta: float) -> void:
	if not $StageManager.is_stage_running() and $Servers.get_blinking_servers_count() == 0:
		print("next stage")
		$StageManager.next_level()
	
	#time = timer.wait_time - timer.time_left
	#if time - time_of_last_blinking >= time_per_blink:
		#print("NEXT LEVEL")
		#$StageManager.next_level()
		##blink_two_servers()
		#time_of_last_blinking += 10.0

func blink_two_servers():
	var unblinking_servers = get_all_unblinking_servers()

	if unblinking_servers.size() < 2:
		return

	var random_servers = get_two_random_servers(unblinking_servers)
	var server1: Server = random_servers[0]
	var server2: Server = random_servers[1]

	server1.set_connected_server(server2)
	server2.set_connected_server(server1)

	var server1_color =  get_random_unused_color()
	server1.set_blinking_color(server1_color)
	used_colors.append(server1_color)
	var server2_color =  get_random_unused_color()
	server2.set_blinking_color(server1_color)
	used_colors.append(server2_color)

	#server1.set_is_blinking(true)
	#server2.set_is_blinking(true)

func get_all_unblinking_servers():
	var unblinking_servers = []

	for server: Server in servers.get_children():
		if not server.is_blinking:
			unblinking_servers.append(server)

	return unblinking_servers

func get_two_random_servers(servers: Array):
	var server1_index = 0
	var server2_index = 0

	while server1_index == server2_index:
		server1_index = rng.randi_range(0, servers.size() - 1)
		server2_index = rng.randi_range(0, servers.size() - 1)	

	return [servers[server1_index], servers[server2_index]]


func get_random_unused_color():
	var chosen_color: Color

	while used_colors.has(chosen_color):
		chosen_color = available_colors[rng.randi_range(0, available_colors.size() - 1)]

	return chosen_color
