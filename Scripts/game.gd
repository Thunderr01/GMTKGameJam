extends Node2D

@onready var servers = $Servers
@onready var timer = $Timer
var used_colors = []
var rng = RandomNumberGenerator.new()
var time
var time_since_last_blinking = 0.0
var time_per_blink = 10.0

func _ready() -> void:
	timer.wait_time = 9999
	timer.start()

func _process(delta: float) -> void:
	time = timer.wait_time - timer.time_left
	
func link_two_servers():
	var unblinking_servers = get_all_unblinking_servers()
	var random_servers = get_two_random_servers(unblinking_servers)
	var server1: Server = random_servers[0]
	var server2: Server = random_servers[1]
	
	server1.set_connected_server(server2)
	server2.set_connected_server(server1)
	
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
		server1_index = rng.randi_range(0, servers.size())
		server1_index = rng.randi_range(0, servers.size())	
		
	return [servers[server1_index], servers[server2_index]]
