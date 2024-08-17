extends Node2D

@onready var servers = $Servers
@onready var timer = $Timer
<<<<<<< HEAD
<<<<<<< HEAD
var available_colors = [Color.RED, Color.PURPLE, Color.ORANGE, Color.DEEP_PINK]
var used_colors = []
var rng = RandomNumberGenerator.new()
var time
var time_of_last_blinking = 0.0
var time_per_blink = 2.0
=======
var used_colors = []
var rng = RandomNumberGenerator.new()
var time
var time_since_last_blinking = 0.0
var time_per_blink = 10.0
>>>>>>> 2ffcf51 (created server class, started work on server choosing algorithm)
=======
var available_colors = [Color.RED, Color.PURPLE, Color.ORANGE, Color.DEEP_PINK]
var used_colors = []
var rng = RandomNumberGenerator.new()
var time
var time_of_last_blinking = 0.0
var time_per_blink = 2.0
>>>>>>> 2915dc2 (finished code and fixed bugs)

func _ready() -> void:
	timer.wait_time = 9999
	timer.start()

func _process(delta: float) -> void:
	time = timer.wait_time - timer.time_left
<<<<<<< HEAD
<<<<<<< HEAD
	if time - time_of_last_blinking >= time_per_blink:
		blink_two_servers()
		time_of_last_blinking += 10.0		
	
func blink_two_servers():
	var unblinking_servers = get_all_unblinking_servers()
	
	if unblinking_servers.size() < 2:
		return
		
=======
=======
	if time - time_of_last_blinking >= time_per_blink:
		blink_two_servers()
		time_of_last_blinking += 10.0		
>>>>>>> 2915dc2 (finished code and fixed bugs)
	
func blink_two_servers():
	var unblinking_servers = get_all_unblinking_servers()
<<<<<<< HEAD
>>>>>>> 2ffcf51 (created server class, started work on server choosing algorithm)
=======
	
	if unblinking_servers.size() < 2:
		return
		
>>>>>>> 2915dc2 (finished code and fixed bugs)
	var random_servers = get_two_random_servers(unblinking_servers)
	var server1: Server = random_servers[0]
	var server2: Server = random_servers[1]
	
	server1.set_connected_server(server2)
	server2.set_connected_server(server1)
	
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 2915dc2 (finished code and fixed bugs)
	var server1_color =  get_random_unused_color()
	server1.set_blinking_color(server1_color)
	used_colors.append(server1_color)
	var server2_color =  get_random_unused_color()
	server2.set_blinking_color(server1_color)
	used_colors.append(server2_color)
	
<<<<<<< HEAD
=======
>>>>>>> 2ffcf51 (created server class, started work on server choosing algorithm)
=======
>>>>>>> 2915dc2 (finished code and fixed bugs)
	server1.set_is_blinking(true)
	server2.set_is_blinking(true)

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
<<<<<<< HEAD
<<<<<<< HEAD
		server1_index = rng.randi_range(0, servers.size() - 1)
		server2_index = rng.randi_range(0, servers.size() - 1)	
		
	return [servers[server1_index], servers[server2_index]]
	
	
func get_random_unused_color():
	var chosen_color: Color
	
	while used_colors.has(chosen_color):
		chosen_color = available_colors[rng.randi_range(0, available_colors.size() - 1)]
		
	return chosen_color
=======
		server1_index = rng.randi_range(0, servers.size())
		server1_index = rng.randi_range(0, servers.size())	
		
	return [servers[server1_index], servers[server2_index]]
>>>>>>> 2ffcf51 (created server class, started work on server choosing algorithm)
=======
		server1_index = rng.randi_range(0, servers.size() - 1)
		server2_index = rng.randi_range(0, servers.size() - 1)	
		
	return [servers[server1_index], servers[server2_index]]
	
	
func get_random_unused_color():
	var chosen_color: Color
	
	while used_colors.has(chosen_color):
		chosen_color = available_colors[rng.randi_range(0, available_colors.size() - 1)]
		
	return chosen_color
>>>>>>> 2915dc2 (finished code and fixed bugs)
